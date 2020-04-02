%----------------------------------------------------------------------
% Initialises kinematic variables and computes initial tangent matrix 
% and equivalent force vector, excluding pressure components.
%----------------------------------------------------------------------
function [GEOM,LOAD,GLOBAL,PLAST,KINEMATICS] = ...
         initialisation(FEM,GEOM,QUADRATURE,MAT,LOAD,CONSTANT,CON,GLOBAL)
%--------------------------------------------------------------------------    
% Initialisation of internal variables for plasticity.
%--------------------------------------------------------------------------    
check = (isempty((MAT.matyp(MAT.matyp==17)))*isempty((MAT.matyp(MAT.matyp==2))));
if check  
   PLAST = [];
else 
   switch FEM.mesh.element_type
       case 'truss2'
            PLAST.ep    = zeros(FEM.mesh.nelem,1);  
            PLAST.epbar = zeros(FEM.mesh.nelem,1);  
       otherwise
            PLAST.epbar = zeros(QUADRATURE.element.ngauss,FEM.mesh.nelem,1);       
            PLAST.invCp = reshape(repmat(eye(GEOM.ndime),1,...
                          QUADRATURE.element.ngauss*FEM.mesh.nelem),...
                          GEOM.ndime,GEOM.ndime,QUADRATURE.element.ngauss,...
                          FEM.mesh.nelem); 
   end                                        
end
%--------------------------------------------------------------------------    
% Initialise undeformed geometry and initial residual and external forces. 
%--------------------------------------------------------------------------    
GEOM.x0              = GEOM.x;
GLOBAL.Residual      = zeros(FEM.mesh.n_dofs,1);
GLOBAL.external_load = zeros(FEM.mesh.n_dofs,1); 

global explicit  % needs to be defined in order for explicit to be global
% Define velocity and accelerations for explicit method;
if (explicit == 1)
   % GLOBAL.velocities = zeros(GEOM.npoin,GEOM.ndime);
   % GLOBAL.accelerations = zeros(GEOM.npoin,GEOM.ndime);
    GLOBAL.velocities = zeros(FEM.mesh.n_dofs,1);
    GLOBAL.accelerations = zeros(FEM.mesh.n_dofs,1);
end

%--------------------------------------------------------------------------    
% Initialisation of kinematics. 
%--------------------------------------------------------------------------
KINEMATICS = kinematics_initialisation(GEOM,FEM,QUADRATURE.element);
%--------------------------------------------------------------------------    
% Calculate initial volume for data checking. 
% Additionally, essential for mean dilation algorithm.
%--------------------------------------------------------------------------
GEOM = initial_volume(FEM,GEOM,QUADRATURE.element,MAT,KINEMATICS);
%--------------------------------------------------------------------------    
% Compute the external force vector contribution due to gravity 
% (nominal value prior to load increment). 
%--------------------------------------------------------------------------    
if norm(LOAD.gravt)>0
   GLOBAL = gravity_vector_assembly(GEOM,FEM,QUADRATURE.element,LOAD,...
                                    MAT,GLOBAL,KINEMATICS);     
end
%--------------------------------------------------------------------------    
% Initialise external force vector contribution due to pressure
% (nominal value prior to load increment).
%--------------------------------------------------------------------------    
GLOBAL.nominal_pressure = zeros(FEM.mesh.n_dofs,1);
%--------------------------------------------------------------------------    
% Computes and assembles the initial tangent matrix and the initial  
% residual vector due to the internal contributions 
% (external contributions will be added later on). 
%--------------------------------------------------------------------------  
[GLOBAL,PLAST] = residual_and_stiffness_assembly(CON.xlamb,GEOM,MAT,FEM,GLOBAL,...
                                                 CONSTANT,QUADRATURE.element,PLAST,KINEMATICS); 
                                             
                                             
if(explicit ==1)     
    [GLOBAL] = mass_assembly(CON.xlamb,GEOM,MAT,FEM,GLOBAL,...
                          CONSTANT,QUADRATURE.element,PLAST,KINEMATICS);
end 


end

