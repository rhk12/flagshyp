%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
% Utlizes Mooney-Rivlin
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties)
%*_b indicates bar notations
mu1             = properties(2);
mu2             = properties(4);
k               = properties(3);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;
C_b             = J^(-2/3)*C;
F_b             = J^(-1/3)*F;
I               = eye(size(J));
I1              = trace(C);
I2              = 0.5*(I1^2-trace(C^2));
I1_b            = J^(-2/3)*I1;
I2_b            = J^(-4/3)*I2;

Svol            = J^(1/3)*(J-1)*k*inv(C_b);
s1              = (-1/3)*(mu1*I1_b+2*mu2*I2_b)*inv(C_b);
s2              = (mu1+mu2*I1_b)*I;
s3              = mu2*C_b;
Siso            = J^(-2/3)*(s1+s2+s3);

kirchoff        = Svol + Siso;

Cauchy          = inv(J)*kirchoff;                


