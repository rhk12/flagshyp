%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
% In this case, the Hyperelastic Mooney-Rivlin model is used.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
% Shear and bulk modulus mu_1+mu_2 are materials properties to input
mu_1            = properties(2);
mu_2            = properties(3); 
k               = properties(4);

F               = Kinematics.F;
J               = kinematics.J;

% Modified right Cauchy-Green tensor C_bar
C               = F * F';
C_bar           = J^(-2/3)*C;

% Modified invariant I1_bar, I2_bar 
I1              = trace(C);
I1_bar          = J^(-2/3)*I1;
I2              = 0.5*(I1*I1-tr(C*C));
I2_bar          = J^(-4/3)*I2;

% PK2 stress S can be written in a decoupled form  with volumetric and
% isochoric parts: S = S_vol + S_iso

S_vol           = J^(1/3)*(J-1)*k*inv(C_bar);
S_iso           = J^(-2/3)*((-1/3*(mu_1*I1_bar+2*mu_2*I2_bar)*inv(C_bar))+(mu_1+mu_2*I1_bar)*cons.I-mu_2*C_bar);
S               = S_vol + S_iso;

% Calulate Cauchy stress through push forward method based on PK2
Cauchy          = inv(J)*F*S*F';
end