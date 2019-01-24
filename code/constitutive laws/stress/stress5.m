%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 5.
%--------------------------------------------------------------------------
function Cauchy = stress5(kinematics,properties,cons,dimension)
mu              = properties(2);  
J               = kinematics.J;
b               = kinematics.b;
Ib              = kinematics.Ib;
switch dimension
    case 2
         Ib     = Ib + 1;
end
Cauchy          = (mu*J^(-5/3))*(b - 1/3*Ib*cons.I); 
end