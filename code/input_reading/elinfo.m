%--------------------------------------------------------------------------
% Read and construct element type data. 
%--------------------------------------------------------------------------
function [FEM,GEOM,QUADRATURE]                 = elinfo(fid)                
FEM.mesh.element_type                          = strtrim(fgets(fid));
switch FEM.mesh.element_type
    case 'truss2'
         GEOM.ndime                            = 3;
         FEM.mesh.n_nodes_elem                 = 2;        
         QUADRATURE.element                    = [];
         QUADRATURE.boundary                   = [];         
         FEM.mesh.n_face_nodes_elem            = 0;
         FEM.mesh.n_face_dofs_elem             = 0; 
    case 'tria3'
         GEOM.ndime                            = 2;
         FEM.mesh.n_nodes_elem                 = 3;
         FEM.mesh.n_face_nodes_elem            = 2;
         QUADRATURE.element.polynomial_degree  = 1; 
         QUADRATURE.boundary.polynomial_degree = 1;          
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
    case 'tria6'
         GEOM.ndime                            = 2;
         FEM.mesh.n_nodes_elem                 = 6;
         FEM.mesh.n_face_nodes_elem            = 3;
         QUADRATURE.element.polynomial_degree  = 2; 
         QUADRATURE.boundary.polynomial_degree = 2; 
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
    case 'quad4'
         GEOM.ndime                            = 2;
         FEM.mesh.n_nodes_elem                 = 4;
         FEM.mesh.n_face_nodes_elem            = 2;
         QUADRATURE.element.polynomial_degree  = 1; 
         QUADRATURE.boundary.polynomial_degree = 1; 
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
    case 'tetr4'
         GEOM.ndime                            = 3;
         FEM.mesh.n_nodes_elem                 = 4;
         FEM.mesh.n_face_nodes_elem            = 3;
         QUADRATURE.element.polynomial_degree  = 1; 
         QUADRATURE.boundary.polynomial_degree = 1; 
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
    case 'tetr10'
         GEOM.ndime                            = 3;
         FEM.mesh.n_nodes_elem                 = 10;
         FEM.mesh.n_face_nodes_elem            = 6;
         QUADRATURE.element.polynomial_degree  = 2; 
         QUADRATURE.boundary.polynomial_degree = 2; 
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
    case 'hexa8'
         GEOM.ndime                            = 3;
         FEM.mesh.n_nodes_elem                 = 8;
         FEM.mesh.n_face_nodes_elem            = 4;
         QUADRATURE.element.polynomial_degree  = 1; 
         QUADRATURE.boundary.polynomial_degree = 1; 
         FEM.mesh.n_face_dofs_elem             = ...
         FEM.mesh.n_face_nodes_elem*GEOM.ndime; 
end
FEM.mesh.n_dofs_elem                           = ...
FEM.mesh.n_nodes_elem*GEOM.ndime;     
end
