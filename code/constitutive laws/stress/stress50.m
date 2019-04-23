%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 50.
%--------------------------------------------------------------------------
function Cauchy = stress50(kinematics,properties,cons,dimension)
mu              = properties(2);  
J               = kinematics.J;
b               = kinematics.b;
Ib              = kinematics.Ib;

switch dimension
    case 2
         Ib     = Ib + 1;
end

Cauchy          = (mu*J^(-5/3))*(b - 1/3*Ib*cons.I); 
%(6.55b) on page 171 and 312
end
