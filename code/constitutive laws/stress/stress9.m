%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties)
mu_1         = properties(1);
mu_2         = properties(2);
k            = properties(3);
J            = kinematics.J;
F            = kinematics.F;
b            = kinematics.b;
C            = F'*F;  
I_1          = trace(C);
I_2          = 0.5*(I_1.^2-trace(C.^2));
I1_bar       = J^(-2/3)*I_1;
I2_bar       = J^(-4/3)*I_2;
F_bar        = J^(-1/3)*F;
C_bar        = J^(-2/3)*C;
I            = eye(size(J));

S_vol        = J^(1/3)*(J-1)*k*inv(C_bar);

S_iso1       = (-1/3)*(mu_1*I1_bar+2*mu_2*I2_bar)*inv(C_bar);
S_iso2       = (mu_1+mu_2*I1_bar)*inv(C_bar)*I;
S_iso3       = mu_2*C_bar;
S_iso        = J^(-2/3)*(S_iso1+S_iso2+S_iso3);

S_kirchoff   = S_vol + S_iso;
S_cauchy      = inv(J)*S_kirchoff;

end

