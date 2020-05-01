%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 10, Mooney-Rivlin.
%--------------------------------------------------------------------------
function Cauchy = stress10(kinematics,properties,cons)
mu              = properties(2);        %mu2 in Cheng & Zhang
lambda          = properties(3);        %mu1 in Cheng & Zhang
F               = kinematics.F;
J               = kinematics.J;
C               = F'*F;
b               = kinematics.b;
K               = lambda + 2* mu/3;       %bulk modulus

Fbar            = J^(-1/3)*F;           %Modified Deformation
Cbar            = J^(-2/3)*C;           %Modified Right Cauchy-Green
Bbar            = Fbar*Fbar';           %Modified Left Cauchy-Green

I1              = trace(C);             %1st invariant
I2              = 1/2*(I1^2-trace(C^2));   %2nd Invariant
Ibar1           = J^(-2/3)*I1;          %Modified 1st Invariant
Ibar2           = J^(-4/3)*I2;          %Modified 2nd Invariant

E = 1/2*(kinematics.F'*kinematics.F - cons.I);

Svol = J^(1/3)*(J-1)*K*inv(Cbar);            %Volumetric portion of PK2 stress
Siso = J^(-2/3)*(-1/3*(lambda*Ibar1+2*mu*Ibar2)*inv(Cbar)+...
    (lambda+mu*Ibar2)*cons.I-mu*Cbar);  %Isochoric portion of PK2 stress

tauvol = F*Svol*F';        %Volumetric portion of Kirchoff stress
tauiso = F*Siso*F';        %Isochoric portion of Kirchoff stress

Cauchyvol          = 1/J*kinematics.F*Svol*kinematics.F';
Cauchyiso          = 1/J*kinematics.F*Siso*kinematics.F';

Cauchy          = Cauchyvol+Cauchyiso;
end