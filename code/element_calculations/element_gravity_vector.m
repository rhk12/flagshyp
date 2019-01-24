%--------------------------------------------------------------------------
% Compute element force gravity vector for all but truss elements.
%--------------------------------------------------------------------------
function gravity_vector = element_gravity_vector(FEM,QUADRATURE,...
                    rho0_vector,xlocal,x0local,properties,matyp,KINEMATICS)
gravity_vector = zeros(FEM.mesh.n_nodes_elem,1);
density        = properties(1);
%--------------------------------------------------------------------------
% Compute gradients with respect to isoparametric coordinates.
%--------------------------------------------------------------------------
KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                       QUADRATURE,KINEMATICS);
for igauss=1:QUADRATURE.ngauss
    thickness_factor = thickness_plane_stress(properties,...
                       KINEMATICS.J(igauss),matyp);                
    JW = KINEMATICS.Jx_chi(igauss)*QUADRATURE.W(igauss)*thickness_factor;
    %----------------------------------------------------------------------
    % Compute element force gravity vector contribution from Gauss point.
    %----------------------------------------------------------------------
    gravity_vector = gravity_vector + FEM.interpolation.element.N(:,igauss)*JW;
end
gravity_vector = reshape(density*rho0_vector*gravity_vector',[],1);
