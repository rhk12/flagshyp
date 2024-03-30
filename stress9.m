%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for Mooney-Rivlin material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
k               = properties(4);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;

% Right Cauchy-Green Tensor
C = F'*F;
% Modified Right Cauchy-Green Tensor
Cbar = J^(-2/3)*C;
% Green-Lagrange Strain Tensor
E = (1/2) * (F' * F - cons.I);
% Find I1 and I2 (Defined Page 4)
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
% Find I1bar and I2bar (Defined Page 4)
I1bar=J^(-2/3)*I1;
I2bar = J^(-4/3)*I2;
% Compute volumetric part of the PK2 stress
Svol = J^(1/3)*(J-1)*k*Cbar^(-1);
% Compute the isochoric part of the PK2 stress
Siso = J^(-2/3)*((-1/3)*(mu1*I1bar+2*mu2*I2bar)*Cbar^(-1)+(mu1+mu2*I1bar)*cons.I-mu2*Cbar);
% PK2 Stress (Eqn. 8a)
S = Svol+Siso;
% Kirchhoff Stress
Kirchhoff = F * S * F';
% Find Cauchy Stress
Cauchy          = J^(-1)*Kirchhoff;

end