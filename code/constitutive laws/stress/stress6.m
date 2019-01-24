%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 6.
%--------------------------------------------------------------------------
function Cauchy = stress6(kinematics,properties,cons)
mu              = properties(2);  
j               = kinematics.J;              
b               = kinematics.b;
Cauchy          = mu*(b - cons.I/j^2); 
end