%--------------------------------------------------------------------------
% Compute the shape functions and their derivatives 
% (with respect to the isoparametric domain) inside the element and on 
% faces (3D) or edges (2D). 
%--------------------------------------------------------------------------
function FEM = shape_functions_iso_derivs(QUADRATURE,FEM,dimension)
%--------------------------------------------------------------------------
% Initialise the shape functions and their derivatives inside the element (e)
% and on the faces/edges (f).
%--------------------------------------------------------------------------
Ne      = zeros(FEM.mesh.n_nodes_elem,QUADRATURE.element.ngauss);
DNe_chi = zeros(dimension,FEM.mesh.n_nodes_elem,QUADRATURE.element.ngauss);
Nf      = zeros(FEM.mesh.n_face_nodes_elem,QUADRATURE.boundary.ngauss);
DNf_chi = zeros(dimension-1,FEM.mesh.n_face_nodes_elem,QUADRATURE.boundary.ngauss);
%
for igauss = 1:QUADRATURE.element.ngauss  
    interpolation       = shape_functions_library(QUADRATURE.element.Chi(igauss,:),...
                                                   FEM.mesh.element_type);
    Ne(:,igauss)        = interpolation.N;
    DNe_chi(:,:,igauss) = interpolation.DN_chi;
end
for igauss = 1:QUADRATURE.boundary.ngauss
    interpolation       = shape_functions_library_boundary(QUADRATURE.boundary.Chi(igauss,:),...
                                                            FEM.mesh.element_type);
    Nf(:,igauss)        = interpolation.N;
    DNf_chi(:,:,igauss) = interpolation.DN_chi;
end

%--------------------------------------------------------------------------
% Store the information.
%--------------------------------------------------------------------------
FEM.interpolation.element.N       = Ne;
FEM.interpolation.element.DN_chi  = DNe_chi;
FEM.interpolation.boundary.N      = Nf;
FEM.interpolation.boundary.DN_chi = DNf_chi;
end



