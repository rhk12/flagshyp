%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9: Saint Venant
% Kirchhoff 
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu              = properties(2);  
lambda          = properties(3);
F               = kinematics.F;
J               =kinematics.J; 
C               = F'*F; 
kappa=lambda+2*mu/3; 
kappa/mu;
E= 1./2*(C-cons.I);
S=lambda*trace(E)*cons.I+2*mu*E; 
Cauchy          = 1/J*F*S*F'; 
end