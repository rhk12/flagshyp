%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor (isochoric/deviatoric part) for 
% material type 9: Mooney-Rivlin hyperelastic model.
%
% Based on Cheng and Zhang (2017), Eq. A.6:
%   tau_iso = -(1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*I 
%             + (mu1 + mu2*Ibar1)*Bbar - mu2*Bbar^2
%
% Properties: properties(2) = mu1
%             properties(3) = mu2
%             properties(4) = kappa (bulk modulus, used in mean dilatation)
%
% The volumetric/pressure contribution is handled separately via
% mean_dilatation_pressure.m and mean_dilatation_pressure_addition.m.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons,dimension)
mu1    = properties(2);
mu2    = properties(3);
J      = kinematics.J;
b      = kinematics.b;
Ib     = kinematics.Ib;
%--------------------------------------------------------------------------
% Modified left Cauchy-Green tensor: Bbar = J^(-2/3) * b
%--------------------------------------------------------------------------
Bbar   = J^(-2/3) * b;
%--------------------------------------------------------------------------
% Modified invariants.
% For 2D plane strain, the out-of-plane stretch contributes Bbar_33 = J^(-2/3)
% so Ibar1 needs the +1 correction (same as stress5.m convention).
%--------------------------------------------------------------------------
Ibar1  = J^(-2/3) * Ib;
switch dimension
    case 2
         Ibar1 = Ibar1 + J^(-2/3);
end
%--------------------------------------------------------------------------
% Bbar^2
%--------------------------------------------------------------------------
Bbar2  = Bbar * Bbar;
switch dimension
    case 2
         % Add out-of-plane contribution to trace of Bbar^2
         trBbar2 = Bbar2(1,1) + Bbar2(2,2) + J^(-4/3);
    case 3
         trBbar2 = Bbar2(1,1) + Bbar2(2,2) + Bbar2(3,3);
end
%--------------------------------------------------------------------------
% Second modified invariant: Ibar2 = 0.5*(Ibar1^2 - tr(Bbar^2))
%--------------------------------------------------------------------------
Ibar2  = 0.5*(Ibar1^2 - trBbar2);
%--------------------------------------------------------------------------
% Isochoric Kirchhoff stress (Cheng & Zhang Eq. A.6):
%   tau_iso = -(1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*I 
%             + (mu1 + mu2*Ibar1)*Bbar - mu2*Bbar^2
%--------------------------------------------------------------------------
tau_iso = -(1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*cons.I ...
          + (mu1 + mu2*Ibar1)*Bbar ...
          - mu2*Bbar2;
%--------------------------------------------------------------------------
% Cauchy stress = tau / J
%--------------------------------------------------------------------------
Cauchy = tau_iso / J;
end
