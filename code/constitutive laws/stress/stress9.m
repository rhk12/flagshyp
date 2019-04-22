%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties)
mu1             = properties(2);
mu2             = properties(4);
k               = properties(3);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;
C_bar           = J^(-2/3)*C;
F_bar           = J^(-1/3)*F;
I               = eye(size(J));
I1              = trace(C);
I2              = 0.5*(I1^2-trace(C^2));
I1_bar          = J^(-2/3)*I1;
I2_bar          = J^(-4/3)*I2;

S_vol            = J^(1/3)*(J-1)*k*inv(C_bar);
s1              = (-1/3)*(mu1*I1_bar+2*mu2*I2_bar)*inv(C_bar);
s2              = (mu1+mu2*I1_bar)*I;
s3              = mu2*C_bar;
S_iso            = J^(-2/3)*(s1+s2+s3);

kirchoff        = S_vol + S_iso;

Cauchy          = inv(J)*kirchoff;                



