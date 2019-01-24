%--------------------------------------------------------------------------
% Boundary codes identification.
%--------------------------------------------------------------------------
function dof = boundary_codes(code,dim)
switch code
    case 0
         dof = [0;0;0];     
    case 1
         dof = [1;0;0];
    case 2
         dof = [0;1;0];
    case 3
         dof = [1;1;0];
    case 4
         dof = [0;0;1];        
    case 5
         dof = [1;0;1];
    case 6
         dof = [0;1;1];
    case 7
         dof = [1;1;1];
end
switch dim
    case 2
         dof(3) = [];     
end

