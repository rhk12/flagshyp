%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
%--------------------------------------------------------------------------
function c = ctens1(kinematics,properties,cons)
mu         = properties(2);
lambda     = properties(3);
J          = kinematics.J;
lambda_    = lambda/J;
mu_        = (mu - lambda*log(J))/J;
c          = lambda_*cons.IDENTITY_TENSORS.c1 + mu_*cons.IDENTITY_TENSORS.c2;
end


