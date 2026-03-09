%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 10.
%--------------------------------------------------------------------------
function c = ctens10(kinematics,properties,dim)
mu         = properties(2);
lambda     = properties(3);
J          = kinematics.J;
b = kinematics.b;
F = kinematics.F;
Fbar = J^(-1/3)*F;

I1 = trace(b);
I1bar = J^(2/3).*I1;
I2 = 0.5.*((I1^2)-trace(b^2));
I2bar = J^(-4/3).*I2;
Bbar  = dot(Fbar, transpose(Fbar));

mu1 = 1; %approximate material constants as 1
mu2 = 1; %approximate material constants as 1

c            = zeros(dim,dim,dim,dim);

for i = 1:dim
    for j = 1:dim
        for k = 1:dim
            for l = 1:dim
                c(i,j,k,l) = 2*mu2*(Bbar(i,j)*Bbar(k,l) - 0.5*(Bbar(i,k)*Bbar(j,l) + Bbar(i,l)*Bbar(j,k))) ...
                            - (2/3)*(mu1 + 2*mu2*I1bar)*(Bbar(i,j)*kroneckerDelta(k,l) + Bbar(k,l)*kroneckerDelta(i,j)) ...
                            + (4/3)*mu2^2*(Bbar(i,j)^2*kroneckerDelta(k,l) + Bbar(k,l)^2*kroneckerDelta(i,j)) ...
                            + (2/9)*(mu1*I1bar + 4*mu2*I2bar)*kroneckerDelta(i,j)*kroneckerDelta(k,l) ...
                            + (1/3)*(mu1*I1bar + 2*mu2*I2bar)*(kroneckerDelta(i,k)*kroneckerDelta(j,l) + kroneckerDelta(i,l)*kroneckerDelta(j,k));
            end
        end
    end
end

% The Kronecker delta function.
function val = kroneckerDelta(i, j)
    val = double(i == j);
end

end
