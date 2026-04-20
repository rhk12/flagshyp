%--------------------------------------------------------------------------
% Add pressure contribution to stresses and elasticity tensor.
%--------------------------------------------------------------------------
function [Cauchy,c] = mean_dilatation_pressure_addition(Cauchy,c,CONSTANT,pressure,matyp)
pressure_tilde = 2*pressure + 1;
switch matyp 
    case {5,7,17}
         Cauchy = Cauchy + pressure*CONSTANT.I;
         c      = c + pressure*(CONSTANT.IDENTITY_TENSORS.c1 - ...
                                CONSTANT.IDENTITY_TENSORS.c2);
%{
% The mean dilatation pressure approximation makes a 1-element cube too squishy
% Comment out this case to turn off mean dilatation for Mooney-Rivlin
    case 9
         Cauchy = Cauchy + pressure*CONSTANT.I;
         c      = c + pressure_tilde*CONSTANT.IDENTITY_TENSORS.c1 - pressure*CONSTANT.IDENTITY_TENSORS.c2;
%}
end
