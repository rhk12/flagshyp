function [GLOBAL,updated_PLAST] = getForce_explicit(xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS,BC)    

updated_PLAST = PLAST;
GLOBAL.external_load = xlamb*GLOBAL.nominal_external_load;

% CRITICAL: Zero out internal force vector before element loop assembly
GLOBAL.T_int = zeros(size(GLOBAL.external_load));

for ielement=1:FEM.mesh.nelem
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    material_number = MAT.matno(ielement);     
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number); 
    xlocal          = GEOM.x(:,global_nodes);                     
    x0local         = GEOM.x0(:,global_nodes);                       
    Ve              = GEOM.Ve(ielement);      

    PLAST_element = selecting_internal_variables_element(PLAST,matyp,ielement);    
    
    [T_internal,counter,PLAST_element] = ...
        InternalForce_explicit(FEM,xlocal,x0local,global_nodes,...
        Ve,QUADRATURE.element,properties,CONSTANT,GEOM.ndime,matyp,PLAST_element,...
        1,KINEMATICS);

    % Assemble element forces into global vector
    GLOBAL.T_int = force_vectors_assembly(T_internal,global_nodes,...
                   GLOBAL.T_int,FEM.mesh.dof_nodes);

    updated_PLAST = plasticity_storage(PLAST_element,updated_PLAST,matyp,ielement);
end

% Compute global residual force vector for diagnostics and reactions
GLOBAL.Residual = GLOBAL.T_int - GLOBAL.external_load;
GLOBAL.Reactions = GLOBAL.Residual(BC.fixdof); 

end
