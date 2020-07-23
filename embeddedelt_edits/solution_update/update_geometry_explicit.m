%--------------------------------------------------------------------------
% Update geometry.
%--------------------------------------------------------------------------
function x = update_geometry_explicit(x,x0,eta,displ,freedof)

x(freedof) = x0(freedof) + eta*displ;

end