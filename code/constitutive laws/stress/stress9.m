%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for Mooney-Rivlin material-9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
k               = properties(4);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;
dim= 3;

C = F'*F;
Cbar = J^(-2/3)*C;
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
I1bar=J^(-2/3).*I1;
I2bar = J^(-4/3).*I2;
S_bar = (mu1 + mu2.*I1bar)*cons.I-mu2.*Cbar;
S_vol = J^(1/3).*(J-1).*k.*Cbar^(-1);
S_iso = J^(-2/3).*((-1/3).*(mu1.*I1bar+2*mu2.*I2bar).*Cbar^(-1)+(mu1+mu2.*I1bar).*cons.I-mu2.*Cbar);
tau_vol = F * S_vol * F';
tau_iso = F * S_iso * F';
Cauchy = J^(-1)*(tau_vol + tau_iso);

end