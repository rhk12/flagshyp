%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
kappa           = properties(4);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;
C               = F'*F;
Cbar            = J^(-2/3)*C;
dim             =3;
I1=trace(C);
I2=(1/2)*(I1^2-trace(C^2));
I1bar=J^(-2/3)*I1;
I2bar=J^(-4/3)*I2;
%Calculate Bbar
Bbar=transpose(Cbar);
%Make c
for i=1:dim;
    for j=1:dim;
        for k=1:dim;
            for l=1:dim;
                c(i,j,k,l)=2*mu2*(Bbar(i,j)*Bbar(k,l)-(1/2)*(Bbar(i,k)*Bbar(j,l)+Bbar(i,l)*Bbar(j,k)));
                -(2/3)*(mu1+2*mu2*I1bar)*(Bbar(i,j)*kroneckerDelta(k,l)+Bbar(k,l)*kroneckerDelta(i,j));
                +(4*mu2/3)*(Bbar(i,j)^2*kroneckerDelta(k,l)+Bbar(k,l)^2*kroneckerDelta(i,j));
                +(2/9)*(mu1*I1bar+4*mu2*I2bar)*kroneckerDelta(i,j)*kroneckerDelta(k,l);
                +(1/3)*(mu1*I1bar+2*mu2*I2bar)*(kroneckerDelta(i,k)*kroneckerDelta(j,l)+kroneckerDelta(i,l)*kroneckerDelta(j,k));
            end
        end
    end
end
end

% The Kronecker delta function.
function val = kroneckerDelta(i, j)
    val = double(i == j);
end

