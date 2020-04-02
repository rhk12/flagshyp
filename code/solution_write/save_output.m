%--------------------------------------------------------------------------
% Save converged results into MATLAB and TXT files.
%--------------------------------------------------------------------------
function PLAST = save_output(updated_PLAST,PRO,FEM,GEOM,QUADRATURE,...
                 BC,MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS)                 
%--------------------------------------------------------------------------
% If convergence was achieved, update value of internal
% variables in plasticity (whether needed or not).
%--------------------------------------------------------------------------
PLAST = updated_PLAST;
%--------------------------------------------------------------------------
%  MATLAB save of converged solution, overwriting previous results.
%--------------------------------------------------------------------------
%save_restart_file(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
%                  GLOBAL,PLAST,KINEMATICS,'internal')
%--------------------------------------------------------------------------
%  MATLAB save of converged solution every CON.OUTPUT.incout increments.
%--------------------------------------------------------------------------
if ~mod(CON.incrm,CON.OUTPUT.incout)
    
    save_restart_file(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
                      GLOBAL,PLAST,KINEMATICS,'postrun')
end
%--------------------------------------------------------------------------
% TXT file save of converged solution every CON.OUTPUT.incout increments.
% - Coordinates, element connectivity and stress.
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
output(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
%output_vtk(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
output_vtu(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
output_textfile(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
end
