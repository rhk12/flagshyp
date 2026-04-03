%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9 (Mooney-Rivlin).
% properties(2) = mu1
% properties(3) = mu2
% properties(4) = kappa
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)

mu1   = properties(2);
mu2   = properties(3);
kappa = properties(4);
j = kinematics.J;
b = kinematics.b;
I = cons.I;
I1 = trace(b);
I2 = 0.5*(I1^2 - trace(b*b));
I1bar = I1 / j^(2/3);
I2bar = I2 / j^(4/3);
tau_vol = j*(j-1)*kappa*I;
tau_iso = -(1/3)*(mu1*I1bar + 2*mu2*I2bar)*I ...
          - mu2*(b*b) ...
          + (mu1 + mu2*I1bar)*b;
tau = tau_vol + tau_iso;

Cauchy = tau / j;
end
