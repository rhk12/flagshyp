%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for Mooney-Rivlin material.
%--------------------------------------------------------------------------
function Cauchy = MooneyRilvlin(kinematics,properties,cons)
%Extract material properties
    mu1 = properties(1);
    mu2 = properties(2);
%Extract Kinematic Variables

    B = kinematics.B; 
    C = kinematics.C; 
    J = kinematics.J; 
    F = kinematics.F;
%Compute invariants  

I1 = trace(B);
I2 = 0.5*(I1^2-trace(B^2));

I1_bar = J^(-2/3)*I1;
I2_bar = J^(-4/3)*I2;

% Compute isochoric Kirchhoff stress
tau_iso = -(1/3) * (mu1 * I1_bar + 2 * mu2 * I2_bar) * (cons.I)^2 -...
            mu2*(B)^2 + (mu1 + mu2 * I1) * B - mu2 * C;

%Convert isochoric Kirchhoff stress tensor to Cauchy stress tensor
Cauchy = (1/J) * tau_iso * F;