%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim)
mu1             = properties(2);
mu2             = properties(4);
J               = kinematics.J;
F               = kinematics.F;

C               = F'*F;  % pg 4
B               = C';   % top pg 28

I1              = trace(C); % bottom pg 4
I1bar           = J^(-2/3)*I1; % top pg 5

I2              = 1/2*(I1^2 - trace(C^2)); %bottom pg 4
I2bar           = J^(-4/3)*I2;  % top pg 5

Kirchoff        = -1/3*(mu1*I1bar + 2*mu2*I2bar)*I - mu2*B^2 + (mu1 + mu2*Ibar)*B;
Cauchy          = J\Kirchoff;