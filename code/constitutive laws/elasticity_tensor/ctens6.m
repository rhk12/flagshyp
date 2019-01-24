%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 6.
%--------------------------------------------------------------------------
function c   = ctens6(kinematics,properties,cons)
mu           = properties(2);
j            = kinematics.J;
mu_prime     = mu/j^2;
lambda_prime = 2*mu/j^2;
D1           = cons.IDENTITY_TENSORS.c1;  
D2           = cons.IDENTITY_TENSORS.c2;  
c            = lambda_prime*D1 + mu_prime*D2;
end


