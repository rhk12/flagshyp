%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for "material type 9".
% In common parlance this is known as a Mooney-Rivlin model.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons,dimension)
mu1             = properties(1);
mu2             = properties(2);
kappa           = properties(3);
J               = kinematics.J;
%C               = KINEMATICS.C;   % Turned off because KINEMATICS does not store C
b               = kinematics.b;
Ib              = kinematics.Ib;
switch dimension
    case 2
         Ib = Ib + 1;  % Unclear why this was included for Material 5. You're assuming some kind of thickness for the 2D system?
end 
% Isochoric part of the Cauchy stress
Cauchy          = -(1/3)*(mu1*J^(-5/3)*Ib + mu2*J^(-7/3)*(Ib^2 - trace(b*b)^2))*cons.I... 
                    - mu2*J^(-7/3)*(b*b) + (mu1 + mu2*J^(-2/3)*Ib)*J^(-5/3)*b;
% Volumetric part of the Cauchy stress
% Cauchy fails to converge at 0 deformation with 1e-6 tolerance, returns a residual of 1.7e-06 repeatedly.
% %{
% Comment out this section before turning on mean dilatation 
Cauchy          = Cauchy + (J-1)*kappa*cons.I;
% %}
end