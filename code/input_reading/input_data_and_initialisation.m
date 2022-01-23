%--------------------------------------------------------------------------
% -Welcomes the user and determines whether the problem is being
%  restarted or a data file is to be read. 
% -Reads all necessary input data.
% -Initialises kinematic variables and internal variables.
% -Compute initial tangent matrix and equivalent force vector, excluding
%  pressure component.
%-------------------------------------------------------------------------- 
function [PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,GLOBAL,...
          PLAST,KINEMATICS] = input_data_and_initialisation(basedir_fem,ansmlv,inputfile)
%--------------------------------------------------------------------------
% Welcomes the user and determines whether the problem is being
% restarted or a data file is to be read.
%-------------------------------------------------------------------------- 
PRO = welcome(basedir_fem,ansmlv,inputfile);
if( ~ PRO.rest )
    fid = PRO.fid_input;
    %----------------------------------------------------------------------
    % Read input file, see textbook for user instructions.
    %----------------------------------------------------------------------
    [FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,PRO,GLOBAL] = ...
     reading_input_file(PRO,fid);
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
    % Save into restart file.
    %----------------------------------------------------------------------
    cd(PRO.job_folder);
    save_restart_file(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
                      GLOBAL,PLAST,KINEMATICS,'internal')    
    %output_vtk(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS); 
    output_vtu(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
    output_textfile(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE.element,CONSTANT,KINEMATICS);
else 
    %----------------------------------------------------------------------
    % Load restart file.
    %----------------------------------------------------------------------
    cd(PRO.job_folder);
    load(PRO.restartfile_name);  
    %----------------------------------------------------------------------
    % -Computes equivalent nodal forces and assembles residual force, 
    %  excluding pressure contributions.
    % -Computes and assembles tangent stiffness matrix components, 
    %  excluding pressure contributions.
    %----------------------------------------------------------------------
    [GLOBAL,PLAST] = residual_and_stiffness_assembly(CON.xlamb,...
     GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);    
end
