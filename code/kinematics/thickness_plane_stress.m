%--------------------------------------------------------------------------
% Computes the thickness in the deformed configuration for
% plane stress problems.
%--------------------------------------------------------------------------
function h  =  thickness_plane_stress(properties,j,matyp)
switch matyp
    case 4
         mu     = properties(2);
         lambda = properties(3);
         H      = properties(4);
         gamma  = 2*mu/(lambda+2*mu);
         J      = j^(gamma);
         h      = H*J/j;
    case {6,8}
         H      = properties(3);
         h      = H/j;
    otherwise
         h      = 1;
end