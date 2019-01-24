%--------------------------------------------------------------------------
% Add pressure contribution to stresses and elasticity tensor.
%--------------------------------------------------------------------------
function [Cauchy,c] = mean_dilatation_pressure_addition(Cauchy,c,CONSTANT,pressure,matyp)
switch matyp 
    case {5,7,17}
         Cauchy = Cauchy + pressure*CONSTANT.I;
         c      = c + pressure*(CONSTANT.IDENTITY_TENSORS.c1 - ...
                                CONSTANT.IDENTITY_TENSORS.c2);
end
