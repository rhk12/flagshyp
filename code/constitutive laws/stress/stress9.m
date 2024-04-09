%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics)
% Values of mu and kappa come from Cheng Zhang 2017 paper
mu1             = 0.595522;% units MPa
mu2             = 0.050381;% units MPa
J               = kinematics.J;
F               = kinematics.F;
k               = 1*10^5;% units MPa
% Calc C
C = F'*F;
% Calc Modified C
C_bar = J^(-2/3)*(F'*F);
% Calc vol part of stress tensor 
tau_vol = F(J^(1/3)*(J-1)*k*inv(C_bar))*F';
% Calc iso part of the stress tensor
Ibar1 = J^(-2/3)*trace(C);
Ibar2 = J^(-4/3)*(.5*(trace(C)^2-trace(C^2)));
S_iso = J^(-2/3)*((-1/3)*(mu1*Ibar1+2*mu2*Ibar2)*inv(C_bar) + (mu1+mu2*Ibar1)*eye(3)-mu2*C_bar);
tau_iso = F*S_iso*F';
% Combine results
Cauchy = tau_vol + tau_iso;d
