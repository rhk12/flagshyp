%--------------------------------------------------------------------------
% Basic Newton-Raphson incremental algorithm 
% (excluding line search and arc length).
%--------------------------------------------------------------------------
function ExplicitDynamics_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,...
                                  CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)
                              
%step 1 - iniitalization
%       - this is done in the intialisation.m file, line 68
CON.xlamb = 0;
CON.incrm = 0; 


%step 2 - getForce
[GLOBAL,updated_PLAST] = getForce_explicit(CON.xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS);
      
GLOBAL.T_int;

%step 3 - compute accelerations.
GLOBAL.accelerations = inv(GLOBAL.M)*(GLOBAL.external_load - GLOBAL.T_int);

                       
%--------------------------------------------------------------------------
% Starts the load increment loop. 
%--------------------------------------------------------------------------

fprintf(' Normal end of PROGRAM flagshyp. \n');
