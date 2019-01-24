%--------------------------------------------------------------------------    
% Compute the external force vector contribution due to gravity 
% (nominal value prior to load increment). 
%--------------------------------------------------------------------------    
function GLOBAL = gravity_vector_assembly(GEOM,FEM,QUADRATURE,LOAD,MAT,GLOBAL,KINEMATICS)
rho0_vector    = LOAD.gravt;      
gravity_vector = zeros(FEM.mesh.n_dofs,1);
for ielement = 1:FEM.mesh.nelem
    material_number = MAT.matno(ielement);     
    matyp           = MAT.matyp(material_number);
    properties      = MAT.props(:,material_number); 
    global_nodes    = FEM.mesh.connectivity(:,ielement); 
    xlocal          = GEOM.x(:,global_nodes);            
    x0local         = GEOM.x0(:,global_nodes); 
    %----------------------------------------------------------------------
    % Compute element force gravity vector.
    %----------------------------------------------------------------------
    switch FEM.mesh.element_type
        case 'truss2'
           local_vector = element_gravity_vector_truss(xlocal,...
                          rho0_vector,properties);
        otherwise           
           local_vector = element_gravity_vector(FEM,QUADRATURE,...
                          rho0_vector,xlocal,x0local,properties,matyp,...
                          KINEMATICS);
    end                                               
    %----------------------------------------------------------------------
    % Assemble element force gravity vector into global force gravity vector.
    %----------------------------------------------------------------------
    gravity_vector = force_vectors_assembly(local_vector,global_nodes,...
                     gravity_vector,FEM.mesh.dof_nodes);
end
%--------------------------------------------------------------------------
% Add gravity force vector contribution into nominal external force vector.
%--------------------------------------------------------------------------
GLOBAL.nominal_external_load = GLOBAL.nominal_external_load + gravity_vector;      
