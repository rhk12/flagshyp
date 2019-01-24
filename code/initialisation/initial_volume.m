%--------------------------------------------------------------------------    
% Calculate initial volume for data checking. 
% Additionally, essential for mean dilation algorithm.
%--------------------------------------------------------------------------
function GEOM = initial_volume(FEM,GEOM,QUADRATURE,MAT,KINEMATICS)
Ve      = zeros(FEM.mesh.nelem,1); 
V_total = 0;
for ielement=1:FEM.mesh.nelem
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    xlocal          = GEOM.x(:,global_nodes);              
    material_number = MAT.matno(ielement);                 
    matyp           = MAT.matyp(material_number);          
    properties      = MAT.props(:,material_number);        
    switch FEM.mesh.element_type
        case 'truss2'        
             area         = properties(4);  
             L            = norm(xlocal(:,2) - xlocal(:,1));    
             Ve(ielement) = area*L;                             
        otherwise
             %-------------------------------------------------------------
             % Compute gradients with respect to isoparametric coordinates.
             %-------------------------------------------------------------
             KINEMATICS = gradients(xlocal,xlocal,...
                                   FEM.interpolation.element.DN_chi,...
                                   QUADRATURE,KINEMATICS);
             for igauss = 1:QUADRATURE.ngauss
                 %---------------------------------------------------------
                 % Computes the thickness in the deformed configuration for
                 % plane stress problems.
                 %---------------------------------------------------------
                 thickness_factor  = thickness_plane_stress(properties,...
                                             KINEMATICS.J(igauss),matyp);            
                 JW = KINEMATICS.Jx_chi(igauss)*QUADRATURE.W(igauss)*thickness_factor; 
                 %---------------------------------------------------------
                 % Compute volume of an element of the mesh.
                 %---------------------------------------------------------
                 Ve(ielement) = Ve(ielement) + JW;
             end
    end
    %----------------------------------------------------------------------
    % Total volume of the mesh. 
    %----------------------------------------------------------------------
    V_total = V_total + Ve(ielement);
end
%--------------------------------------------------------------------------
% Save information in data structure.
%--------------------------------------------------------------------------
GEOM.Ve      = Ve;
GEOM.V_total = V_total;
fprintf('Total mesh volume is: %15.5f \n', GEOM.V_total)



