%--------------------------------------------------------------------------
% Basic Arc-length Newton-Raphson incremental algorithm.
%--------------------------------------------------------------------------
function Arc_Length_Newton_Raphson_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,...
                            MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
%--------------------------------------------------------------------------
% Starts the load increment loop. 
%--------------------------------------------------------------------------
afail = CON.ARCLEN.afail;
arcln = CON.ARCLEN.arcln;
while ((CON.xlamb < CON.xlmax) && (CON.incrm < CON.nincr))
      %--------------------------------------------------------------------
      % Update the increment.  
      %--------------------------------------------------------------------
      CON.incrm = CON.incrm + 1;
      %--------------------------------------------------------------------
      % Update the load factor. The radius is adjusted to achieve target 
      % iterations per increment arbitrarily dampened by a factor of 0.7.
      %--------------------------------------------------------------------
      if (~afail && ~CON.ARCLEN.farcl)
         CON.ARCLEN.arcln = CON.ARCLEN.arcln*(CON.ARCLEN.itarget/...
                            CON.ARCLEN.iterold)^0.7;
         arcln            = CON.ARCLEN.arcln;
      end  
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
          %--------------------------------------------------------------------
          % Update nodal forces due to pressure. 
          %--------------------------------------------------------------------
          if LOAD.n_pressure_loads
              GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
                       GLOBAL,LOAD,QUADRATURE.boundary,CON.xlamb);
          end
      end
      %--------------------------------------------------------------------
      % Newton-Raphson iteration.       
      %--------------------------------------------------------------------
      CON.niter = 0;
      rnorm     = 2*CON.cnorm;
      while((rnorm > CON.cnorm) && (CON.niter < CON.miter))
          CON.niter = CON.niter + 1;
          %----------------------------------------------------------------
          % Solve for iterative displacements. 
          %----------------------------------------------------------------
          displ = linear_solver(GLOBAL.K,-GLOBAL.Residual,BC.fixdof);
          %----------------------------------------------------------------
          % Solve for displacements (for a nominal load). 
          %----------------------------------------------------------------
          dispf = linear_solver(GLOBAL.K,GLOBAL.nominal_external_load - GLOBAL.nominal_pressure,BC.fixdof);
          [displ,CON] = arclen(CON,displ,dispf);
          %----------------------------------------------------------------
          % Update coodinates.
          % -Recompute equivalent nodal forces and assembles residual force, 
          %  excluding pressure contributions.
          % -Recompute and assembles tangent stiffness matrix components, 
          %  excluding pressure contributions.
          %----------------------------------------------------------------
          GEOM.x = update_geometry(GEOM.x,1,displ,BC.freedof);
          [GLOBAL,updated_PLAST] = residual_and_stiffness_assembly(CON.xlamb,...
           GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);
          %----------------------------------------------------------------
          % Update nodal forces due to pressure. 
          %----------------------------------------------------------------
          if LOAD.n_pressure_loads
              GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,...
                       GLOBAL,LOAD,QUADRATURE.boundary,CON.xlamb);
          end
          %----------------------------------------------------------------
          % Check for equilibrium convergence.         
          %----------------------------------------------------------------
          [rnorm,GLOBAL] = check_residual_norm(CON,BC,GLOBAL,BC.freedof);
          %----------------------------------------------------------------
          % Break iteration before residual gets unrealistic (e.g. NaN).
          %----------------------------------------------------------------
          if (abs(rnorm)>1e7 || isnan(rnorm))
              CON.ARCLEN.afail = 1;
              break;
          end
          %----------------------------------------------------------------
          % Update value of the old iteration number.
          %----------------------------------------------------------------
          CON.ARCLEN.iterold = CON.niter;          
      end      
      %--------------------------------------------------------------------
      % If convergence not achieved opt to restart from previous results or
      % terminate.
      %--------------------------------------------------------------------
      afail = CON.ARCLEN.afail;
      if( CON.niter >= CON.miter   ||  CON.ARCLEN.afail)          
        terminate = input(['Solution not converged. Do you want to '...
                           'terminate the program (y/n) ?: ' ' \n'],'s');
        if( strcmp(deblank(terminate),deblank('n')) || strcmp(deblank(terminate),deblank('N')))
            load(PRO.internal_restartfile_name);   
            fprintf(['Restart from previous step by decreasing '...
                     'the fixed arclength radius to half its '...
                     'initally fixed value. \n']);
            CON.ARCLEN.arcln = CON.ARCLEN.arcln/2;
        else
            afail = 1;
        end
      else      
        %------------------------------------------------------------------
        % If convergence was achieved, update and save internal variables.
        %------------------------------------------------------------------
        PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,BC,...
                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS); 
      end   
      %--------------------------------------------------------------------
      % If a failure occurs in the arc-length function, reduce the value of
      % the radius in the arc-length (CON.ARCLEN.arcln) to a 10th of the
      % previous value and automatically restart. This can cause
      % continuous looping.  
      %--------------------------------------------------------------------
      if afail      
         CON.ARCLEN.arcln = arcln/10;
         arcln = CON.ARCLEN.arcln;
      end          
end       
fprintf(' Normal end of PROGRAM flagshyp. \n');



 
