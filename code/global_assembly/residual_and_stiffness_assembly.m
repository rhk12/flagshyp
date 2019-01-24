%--------------------------------------------------------------------------
% Computes and assemble residual force vector and global tangent stiffness
% matrix except surface (line) element pressure contributions.
%--------------------------------------------------------------------------
function [GLOBAL,updated_PLAST] = residual_and_stiffness_assembly(xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS)    
%--------------------------------------------------------------------------
% Initialisation of the updated value of the internal variables.
%--------------------------------------------------------------------------
updated_PLAST = PLAST;
%--------------------------------------------------------------------------
% Initialises the total external load vector except pressure contributions.
%--------------------------------------------------------------------------
GLOBAL.external_load = xlamb*GLOBAL.nominal_external_load;
%--------------------------------------------------------------------------
% Pre-allocation memory to indexi, indexj and data for sparse assembly of
% the stiffness matrix.
%--------------------------------------------------------------------------
switch FEM.mesh.element_type
  case 'truss2'
     n_components = FEM.mesh.nelem*FEM.mesh.n_dofs_elem^2; 
    otherwise
     n_components_mean_dilatation = ...
     MAT.n_nearly_incompressible*(FEM.mesh.n_dofs_elem^2);
     %
     n_components_displacement_based =  ...
     FEM.mesh.nelem*FEM.mesh.n_dofs_elem^2*QUADRATURE.ngauss+...
     FEM.mesh.nelem*(FEM.mesh.n_nodes_elem^2*GEOM.ndime)*QUADRATURE.ngauss;
     %
     n_components = n_components_mean_dilatation + ...
                    n_components_displacement_based;
end
%--------------------------------------------------------------------------
% Initialise counter for storing sparse information into 
% global tangent stiffness matrix.
%--------------------------------------------------------------------------
counter          = 1;                                        
indexi           = zeros(n_components,1);
indexj           = zeros(n_components,1);
global_stiffness = zeros(n_components,1); 
%
GLOBAL.T_int     = zeros(FEM.mesh.n_dofs,1);
%--------------------------------------------------------------------------
% Main element loop.
%--------------------------------------------------------------------------
for ielement=1:FEM.mesh.nelem
    %----------------------------------------------------------------------
    % Temporary variables associated with a particular element.
    %----------------------------------------------------------------------
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    material_number = MAT.matno(ielement);     
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number); 
    xlocal          = GEOM.x(:,global_nodes);                     
    x0local         = GEOM.x0(:,global_nodes);                       
    Ve              = GEOM.Ve(ielement);            
    %----------------------------------------------------------------------
    % Select internal variables within the element (plasticity).
    %----------------------------------------------------------------------
    PLAST_element = selecting_internal_variables_element(PLAST,matyp,ielement);    
    %----------------------------------------------------------------------
    % Compute internal force and stiffness matrix for an element.
    %----------------------------------------------------------------------    
    switch FEM.mesh.element_type
      case 'truss2'
       [T_internal,indexi,indexj,global_stiffness,counter,PLAST_element] = ...
        element_force_and_stiffness_truss(properties,xlocal,x0local,...
        global_nodes,FEM,PLAST_element,counter,indexi,indexj,...
        global_stiffness,GEOM);
      otherwise
       [T_internal,indexi,indexj,global_stiffness,counter,PLAST_element] = ...
        element_force_and_stiffness(FEM,xlocal,x0local,global_nodes,...
        Ve,QUADRATURE,properties,CONSTANT,GEOM.ndime,matyp,PLAST_element,...
        counter,KINEMATICS,indexi,indexj,global_stiffness);
    end
    %----------------------------------------------------------------------
    % Assemble element contribution into global internal force vector.   
    %----------------------------------------------------------------------
    GLOBAL.T_int = force_vectors_assembly(T_internal,global_nodes,...
                   GLOBAL.T_int,FEM.mesh.dof_nodes);
    %----------------------------------------------------------------------
    % Storage of updated value of the internal variables. 
    %----------------------------------------------------------------------    
    updated_PLAST = plasticity_storage(PLAST_element,updated_PLAST,matyp,...
                                       ielement);
end
%--------------------------------------------------------------------------
% Global tangent stiffness matrix sparse assembly except pressure contributions. 
%--------------------------------------------------------------------------
GLOBAL.K = sparse(indexi,indexj,global_stiffness);                
%--------------------------------------------------------------------------
% Compute global residual force vector except pressure contributions.
%--------------------------------------------------------------------------
GLOBAL.Residual = GLOBAL.T_int - GLOBAL.external_load;
end

 


 
