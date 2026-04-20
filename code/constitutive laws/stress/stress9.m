%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor using the Mooney-Rivlin Model
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)


mu_1            = properties(1);
mu_2            = properties(2);

J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;

C_bar           = J^(-2/3)*(F'*F);
I1_bar          = J^(-2/3)*trace(b);
I2_bar          = J^(-4/3)*1/2*(I1_bar^2-trace(C_bar^2));
B_bar           = (J^(-2/3)*(F'*F))';

Cauchy = (1/J) * -(1/3) * (mu_1 * I1_bar + 2 * mu_2 * I2_bar) * (cons.I)^2 -mu_2*(B_bar)^2 + (mu_1 + mu_2 * I1) * B_bar - mu_2 * C * F;