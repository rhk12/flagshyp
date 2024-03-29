%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9. mu1, mu2, and k
% must be set in function prior to evaluation
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,cons)

mu1 = 0.595522*10^5;
mu2 = 0.050381*10^5;
k = 10^11;
J               = kinematics.J;
F               = kinematics.F;
C               = transpose(kinematics.F)*kinematics.F;  
Cbar            = J^(2/3)\C;
Bbar            =transpose(Cbar);
I1bar           = J^(2/3)\trace(C);
I2bar           = J^(4/3)\(1/2*(I1bar^2-trace(C^2)));
%Compute Pk2 stress
tvol = J*(J-1)*k*cons.I;
tiso= 1/3*(mu1*I1bar+2*mu2*I2bar)*cons.I-mu2*Bbar^2+(mu1+mu2*I1bar)*Bbar;
S = tvol+tiso;
%Compute Cauchy Stress
Cauchy         = 1/J*F*S*transpose(F);

end