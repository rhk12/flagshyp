%--------------------------------------------------------------------------
% Determine the outward unit normal vector at the Gauss point.
%--------------------------------------------------------------------------
function  normal_vector = normal_vector_boundary(xlocal_boundary,dim,DN_Chi)
switch dim
    case 2
         dx_eta             = [xlocal_boundary*DN_Chi';0];      
         k                  = [0;0;1];
         normal_vector      = cross(dx_eta,k);
         normal_vector(3,:) = [];        
    case 3
         dx_chi             = xlocal_boundary*DN_Chi';
         normal_vector      = cross(dx_chi(:,1),dx_chi(:,2));
end



