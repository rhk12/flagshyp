%A bunch of pieces of flagshyp smashed together so I can actually figure
%out what all of the variables are. This may be a disaster
clear;clc; close all;
inputfile='explicit_embedded3D.dat';
inputfile='explicit_embedded_4el.dat';
basedir_fem='C:/Users/Valerie/Documents/GitHub/flagshyp/embeddedelt_edits/';
ansmlv='y';
global explicit ;
explicit = 1;
tic
%% Input_data_and_initilaization.m

%--------------------------------------------------------------------------
% -Welcomes the user and determines whether the problem is being
%  restarted or a data file is to be read. 
% -Reads all necessary input data.
% -Initialises kinematic variables and internal variables.
% -Compute initial tangent matrix and equivalent force vector, excluding
%  pressure component.
%-------------------------------------------------------------------------- 
% function [PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,GLOBAL,...
%           PLAST,KINEMATICS] = input_data_and_initialisation(basedir_fem,ansmlv,inputfile)
%--------------------------------------------------------------------------
% Welcomes the user and determines whether the problem is being
% restarted or a data file is to be read.
%-------------------------------------------------------------------------- 
    PRO = welcome(basedir_fem,ansmlv,inputfile);
    fid = PRO.fid_input;
    %----------------------------------------------------------------------
    % Read input file, see textbook for user instructions.
    %----------------------------------------------------------------------
%     [FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,PRO,GLOBAL] = ...
%      reading_input_file(PRO,fid);
%--------------------------------------------------------------------------
        % Read input data.
        %--------------------------------------------------------------------------
%         function [FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,PRO,GLOBAL] = ...
%                   reading_input_file(PRO,fid)
        %--------------------------------------------------------------------------
        % Problem title.   
        %--------------------------------------------------------------------------
        PRO.title = strtrim(fgets(fid));
        %--------------------------------------------------------------------------
        % Element type.    
        %--------------------------------------------------------------------------
        [FEM,GEOM,QUADRATURE] = elinfo(fid);    
        %--------------------------------------------------------------------------
        % Obtain quadrature rules, isoparametric shape functions and their  
        % derivatives for the internal and boundary elements.
        %--------------------------------------------------------------------------
        switch FEM.mesh.element_type
            case 'truss2'
              FEM.interpolation.element = [];
              FEM.interpolation.boundary = [];
            otherwise
              QUADRATURE.element = element_quadrature_rules(FEM.mesh.element_type);
              QUADRATURE.boundary = edge_quadrature_rules(FEM.mesh.element_type);
              FEM = shape_functions_iso_derivs(QUADRATURE,FEM,GEOM.ndime);
        end
        %--------------------------------------------------------------------------
        % Read the number of mesh nodes, nodal coordinates and boundary conditions.  
        %--------------------------------------------------------------------------
        [GEOM,BC,FEM] = innodes(GEOM,fid,FEM);
        %--------------------------------------------------------------------------
        % Read the number of elements, element connectivity and material number.
        %--------------------------------------------------------------------------
        [FEM,MAT] = inelems(FEM,fid);
        %--------------------------------------------------------------------------
        % Obtain fixed and free degree of freedom numbers (dofs).
        %--------------------------------------------------------------------------
        BC = find_fixed_free_dofs(GEOM,FEM,BC);
        %--------------------------------------------------------------------------
        % Read the number of materials and material properties.  
        %--------------------------------------------------------------------------
        MAT = matprop(MAT,FEM,fid); 
        %--------------------------------------------------------------------------
        % Read nodal point loads, prescribed displacements, surface pressure loads
        % and gravity (details in textbook).
        %--------------------------------------------------------------------------
        [LOAD,BC,FEM,GLOBAL] = inloads(GEOM,FEM,BC,fid);
        %--------------------------------------------------------------------------
        % Read control parameters.
        %--------------------------------------------------------------------------
        CON = incontr(BC,fid);
        fclose('all'); 
        

        %----------------------------------------------------------------------
    % Obtain entities which will be constant and only computed once.
    %----------------------------------------------------------------------
    CONSTANT = constant_entities(GEOM.ndime);
    %----------------------------------------------------------------------
    % Initialise load and increment parameters.
    %----------------------------------------------------------------------
    CON.xlamb = 0;
    CON.incrm = 0; 
    %----------------------------------------------------------------------
    % Initialises kinematic variables and compute initial tangent matrix 
    % and equivalent force vector, excluding pressure component.
    %----------------------------------------------------------------------
    [GEOM,LOAD,GLOBAL,PLAST,KINEMATICS] = ...
     initialisation(FEM,GEOM,QUADRATURE,MAT,LOAD,CONSTANT,CON,GLOBAL);                                           
    %----------------------------------------------------------------------
    % |-/
    % Identify host element/embedded node pairs and find natural
    % coordinates of embedded nodes, if there are embedded elements
    tic
    if ~isempty(FEM.mesh.embedded)
        GEOM = nodes_in_host(GEOM,FEM,BC.tienodes);
    end
    toc
    %|-/
    %----------------------------------------------------------------------
    % Save into restart file.
    %----------------------------------------------------------------------
    cd(PRO.job_folder);
    save_restart_file(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
                      GLOBAL,PLAST,KINEMATICS,'internal')    
    %output_vtk(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS); 
    output_vtu(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);


%% ExplicitDynamics_algorithm
%--------------------------------------------------------------------------
% Explicit central diff. algorithm 
%--------------------------------------------------------------------------
% function ExplicitDynamics_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,...
%                                   CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
 digits
d1=digits(64);
 digits
%step 1 - iniitalization
%       - this is done in the intialisation.m file, line 68
CON.xlamb = 0;
CON.incrm = 0; 

%step 2 - getForce
[GLOBAL,updated_PLAST,GEOM.Jn_1] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC,1);      
      
%step 3 - compute accelerations.
GLOBAL.accelerations = inv(GLOBAL.M)*(GLOBAL.external_load - GLOBAL.T_int);

velocities_half = zeros(FEM.mesh.n_dofs,1);
disp_n = zeros(FEM.mesh.n_dofs,1);

%step 4 - time update/iterations
Time = 0; 
tMax = 0.01; % in seconds
prefactor = 0.8;
dt= prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT); % in seconds
plot_counter  = 0;
time_step_counter = 0;
plot_counter = 0;
nPlotSteps = 20 ;
nSteps = round(tMax/dt);
nsteps_plot = round(nSteps/nPlotSteps);

testfid = fopen('AVD_Check.txt','w');


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
    
%  fprintf("Acc"); disp(GLOBAL.accelerations(BC.freedof));
%  fprintf("Vel"); disp(velocities_half(BC.freedof));
%----------------------------------------------------------------
% Update coodinates.
  displ = disp_n-disp_prev; 
  GEOM.x = update_geometry(GEOM.x,1,displ(BC.freedof),BC.freedof);

%----------------------------------------------------------------
    
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
%       GEOM.x = update_prescribed_displacements_explicit(BC.dofprescribed,...
%                GEOM.x0,GEOM.x,CON.xlamb,BC.presc_displacement,t_n,tMax); 
       GEOM.x = update_prescribed_displacements_explicit(BC.dofprescribed,...
                BC.tiedof, BC.tienodes,FEM.mesh.element_type,GEOM.ndime, ...
                FEM.mesh,GEOM.x0,GEOM.x,CON.xlamb,BC.presc_displacement,t_n,tMax);   
%      |-/
%      Update coodinates of embedded nodes (if there are any)  
          if ~isempty(FEM.mesh.embedded)
              GEOM.x = update_embedded_displacements_explicit(BC.tiedof, BC.tienodes,...
                    FEM.mesh,GEOM); 
          end
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
  [GLOBAL,updated_PLAST,GEOM.Jn_1] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC,dt);
  
  % updated stable time increment based on current deformation     
  dt_old=dt;
  dt = prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT);
  
  %step 9 - compute accelerations.       
  AccOld = GLOBAL.accelerations;
  GLOBAL.accelerations = inv(GLOBAL.M)*(GLOBAL.external_load - GLOBAL.T_int);
  
  % step 10 second partial update of nodal velocities
  VelOld = GLOBAL.velocities;
  GLOBAL.velocities = velocities_half + (t_np1 - t_nphalf) * GLOBAL.accelerations;
  
%--------------------------------------------------------------
  
  % step 11 check energy
  [energy_value, max_energy] = check_energy_explicit(PRO,FEM,CON,BC,GLOBAL,disp_n, disp_prev,GLOBAL.T_int,fi_prev,GLOBAL.external_load,fe_prev,t_n);
  
  % plot 
%   if( mod(time_step_counter,nsteps_plot) == 0 )
%       plot_counter = plot_counter +1;
%       PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
%                 MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);  
%   end
%Plot every 4 steps
  if( mod(time_step_counter,1) == 0 )
      plot_counter = plot_counter +1;
      PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);  
  end
  
  time_step_counter = time_step_counter + 1;  
  
  % this is set just to get the removal of old vtu files in output.m
  % correct
  CON.incrm =  CON.incrm + 1;

    disp(['step = ',sprintf('%d', time_step_counter-1),'     time = ',... 
  sprintf('%.2e', t_n), ' sec.     dt = ', sprintf('%.2e', dt_old) ,...
  ' sec.'])


fprintf(testfid, '\nstep = %d     time = %.2e     dt = %.2e\n',time_step_counter-1,t_n,dt_old);
formt = [repmat('% -1.4E ',1,3) '\n'];
% fprintf(testfid,'T_int\n');
% for i=1:24
%     switch i
%         case {1 3 4 6 7 10 15 18}
%             fprintf(testfid,'% -1.4E \n', GLOBAL.T_int(i));
%         otherwise
%             fprintf(testfid,'     % -1.4E \n', GLOBAL.T_int(i));
%     end
% end
% fprintf(testfid,'Acc\n');
% for i=1:3:24
%     fprintf(testfid,formt, AccOld(i:i+2));
% end
% fprintf(testfid,'Acc n\n');
% for i=1:3:24
%     fprintf(testfid,formt, GLOBAL.accelerations(i:i+2));
% %     fprintf(testfid,formt, eps(GLOBAL.accelerations(i:i+2)));
% end
% fprintf(testfid,'Vel\n');
% for i=1:3:24
%     fprintf(testfid,formt, VelOld(i:i+2));
% end
fprintf(testfid,'Displacment\n');
for i=1:FEM.mesh.n_dofs/3
    fprintf(testfid,formt, GEOM.x(:,i)-GEOM.x0(:,i));
end
% fprintf(testfid,'GEOM.x\n');
% for i=1:8
%     fprintf(testfid,formt, GEOM.x(:,i));
% end


  if mod(time_step_counter,5)==0

%   disp_n(BC.freedof)
%       disp(GEOM.x(:,1:8))
%       disp(GEOM.x(BC.freedof))
%       disp(disp_prev(1:24)-disp_n(1:24))
  end
    
end % end on while loop

% fclose(testfid);                       

fprintf(' Normal end of PROGRAM flagshyp. \n');

toc
digits(d1);