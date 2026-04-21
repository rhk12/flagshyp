%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 10.
%--------------------------------------------------------------------------
function Cauchy = stress10(kinematics,properties,cons)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
b               = kinematics.b;
F = kinematics.F;

% additions for Mooney Rivlin
k = 0.1; %approximate material constants as 1
mu1 = 0.1; %approximate material constants as 1
mu2 = 0.1; %approximate material constants as 1
C  = transpose(F)*F;
Cbar = J^(-2/3)*C;
Svol = J^(1/3)*(J-1)*k*inv(Cbar);
I1 = trace(b);
I1bar = J^(2/3).*I1;
I2 = 0.5.*((I1^2)-trace(b^2));
I2bar = J^(-4/3).*I2;
Sbar = (mu1 + mu2.*I1bar)*eye(cons)-mu2.*Cbar;
Siso = J^(-2/3).*((Sbar-(1/3).*(mu1.*I1bar+2.*mu2.*I2bar)).*inv(Cbar));
tau = F*(Svol+Siso)*transpose(F);

Cauchy = J^(-1)*(tau);
end