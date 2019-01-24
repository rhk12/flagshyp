%--------------------------------------------------------------------------
% Save into restart file.
%--------------------------------------------------------------------------
function save_restart_file(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
                           GLOBAL,PLAST,KINEMATICS,option)      
switch option
    %----------------------------------------------------------------------
    % MATLAB save file stored and overwritten every increment
    % available for internal program restart.
    %----------------------------------------------------------------------
    case 'internal'
         filename = PRO.internal_restartfile_name;
    %----------------------------------------------------------------------
    % MATLAB save file stored every CON.OUTPUT.incout increment
    % available for external manual restart and output interrogation.
    %----------------------------------------------------------------------
    case 'postrun'
         filename = [PRO.restartfile_name(1:PRO.res_character_incr) num2str(CON.incrm) '-RESTART.MAT'];
         %-----------------------------------------------------------------
         % Do not save stiffness matrices (unnecessary to store).
         %-----------------------------------------------------------------
         GLOBAL.K = [];
         GLOBAL.K_pressure = [];
end                          
save(filename)
end

         