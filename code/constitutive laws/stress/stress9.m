%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
kappa           = properties(4);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;
C               = F'*F;
dim             =3;

%Calculate I1 and I2
I1=trace(C);
I2=(1/2)*(I1^2-trace(C^2));
%Calculate I1bar and I2bar
I1bar=J^(-2/3)*I1;
I2bar=J^(-4/3)*I2;
%Calculate Cbar
Cbar=J^(-2/3)*C;
%Calculate Svol
Svol=J^(1/3)*(J-1)*kappa*Cbar^-1;
%CalculateSbar
Sbar=(mu1+mu2*I1bar)*eye(dim)-mu2*Cbar;
%Calculate Siso
Siso=J^(-2/3)*((-1/3)*(mu1*I1bar+2*mu2*I2bar)*Cbar^(-1)+(mu1+mu2*I1bar)*eye(dim)-mu2*Cbar);
%Calculate tauvol and tau iso
tauvol=F*Svol*transpose(F);
tauiso=F*Siso*transpose(F);
Cauchy=(J^-1)*(tauvol+tauiso);
end