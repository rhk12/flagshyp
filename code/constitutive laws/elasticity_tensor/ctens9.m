%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
%--------------------------------------------------------------------------
function c = ctens1(kinematics,properties,cons)
mu         = properties(2);
lambda     = properties(3);
J          = kinematics.J;
lambda_    = lambda/J;
mu_        = (mu - lambda*log(J))/J;
k=properties(4);
u1=properties(5);
u2=properties(6);
F=kinematics.F;
B=F*F';
C=F'*F;
Cbar= J^-2/3*C;
Bbar=Cbar';
I1=trace(C);
I2=.5*(I1^2-trace(C^2));
I3=det(C);
I1bar=J^-2/3*I1;
I2bar=J^-4/3*I2;
I3bar=1;
cvol=k*(J*(2*J-1)*cons.IDENTITY_TENSORS.c1 - J*(J-1)*(cons.IDENTITY_TENSORS.c2+cons.IDENTITY_TENSORS.c3));
ciso=2*u2*(Bbar*cons.IDENTITY_TENSORS.c1-1/2*(Bbar*cons.IDENTITY_TENSORS.c3+Bbar*cons.IDENTITY_TENSORS.c3)) ...
    -2/3*(u1+2u2*I1bar)*(Bbar*cons.IDENTITY_TENSORS.c1+Bbarcons.IDENTITY_TENSORS.c1)+4/3*u2*(Bbar^2*cons.IDENTITY_TENSORS.c1+Bbar^2*cons.IDENTITY_TENSORS.c3)+ ...
    2/9*(u1*I1bar+4*u2*I2bar)*cons.IDENTITY_TENSORS.c1+1/3*(u1*I1bar+2*u2*I2bar)*(cons.IDENTITY_TENSORS.c2+cons.IDENTITY_TENSORS.c3))
c          = cvol+ciso;
end


