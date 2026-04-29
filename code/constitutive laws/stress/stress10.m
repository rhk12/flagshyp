%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 10. (Mooney-Rivlin)
%--------------------------------------------------------------------------
function Cauchy = stress10(kinematics,properties,cons,dimension)
mu1             = properties(4);
mu2             = properties(5);
J               = kinematics.J;
b               = kinematics.b;
Ib              = kinematics.Ib;
IIb             = 1/2*(Ib^2 - trace(b*b));
bmod            = J^(-2/3)*kinematics.b;
Ibmod              = J^(-2/3)*Ib;
IIbmod             = J^(-4/3)*IIb;
% IIIb = 1; %det(b);


switch dimension
    case 2
         Ibmod     = Ibmod + 1;
end
%Cauchy          = (mu*J^(-5/3))*(b - 1/3*Ib*cons.I);

%%% Cauchy stress for Monney-Rivlin below....
tau = -1/3*(mu1*Ibmod + 2*mu2*IIbmod)*eye(3) - mu2*bmod*bmod + (mu1+mu2*Ibmod)*bmod; % Kirchhoff stress
Cauchy = tau/J;

end