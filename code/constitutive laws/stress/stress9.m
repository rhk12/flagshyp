%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu1             = properties(1);
mu2             = properties(2);
kappa           = properties(3);
J               = kinematics.J;
b               = kinematics.b;
C = kinematics.F'*kinematics.F;
Cbar=(J^(-2/3))*C;
%% Invariants
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
Ibar1 = (J^(-2/3))*I1;
Ibar2 = (J^(-4/3))*I2;
%% pk2 stress
Svol = (J^(1/3))*(J-1)*kappa*1\Cbar;
Siso = (J^(-2/3))*((-1/3)*(mu1*Ibar1+2*mu2*Ibar2)*1\Cbar+(mu1+mu2*Ibar1)*cons.I-mu2*Cbar);
%% cauchy push forward
Cauchy          = (1/J)*kinematics.F*(Svol+Siso)*kinematics.F';
end