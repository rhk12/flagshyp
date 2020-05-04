%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 1.
% Mooney-Rivlin
%--------------------------------------------------------------------------
function Cauchy = MVstress(kinematics,properties,cons)
% mu              = properties(2);
% lambda          = properties(3);
% J               = kinematics.J;
% b               = kinematics.b;
% E               = 0.5*(kinematics.F'*kinematics.F - cons.I);
% % compute pk2
% S               = lambda*trace(E)*cons.I + 2*mu*E;
% Cauchy          = kinematics.F*S*kinematics.F'

mu1          = properties(2);
mu2          = properties(4);
k            = properties(3);
J            = kinematics.J;
F            = kinematics.F;
C            = F'*F;
C_b          = J^(-2/3)*C;
iCb          = inv(C_b);
F_b          = J^(-1/3)*F;
I            = eye(size(J));
I1           = trace(C);
I2           = 0.5*(I1^2 - trace(C^2));
I1_b         = J^(-2/3)*I1;
I2_b         = J^(-4/3);
J43          = J^(-4/3);

%Stress Tensor Volumetric
Svol = (J^(1/3))*(J-1)*(C_b^(-1));
Tauv = F*Svol*F';
%Stress Tensor Isochoric
Siso = (J^(-2/3))*(-(1/3)*(mu1*I1_b+2*mu2*I2_b)*(C_b^(-1))+(mu1+mu2*I1_b)*I-mu2*C_b);
Tauiso = F*Siso*F';

sum = Tauv + Tauiso;

Cauchy = sum;
end








