%--------------------------------------------------------------------------
% Radial return algorithm. Return Dgamma (increment in the plastic
% multiplier) and the direction vector nua.
%--------------------------------------------------------------------------
function [Dgamma,nua] = radial_return_algorithm(f,tau_trial,tauaa_trial,mu,H)  
denominator = sqrt(2/3)*norm(tau_trial,'fro');  
nua         = tauaa_trial/denominator;          
Dgamma      = f/(3*mu+H);                       
