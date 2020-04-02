%--------------------------------------------------------------------------
% Computes and assemble residual force vector and global tangent stiffness
% matrix except surface (line) element pressure contributions.
%--------------------------------------------------------------------------
function [GLOBAL,updated_PLAST] = getForce_explicit(xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC)    
%--------------------------------------------------------------------------
% Initialisation of the updated value of the internal variables.
%--------------------------------------------------------------------------
updated_PLAST = PLAST;
%--------------------------------------------------------------------------
% Initialises the total external load vector except pressure contributions.
%--------------------------------------------------------------------------
GLOBAL.external_load = xlamb*GLOBAL.nominal_external_load;

counter          = 1;                                        

% Main element loop.
%--------------------------------------------------------------------------
for ielement=1:FEM.mesh.nelem
    %----------------------------------------------------------------------
    % GATHER Temporary variables associated with a particular element.
    %----------------------------------------------------------------------
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    material_number = MAT.matno(ielement);     
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number); 
    xlocal          = GEOM.x(:,global_nodes);                     
    x0local         = GEOM.x0(:,global_nodes);                       
    Ve              = GEOM.Ve(ielement);      
    v_e             = GLOBAL.velocities(global_nodes);
    a_e             = GLOBAL.accelerations(global_nodes);

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
       [T_internal,counter,PLAST_element] = ...
        InternalForce_explicit(FEM,xlocal,x0local,global_nodes,...
        Ve,QUADRATURE.element,properties,CONSTANT,GEOM.ndime,matyp,PLAST_element,...
        counter,KINEMATICS);
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
% GLOBAL.K = sparse(indexi,indexj,global_stiffness);               
%--------------------------------------------------------------------------
% Compute global residual force vector except pressure contributions.
%--------------------------------------------------------------------------
% GLOBAL.Residual = GLOBAL.T_int - GLOBAL.external_load;


% equ. 6.3.3. defines the residual as f_int - f_ext, but algorithm in  
% in box 6.1 gives f_n = f_ext - f_int ... 
GLOBAL.Residual = GLOBAL.T_int - GLOBAL.external_load;
GLOBAL.Reactions = GLOBAL.Residual(BC.fixdof) + GLOBAL.external_load(BC.fixdof);


end

 


 
