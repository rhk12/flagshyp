%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim) 
%Define Variables. Some of these could be implemented into the kinematics
%structure, however I am not familiar enough to ensure they would go in the 
%correct place.
mu1             = properties(2);
k               = properties(3);
mu2             = properties(4);
F               = kinematics.F;
J               = kinematics.J;
b               = kinematics.b;
Ib              = kinematics.Ib;
I2              = (1/2)*(Ib^2-trace(b^2));
I1_bar          = J^(-2/3)*Ib;
I2_bar          = J^(-4/3)*I2;
[sz1,sz2]       = size(J);
ident           = eye(sz1,sz2);
F_bar           = J^(-1/3)*F;
b_bar           = F_bar*F_bar';

%Calculating Kirchoff Stress
sigma_kirch_vol = J*(J-1).*k*ident;
sigma_kirch_iso = -(1/3)*(mu1*I1_bar+2*mu2*I2_bar)*ident-mu2*b_bar^2+(mu1+mu2*I1_bar)*b_bar;                  
sigma_kirch     = sigma_kirch_vol+sigma_kirch_iso;

%Convering to Cauchy
Cauchy          = J^-1*sigma_kirch;
               
end