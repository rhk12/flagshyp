%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 1.
%--------------------------------------------------------------------------
function Cauchy = stress1(kinematics,properties,cons)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
b               = kinematics.b;
k=properties(4);
u1=properties(5);
u2=properties(6);
F=kinematics.F;
C=F'*F;
Cbar= J^-2/3*C;
Svol=(J^1/3)*(J-1)*k*(inv(Cbar));
I1=trace(C);
I2=.5*(I1^2-trace(C^2));
I3=det(C);
I1bar=J^-2/3*I1;
I2bar=J^-4/3*I2;
I3bar=1;
Siso=J^-2/3*(-1/3(u1*I1bar+2*u2*I2bar)*inv(Cbar)+(u1+u2*I1bar)*cons.I-u2*Cbar);
S=Svol+Siso;

Cauchy          = 1/J*F*S*F';
end