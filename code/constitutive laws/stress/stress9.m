function Cauchy = stress9(kinematics,properties,cons)
mu1 = properties(2);
mu2 = properties(3);
kappa = properties(4);
J = kinematics.J;
b = kinematics.b;
I = cons.I;
I1 = trace(b);
I2 = 0.5*(I1^2 - trace(b*b));
I1_bar = I1/J^(2/3);
I2_bar = I2/J^(4/3);
tau_vol = J*(J-1)*kappa*I;
tau_iso = -(1/3)*(mu1*I1_bar + 2*mu2*I2_bar)*I - mu2*(b*b) + ...
 (mu1 + mu2*I1_bar)*b;
Cauchy = (tau_vol + tau_iso)/J;
end

