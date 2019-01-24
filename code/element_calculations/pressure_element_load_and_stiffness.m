%--------------------------------------------------------------------------
% Compute boundary (UNIT pressure load) force vector and stiffness matrix
% contribution for a boundary (UNIT pressure load) element.
%--------------------------------------------------------------------------
function [R_pressure,indexi,indexj,global_stiffness,counter] = ...
          pressure_element_load_and_stiffness(properties,matyp,...
          xlocal_boundary,element_connectivity,dim,QUADRATURE,FEM,...
          counter,indexi,indexj,global_stiffness)
R_pressure = zeros(FEM.mesh.n_face_dofs_elem,1);  
for igauss=1:QUADRATURE.ngauss
    N      = FEM.interpolation.boundary.N(:,igauss);
    DN_chi = FEM.interpolation.boundary.DN_chi(:,:,igauss);
    %----------------------------------------------------------------------
    % Determine the outward unit normal vector at the Gauss point.
    %----------------------------------------------------------------------
    normal_vector = normal_vector_boundary(xlocal_boundary,dim,DN_chi);  
    W = QUADRATURE.W(igauss);
    %----------------------------------------------------------------------
    % Compute boundary (UNIT pressure load) force vector contribution.
    %----------------------------------------------------------------------
    T = normal_vector*FEM.interpolation.boundary.N(:,igauss)';  
    R_pressure = R_pressure + T(:)*W;
    %----------------------------------------------------------------------
    % Compute boundary (UNIT pressure load) stiffness matrix contribution.
    %----------------------------------------------------------------------
    [indexi,indexj,global_stiffness,counter] = ...
     pressure_load_matrix(FEM,element_connectivity,xlocal_boundary,dim,...
     N,DN_chi,W,counter,indexi,indexj,global_stiffness);
end








