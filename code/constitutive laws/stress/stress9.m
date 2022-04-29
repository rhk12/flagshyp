%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for Mooney-Rivlin material model.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,cons)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;
C               = F'*F;
%setting mu2 equal to .01*mu as an arbitrary "hard coded" physical value
%probably not the best implimentation method but just using this to make
%sure the model works
mu2             = .01*mu
Cbar            = J^(-2/3)*C;
k               = lambda + (2/3)*mu;
I1              = trace(C);
I1bar           = J^(-2/3)*I1;
I2              = (1/2)*(I1^2-trace(C^2));
I2bar           = J^(-4/3)*I2;
Svol            = J^(1/3)*(J-1)*k*inv(Cbar);
Siso            = J^(-2/3)*(((-1/3)*((mu*I1bar)+(2*mu*I2bar))*inv(Cbar))...
                   +(((mu+(mu*I1bar))*cons.I)-(mu*Cbar)));
%push PK2 stress forward to Kirchhoff stress
Tvol            = F*Svol*transpose(F);
Tiso            = F*Siso*transpose(F);
%add together the "vol" and "iso" componets to find total stress
Cauchy          = Tvol + Tiso;
end