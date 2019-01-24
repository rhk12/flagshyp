%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 1.
%--------------------------------------------------------------------------
function Cauchy = stress1(kinematics,properties,cons)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
b               = kinematics.b;
Cauchy          = (mu/J)*(b - cons.I) + (lambda/J)*log(J)*cons.I;
end