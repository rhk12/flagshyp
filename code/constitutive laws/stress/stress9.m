function Cauchy = stress9(kinematics,properties,dim)
% Extract material properties
    mu1   = properties(2);
    mu2   = properties(3);
    kappa = properties(4);
% Extract kinematics
    F = kinematics.F;
    J = kinematics.J;
% Derived quantities
    I = eye(dim);
    C = F' * F;
    C_bar = J^(-2/3) * C;
    I1_bar = trace(C_bar);
% Second invariant of the isochoric part
    I2_bar = 0.5 * (I1_bar^2 - trace(C_bar * C_bar));
% --- Volumetric Second Piola-Kirchhoff Stress --
% Svol = J * p * C^-1, where p = dU/dJ
% Using the standard penalty form: p = kappa * (J - 1)
    Svol = kappa * J * (J - 1) * inv(C);
% --- Isochoric Second Piola-Kirchhoff Stress --
% Using the decoupled Mooney-Rivlin formulation
    Siso = J^(-2/3) * ( (mu1 + mu2 * I1_bar) * I - mu2 * C_bar - (1/3) * (mu1 * I1_bar + 2 * mu2 * I2_bar) * inv(C_bar) );
% Total Second Piola-Kirchhoff Stress
    S = Svol + Siso;
% Push-forward to Cauchy Stress: sigma = (1/J) * F * S * F'
    Cauchy = (1/J) * F * S * F';
end