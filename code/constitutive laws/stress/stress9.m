%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9 (Mooney Rivlin).
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons,dimension)
mu1              = properties(2);  % property no. 1 is density by default
mu2              = properties(3);    
kappa            = properties(4);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;

% Modified tensors
I1bar = J^(-2/3)*trace(C);
I2bar = J^(-4/3)*(trace(C)^2-trace(C^2))/2;
Cbar = J^(-2/3)*C;

% 2nd PK Stresses
Svol = J^(1/3)*(J-1)*kappa*inv(Cbar);
Sbar = (mu1+mu2*I1bar)*eye(dimension)-mu2*Cbar;
Siso = J^(-2/3)*(Sbar-(mu1*I1bar+2*mu2*I2bar)*inv(Cbar)/3);
S = Svol + Siso;

% Cauchy stress
Cauchy = J^(-1)*F*S*F';
end
