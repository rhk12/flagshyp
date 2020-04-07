%--------------------------------------------------------------------------
% Explicit central diff. algorithm 
%--------------------------------------------------------------------------
function ExplicitDynamics_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,...
                                  CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
                              
%step 1 - iniitalization
%       - this is done in the intialisation.m file, line 68
CON.xlamb = 0;
CON.incrm = 0; 

%step 2 - getForce
[GLOBAL,updated_PLAST] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC);

%step 3 - compute accelerations.
GLOBAL.accelerations = inv(GLOBAL.M)*(GLOBAL.external_load - GLOBAL.T_int);

velocities_half = zeros(FEM.mesh.n_dofs,1);
disp_n = zeros(FEM.mesh.n_dofs,1);

%step 4 - time update/iterations
Time = 0; 
tMax = .1; % in seconds
prefactor = 0.8;
dt= prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT); % in seconds
plot_counter  = 0;
time_step_counter = 0;
plot_counter = 0;
nPlotSteps = 20;
nSteps = round(tMax/dt);
nsteps_plot = round(nSteps/nPlotSteps);

% start explicit loop
while(Time<=tMax)
    t_n=Time;
    t_np1 = Time + dt;
    Time = t_np1; % update the time by adding full time step
    dt_nphalf = dt; % equ 6.2.1
    t_nphalf = 0.5 *(t_np1 + t_n); %equ 6.2.1
    
    % step 5 - update velocities
    velocities_half = GLOBAL.velocities + (t_nphalf - t_n) * GLOBAL.accelerations;
    % store old displacements for energy computation
    disp_prev = disp_n;
    % update nodal displacements 
    disp_n = disp_n + dt_nphalf *velocities_half;
    
    % step 6 - enforce displacement BCs
    
%   %--------------------------------------------------------------------
%   % Update nodal forces (excluding pressure) and gravity. 
%   %--------------------------------------------------------------------
%   [GLOBAL.Residual,GLOBAL.external_load] = ...
%    external_force_update(GLOBAL.nominal_external_load,...
%    GLOBAL.Residual,GLOBAL.external_load,CON.dlamb);
%   %--------------------------------------------------------------------
%   % Update nodal forces and stiffness matrix due to external pressure 
%   % boundary face (line) contributions. 
%   %--------------------------------------------------------------------      
%   if LOAD.n_pressure_loads      
%      GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
%               GLOBAL,LOAD,QUADRATURE.boundary,CON.dlamb);    
%   end
  %--------------------------------------------------------------------
  % For the case of prescribed geometry update coodinates.
  % -Recompute equivalent nodal forces and assembles residual force, 
  % excluding pressure contributions.
  % -Recompute and assembles tangent stiffness matrix components, 
  % excluding pressure contributions.
  %--------------------------------------------------------------------
  if  BC.n_prescribed_displacements > 0
      GEOM.x = update_prescribed_displacements_explicit(BC.dofprescribed,...
               GEOM.x0,GEOM.x,CON.xlamb,BC.presc_displacement,t_n,tMax);                                                       
%       [GLOBAL,updated_PLAST] = residual_and_stiffness_assembly(CON.xlamb,...
%        GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);
      %----------------------------------------------------------------
      % Update nodal forces due to pressure. 
      %----------------------------------------------------------------
%       if LOAD.n_pressure_loads
%           GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
%                    GLOBAL,LOAD,QUADRATURE.boundary,CON.xlamb);
%       end
  end
  
  % save internal force, to be used in energy computation
  fi_prev = GLOBAL.T_int;
  fe_prev = GLOBAL.external_load;
  
  %step 8 - getForce
  [GLOBAL,updated_PLAST] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC);
  
  % updated stable time increment based on current deformation     
  dt = prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT);
  
  %step 9 - compute accelerations.
  GLOBAL.accelerations = inv(GLOBAL.M)*(GLOBAL.external_load - GLOBAL.T_int);
  
  % step 10 second partial update of nodal velocities
  GLOBAL.velocities = velocities_half + (t_np1 - t_nphalf) * GLOBAL.accelerations;
  
  % step 11 check energy
  [energy_value, max_energy] = check_energy_explicit(PRO,FEM,CON,BC,GLOBAL,disp_n, disp_prev,GLOBAL.T_int,fi_prev,GLOBAL.external_load,fe_prev,t_n);
  
  % plot 
  if( mod(time_step_counter,nsteps_plot) == 0 )
      plot_counter = plot_counter +1;
      PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);  
  end
  
  time_step_counter = time_step_counter + 1;  
  
  % this is set just to get the removal of old vtu files in output.m
  % correct
  CON.incrm =  CON.incrm + 1;

  disp(['step = ',sprintf('%d', time_step_counter),'     time = ',... 
      sprintf('%.2e', t_n), ' sec.     dt = ', sprintf('%.2e', dt) ,...
      ' sec.'])
  
    
end % end on while loop

                       

fprintf(' Normal end of PROGRAM flagshyp. \n');
