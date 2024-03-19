%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 1.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
b               = kinematics.b;
%isochoric Mooney-Rivilin
k = lambda+2*mu/3;
k/mu;
C               =kinematics.F'*kinematics.F;
C_bar           =(J^(-2/3)*C);
S               =J^(-2/3)*((-1/3)*((mu*cons.I+2*mu*cons.I)*C_bar^-1+(mu+mu*cons.I)*cons.I-mu*C_bar));
Cauchy          =kinematics.F*S*kinematics.F';
end