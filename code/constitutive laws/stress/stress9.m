%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 1.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim)
mu1             = properties(2);
mu2             = properties(3);
kappa           = properties(4);
J               = kinematics.J;
F               = kinematics.F; 
C               = transpose(F)*F;
C_              = J^(-2/3)*C;
I1              = trace(C);
I2              = 0.5*((I1^2)-trace(C*C));
I3              = J^2;
I1_bar          = (J^(-2/3))*I1;
I2_bar          = (J^(-4/3))*I2;
I3_bar          = 1;
S_vol           = J^(1/3)*(J-1)*kappa/C_;
S_iso           = (J^(-2/3))*(((-1/3)*(mu1*I1_bar+2*mu2*I2_bar)/C)+((mu1+mu2*I1_bar)*eye(dim,dim))-mu2*C_);
S               = S_vol+S_iso;
Cauchy          = (1/J)*F*S*transpose(F);
end