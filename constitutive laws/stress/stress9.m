%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 8.
%--------------------------------------------------------------------------
function Cauchy = stress8(kinematics,properties,dim)
mu              = properties(2); %assume mu1 = mu2
kappa           = properties(3);
J               = kinematics.J;
F            = kinematics.F;
C            = F'*F;
Cbar         = (J^(-2/3)).*C;
Cbarinv      = inv(Cbar);
I1           = trace(C);
I2           = .5*(I1^2 - trace(C^2));
I1bar        = J^(-2/3)*I1;
I2bar        = J^(-4/3)*I2;
I            = eye(size(J));

Svol         = zeros(dim);
Siso         = zeros(dim);

Svol         = J^(1/3)*(J-1)*kappa*Cbarinv;
Siso         = J^(-2/3)*mu*(-1/3*(I1bar+2*I2bar)*Cbarinv + ...
    (1+I1bar)*I - Cbar)

S = Svol + Siso

Cauchy = J^-1*S

end
