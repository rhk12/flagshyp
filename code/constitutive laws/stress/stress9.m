%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(4);
lambda          = properties(3);
J               = kinematics.J;
F               = kinematics.F;
b               = kinematics.b;
C               = (F.')*(F);
C_bar           = (J^(-2/3))*C;
kappa           = lambda + (2/3)*mu;
I               = eye(size(J))
I1              = trace(C);
I1_bar          = (J^(-2/3))*I1;
I2              = (1/2)*((I1^2)-trace(C^2));
I2_bar          = (J^(-4/3))*I2;
S1              = (J^(1/3))*(J-1)*kappa*(C_bar^(-1));
S2              = (J^(-2/3)*[(-1/3)*(mu1*I1_bar+2*mu2*I2_bar)*(C_bar^(-1))+(mu1+mu2*I1_bar)*I-mu2*C_bar]
Kirchoff        = S1+S2;

Cauchy          = (J^(-1))*Kirchoff


end