%--------------------------------------------------------------------------
% Update nodal forces and stiffness matrix due to external pressure 
% boundary face (line) contributions. 
%--------------------------------------------------------------------------
function GLOBAL = pressure_load_and_stiffness_assembly(GEOM,MAT,FEM,GLOBAL,...
                 LOAD,QUADRATURE,xlamb)    
%--------------------------------------------------------------------------
% Initialise variables.
%--------------------------------------------------------------------------
GLOBAL.nominal_pressure = zeros(FEM.mesh.n_dofs,1);  
GLOBAL.R_pressure       = zeros(FEM.mesh.n_dofs,1);
GLOBAL.K_pressure       = sparse([],[],[],FEM.mesh.n_dofs,FEM.mesh.n_dofs);
%--------------------------------------------------------------------------
% Pre-allocation of memory for subsequent sparse assembly.
%--------------------------------------------------------------------------
% -Number of components of the vectors indexi, indexj and data.
n_components     = (FEM.mesh.n_face_dofs_elem^2*QUADRATURE.ngauss)*LOAD.n_pressure_loads;  
indexi           = zeros(n_components,1);
indexj           = zeros(n_components,1);
global_stiffness = zeros(n_components,1);
% -Initialise counter for storing sparse information into the tangent stiffness matrix.                                     
counter          = 1;  
%--------------------------------------------------------------------------
% Loop over all boundary (pressure load) elements.
%--------------------------------------------------------------------------
for ipressure=1:LOAD.n_pressure_loads    
    %----------------------------------------------------------------------
    % Intermediate variables associated to a particular element (ipressure).
    %----------------------------------------------------------------------
    element         = LOAD.pressure_element(ipressure);
    global_nodes    = FEM.mesh.connectivity_faces(:,element); 
    material_number = MAT.matno(element);                
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number);      
    xlocal_boundary = GEOM.x(:,global_nodes);            
    %----------------------------------------------------------------------
    % Compute boundary (UNIT pressure load) force vector and stiffness matrix 
    % contribution for a boundary (UNIT pressure load) element.
    %----------------------------------------------------------------------    
    counter0 = counter;
    [R_pressure_0,indexi,indexj,global_stiffness,...
     counter] = pressure_element_load_and_stiffness(properties,...
     matyp,xlocal_boundary,global_nodes,GEOM.ndime,QUADRATURE,FEM,counter,...
     indexi,indexj,global_stiffness); 
    %----------------------------------------------------------------------
    % Compute boundary (NOMINAL pressure load) force vector contribution 
    % for a boundary (NOMINAL pressure load) element.
    %----------------------------------------------------------------------
    nominal_pressure = LOAD.pressure(ipressure)*R_pressure_0; 
    %----------------------------------------------------------------------
    % Assemble boundary (NOMINAL pressure load) element force vector 
    % contribution into global force vector. 
    %----------------------------------------------------------------------   
    GLOBAL.nominal_pressure = force_vectors_assembly(nominal_pressure,...
    global_nodes,GLOBAL.nominal_pressure,FEM.mesh.dof_nodes);
    %----------------------------------------------------------------------
    % Compute boundary (CURRENT pressure load) element stiffness matrix 
    % contribution.
    %----------------------------------------------------------------------
    global_stiffness(counter0:counter-1) = LOAD.pressure(ipressure)*...
                                           xlamb*global_stiffness(counter0:counter-1);
end    
%--------------------------------------------------------------------------
% Assemble boundary (CURRENT pressure load) stiffness matrix.
%--------------------------------------------------------------------------
GLOBAL.K_pressure = sparse(indexi,indexj,global_stiffness,FEM.mesh.n_dofs,...
                           FEM.mesh.n_dofs);                
%--------------------------------------------------------------------------
% Add boundary (CURRENT pressure load) global force vector contribution 
% into Residual.
%--------------------------------------------------------------------------
GLOBAL.Residual = GLOBAL.Residual + xlamb*GLOBAL.nominal_pressure;
%--------------------------------------------------------------------------
% Substract (opposite to outward normal) boundary (CURRENT pressure load) 
% stiffness matrix into overall stiffness matrix.
%--------------------------------------------------------------------------
GLOBAL.K = GLOBAL.K - GLOBAL.K_pressure;  
