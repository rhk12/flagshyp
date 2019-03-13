%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 18.
%--------------------------------------------------------------------------
function Cauchy = stress18(kinematics,properties,dim)
mu_1            = properties(1);
mu_2            = properties(2);
K               = properties(3);
J               = kinematics.J;
F               = kinematics.F;
F_bar           = J.^(-1/3)*F;
B_bar           = F_bar*F_bar';
I               = eye(2,2);
T               = kinematics.n;
I_1             = trace(T);
I_2             = 0.5*(I_1.^2 - trace(T.^2));
Cauchy          = (J-1)*K*I-(1/(3*J))*(mu_1*I_1+2*mu_2*I_2)*I-((mu_2*B_bar.^2)/J)...
                  +(1/J)*(mu_1+mu_2*I_1)*B_bar;
end