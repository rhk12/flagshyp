function ExplicitDynamics_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,...
                                  CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
%--------------------------------------------------------------------------
% Explicit central diff. algorithm - Down and Back Wave Propagation
%--------------------------------------------------------------------------

% --- Step 1: Initialization & Manual Overrides ---
CON.xlamb = 1.0; % Apply 100% of prescribed loads/displacements
CON.incrm = 0;   

% --- Step 2: Initial Force Calculation ---
[GLOBAL,updated_PLAST] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC);

% --- Step 3: Initial Accelerations ---
GLOBAL.accelerations = (GLOBAL.external_load - GLOBAL.T_int) ./ diag(GLOBAL.M);

% --- Step 4: Time & Plotting Setup ---
Time = 0; 
% Manually set for wave to travel 1m down and 1m back in steel
tMax = 0.0004; 

prefactor = 0.8; % Verified stability prefactor
dt = prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT);

time_step_counter = 0;
nPlotSteps = 50; % Requesting 50 output files
nsteps_plot = max(1, round((tMax/dt) / nPlotSteps)); 

% --- Start Explicit Loop ---
while(Time < tMax)
    t_n = Time;
    t_np1 = Time + dt;
    dt_nphalf = dt; 
    t_nphalf = 0.5 * (t_np1 + t_n);
    
    % Step 5: First partial update of nodal velocities
    v_nphalf = GLOBAL.velocities + (t_nphalf - t_n) * GLOBAL.accelerations;
    
    % Step 7: Update nodal displacements AND geometry coordinates
    delta_disp = dt_nphalf * v_nphalf;
    GEOM.x = GEOM.x + reshape(delta_disp, GEOM.ndime, GEOM.npoin);
    
    % Step 6: Enforce prescribed displacement BCs
    if BC.n_prescribed_displacements > 0
        GEOM.x = update_prescribed_displacements_explicit(BC.dofprescribed,...
                 GEOM.x0, GEOM.x, CON.xlamb, BC.presc_displacement, t_np1, tMax);
    end
    
    % Step 8: Calculate internal forces at new geometry (t_np1)
    [GLOBAL,updated_PLAST] = getForce_explicit(CON.xlamb,...
            GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC);
    
    % Step 9: Compute accelerations at t_np1
    GLOBAL.accelerations = (GLOBAL.external_load - GLOBAL.T_int) ./ diag(GLOBAL.M);
    
    % Step 10: Second partial update of nodal velocities
    GLOBAL.velocities = v_nphalf + (t_np1 - t_nphalf) * GLOBAL.accelerations;
    
    % Update global time and counter
    Time = t_np1;
    time_step_counter = time_step_counter + 1;
    CON.incrm = time_step_counter; 

    % --- Step 13: Plotting to VTU ---
    if( mod(time_step_counter, nsteps_plot) == 0 )
        % Map current deformation to a global vector for Paraview
        GLOBAL.displacements = reshape(GEOM.x - GEOM.x0, [], 1);
        
        % Ensure Reactions are populated for output.m
        GLOBAL.Reactions = GLOBAL.Residual(BC.fixdof); 
        
        fprintf('Writing VTU Step %d | Time: %.2e\n', time_step_counter, Time);
        
        PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
                  MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);  
    end
    
    % Recalculate stable time step
    dt = prefactor * CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT);

    % Optional safety check to catch blow-ups early
    if any(abs(GLOBAL.accelerations) > 1e15)
        error('Solution blew up at Step %d. Check T_int zeroing.', time_step_counter);
    end
end 

fprintf('Simulation complete. Check your job folder for 50 VTU files.\n');
end
