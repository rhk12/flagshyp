%--------------------------------------------------------------------------
% Yield criterion for Von Mises plasticity.
%--------------------------------------------------------------------------
function f = Von_Mises_yield_function(tau,ep,ty0,H)
f = sqrt(3/2)*norm(tau,'fro') - (ty0 + H*ep); 