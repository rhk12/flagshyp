%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c  = ctens9(properties,cons)
mu          = properties(2);
lambda      = properties(3);


c1 = cons.IDENTITY_TENSORS.c1;   
c2 = cons.IDENTITY_TENSORS.c2;   

c = lambda*c1+mu*c2;
end


