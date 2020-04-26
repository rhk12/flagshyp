%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim)
% Mooney-Rivlin 
mu1             = properties(1);
mu2             = properties(2);
kappa           = properties(3);

J               = kinematics.J;
C               = kinematics.C;
F               = kinematics.F;

Ibar = J^(-2/3)*tr(C);
IIbar = J^(-4/3)*.5*(Ibar^2-tr(C^2));
IIIbar = 1;

Cbar = J^(-2/3)*C;

S_vol = J^(1/3)*(J-1)*kappa*Cbar;
S_bar = (mu1+mu2*Ibar)*eye(dim)-mu2*Cbar;
S_iso = J^(-2/3)*(-1/3*(mu*Ibar+2*mu2*IIbar)*Cbar^(-1)+(mu1+mu2*Ibar)*eye(dim)-mu2*Cbar);
S = S_vol + S_iso;

tau_vol = F*S_vol*F';
tau_iso = F*S_iso*F';
tua = tau_vol+tau_iso;

Cauchy = 1/J*F*tua;
              


