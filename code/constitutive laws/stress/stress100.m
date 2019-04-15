%--------------------------------------------------------------------------
% Computes the stress for following the Mooney-Rivlin model technique for material 100. 
%--------------------------------------------------------------------------
function Cauchy = stress18(kinematics,properties)

mu_1            = properties(2);
mu_2            = properties(3);
kappa           = properties(4);
F               = kinematics.F;
J               = kinematics.J;
Iden            = eye(length(J),length(J));
C               = transpose(F)*F;
I_1             = trace(C);
I_2             = 1/2*(trace(C)^2-trace(C^2));
B               = F * transpose(F);

% Find the Kirchhoff Stress (tau)
tau_vol         = J*(J-1)*kappa*Iden;
tau_iso         = -1/3*(mu_1*I_1+2*mu_2*I_2)*Iden-mu_2*B^2+(mu_1+mu_2*I_1)*B;

tau_combined    = tau_vol+tau_iso;

% Convert Kirchhoff Stress to Cauchy Stress

Cauchy          = inv(J)*tau_combined;
