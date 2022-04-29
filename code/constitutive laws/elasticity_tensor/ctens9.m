%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons)
mu         = properties(2);
lambda     = properties(3);
J          = kinematics.J;
kappa          = lambda + (2/3)*mu;
F               = kinematics.F;
C               = F'*F;
mu2             =.01*mu
I1              = trace(C);
I1bar           = J^(-2/3)*I1;
I2              = (1/2)*(I1^2-trace(C^2));
I2bar           = J^(-4/3)*I2;
%calculate Fbar values to be used to calculate Bbar values
Fijbar     = J^(-1/3)*kinematics.F(i,j);
Fikbar     = J^(-1/3)*KINEMATICS.F(i,k);
Filbar     = J^(-1/3)*KINEMATICS.F(i,l);
Fjlbar     = J^(-1/3)*KINEMATICS.F(j,l);
Fjkbar     = J^(-1/3)*KINEMATICS.F(j,k);
Fklbar     = J^(-1/3)*KINEMATICS.F(k,l);
Bbarij     =Fijbar*transpose(Fijbar);
Bbarik     =Fikbar*transpose(Fikbar);
Bbaril     =Filbar*transpose(Filbar);
Bbarjl     =Fjlbar*transpose(Fjlbar);
Bbarjk     =Fjkbar*transpose(Fjkbar);
Bbarkl     =Fklbar*transpose(Fklbar);


cvol       = kappa*((J(2*J-1)*cons.IDENTITY_TENSORS.c1)-(J*(J-1)*cons.IDENTITY_TENSORS.c2));
ciso       = 2*mu2*((Bbarij*Bbarkl)-(.5*((Bbarik*Bbarjl)+(Bbaril*Bbarjk))))...
                -((2/3)*(mu+(2*mu2*I1bar))*(Bbarij*cons.I(k,l)+Bbarkl*cons.I(i,j)))...
                +(4/3)*(mu2*(Bbarij^2*cons.I(k,l)+Bbarkl^2*cons.I(i,j)))...
                +(2/9)*((mu*I1bar)+(4*mu2*I2bar))*cons.IDENTITY_TENSORS.c1...
                +(1/3)*((mu*I1bar)+(2*mu2*I2bar))*cons.IDENTITY_TENSORS.c2;


c          = cvol+ciso;
end


