%--------------------------------------------------------------------------
% Implements the line search algorithm.
%--------------------------------------------------------------------------
function [eta0, eta, rtu] = search(eta0,eta,rtu0,Residual,displ,freedof)
%--------------------------------------------------------------------------
% First evaluates the dot product of r by u.
%--------------------------------------------------------------------------
rtu = Residual(freedof)'*displ;
if (rtu==0.0d0)
   return;
end
rtu1  = (rtu - rtu0*(1 - eta))/(eta^2);
alpha = rtu0/rtu1;
eta0  = eta;
%--------------------------------------------------------------------------
% Takes different action depending on the value of alpha. For
% negative alpha obtains the root between (0,1). Otherwise finds
% the position of the minimum, provided that this is smaller than 1.
%--------------------------------------------------------------------------
if( alpha < 0.0d0 )
    q   = (alpha - sqrt(alpha*(alpha - 4))) / 2.0d0;
    eta = alpha/q;
elseif( alpha < 2.0d0);
    eta = alpha/2.0d0;
else
    eta = 1.0d0;
    rtu = 0.0d0;
end


 





