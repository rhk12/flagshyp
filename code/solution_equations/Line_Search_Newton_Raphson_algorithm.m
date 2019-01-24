%--------------------------------------------------------------------------
% Line-search Newton-Raphson incremental algorithm.
%--------------------------------------------------------------------------
function Line_Search_Newton_Raphson_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,...
         MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
%--------------------------------------------------------------------------
% Starts the load increment loop.
%--------------------------------------------------------------------------
while ((CON.xlamb < CON.xlmax) && (CON.incrm < CON.nincr))
      %--------------------------------------------------------------------
      % Update the increment.
      %--------------------------------------------------------------------
      CON.incrm = CON.incrm + 1;
      %--------------------------------------------------------------------
      % Update the load factor. 
      %--------------------------------------------------------------------
      CON.xlamb = CON.xlamb + CON.dlamb;
      %--------------------------------------------------------------------
      % Update nodal forces (excluding pressure) and gravity. 
      %--------------------------------------------------------------------
      [GLOBAL.Residual,GLOBAL.external_load] = ...
       external_force_update(GLOBAL.nominal_external_load,...
       GLOBAL.Residual,GLOBAL.external_load,CON.dlamb);
      %--------------------------------------------------------------------
      % Update nodal forces and stiffness matrix due to external pressure 
      % boundary face (line) contributions. 
      %--------------------------------------------------------------------      
      if LOAD.n_pressure_loads      
         GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
                  GLOBAL,LOAD,QUADRATURE.boundary,CON.dlamb);    
      end
      %--------------------------------------------------------------------
      % For the case of prescribed geometry update coodinates.
      % -Recompute equivalent nodal forces and assembles residual force, 
      % excluding pressure contributions.
      % -Recompute and assembles tangent stiffness matrix components, 
      % excluding pressure contributions.
      %--------------------------------------------------------------------
      if  BC.n_prescribed_displacements > 0
          GEOM.x = update_prescribed_displacements(BC.dofprescribed,...
                   GEOM.x0,GEOM.x,CON.xlamb,BC.presc_displacement);                                                       
          [GLOBAL,updated_PLAST] = residual_and_stiffness_assembly(CON.xlamb,...
           GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);
          %----------------------------------------------------------------
          % Update nodal forces due to pressure. 
          %----------------------------------------------------------------
          if LOAD.n_pressure_loads
              GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
                       GLOBAL,LOAD,QUADRATURE.boundary,CON.xlamb);
          end
      end
      %--------------------------------------------------------------------
      % Newton-Raphson iteration.     
      %--------------------------------------------------------------------
      CON.niter = 0;
      rnorm = 2*CON.cnorm;
      while((rnorm > CON.cnorm) && (CON.niter < CON.miter))
          CON.niter = CON.niter + 1;
          %----------------------------------------------------------------
          % Solve for iterative displacements. Also obtains the product r.u.
          %----------------------------------------------------------------
          [displ,rtu0] = linear_solver(GLOBAL.K,-GLOBAL.Residual,BC.fixdof);
          %----------------------------------------------------------------
          % Starts the line search iteration. The total number of line search
          % iterations is limited to msearch.  
          %----------------------------------------------------------------
          eta0  = 0;
          eta   = 1;   
          nsear = 0;  
          rtu   = rtu0*CON.searc*2;
          while((abs(rtu)  > abs(rtu0*CON.searc) ) && (nsear < CON.msearch))
              nsear = nsear + 1; 
              %------------------------------------------------------------
              % Update coodinates.
              % -Recompute equivalent nodal forces and assembles residual 
              %  force, excluding pressure contributions.
              % -Recompute and assembles tangent stiffness matrix components,
              %  excluding pressure contributions.
              %------------------------------------------------------------
              GEOM.x = update_geometry(GEOM.x,eta-eta0,displ,BC.freedof);
              [GLOBAL,updated_PLAST] = residual_and_stiffness_assembly(CON.xlamb,...
               GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);    
              %------------------------------------------------------------
              % Update nodal forces due to pressure. 
              %------------------------------------------------------------
              if LOAD.n_pressure_loads       
                 GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,...
                            FEM,GLOBAL,LOAD,QUADRATURE.boundary,CON.xlamb);    
              end
              %------------------------------------------------------------
              % Line-search algorithm.
              %------------------------------------------------------------
              [eta0,eta,rtu] = search(eta0,eta,rtu0,-GLOBAL.Residual,...
                                      displ, BC.freedof);
          end     
          %----------------------------------------------------------------
          % Check for equilibrium convergence.
          %----------------------------------------------------------------
          [rnorm,GLOBAL] = check_residual_norm(CON,BC,GLOBAL,BC.freedof);
          %----------------------------------------------------------------
          % Break iteration before residual gets unrealistic (e.g. NaN).
          %----------------------------------------------------------------
          if (abs(rnorm)>1e7 || isnan(rnorm))
              CON.niter=CON.miter;
              break;
          end         
      end      
      %--------------------------------------------------------------------
      % If convergence not achieved opt to restart from previous results or
      % terminate.
      %--------------------------------------------------------------------
      if( CON.niter >= CON.miter)          
        terminate = input(['Solution not converged. Do you want to '...
                           'terminate the program (y/n) ?: ' ' \n'],'s');
        if( strcmp(deblank(terminate),deblank('n')) || strcmp(deblank(terminate),deblank('N')))
            load(PRO.internal_restartfile_name);   
            fprintf(['Restart from previous step by decreasing '...
                     'the load parameter increment to half its '...
                     'initally fixed value. \n']);
            CON.dlamb = CON.dlamb/2;
        else
            error('Program terminated by user');
        end
      else
        %------------------------------------------------------------------
        % If convergence was achieved, update and save internal variables.
        %------------------------------------------------------------------
        PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);          
      end
end       
fprintf(' Normal end of PROGRAM flagshyp. \n');



 
