%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons)
mu1             = properties(1);
mu2             = properties(2);
kappa           = properties(3);
J          = kinematics.J;
C = kinematics.F'*kinematics.F
Cbar=(J^(-2/3))*C;
Bbar=Cbar';
%% Invariants
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
Ibar1 = (J^(-2/3))*I1;
Ibar2 = (J^(-4/3))*I2;
%% stiffness tensor
dim = 3;
for i=1:dim
    for j=1:dim
        for k=1:dim
            for l=1:dim
                cvol(i,j,k,l)=kappa*(J*(2*J-1)*kroneckerDelta(sym(i),sym(j))*kroneckerDelta(sym(k),sym(l)))...
                    -J*(J-1)*(kroneckerDelta(sym(i),sym(k))*kroneckerDelta(sym(j),sym(l))+kroneckerDelta(sym(i),sym(l))*kroneckerDelta(sym(j),sym(k)));
                ciso(i,j,k,l)=2*mu2*(Bbar(i,j)-0.5*(Bbar(i,k)*Bbar(j,l)+Bbar(i,l)*Bbar(j,k)))...
                    -(2/3)*(mu1+2*mu2*Ibar1)*(Bbar(i,j)*kroneckerDelta(sym(k),sym(l))+Bbar(k,l)*kroneckerDelta(sym(i),sym(j)))...
                    +(4/3)*mu2*((Bbar(i,j)^2)*kroneckerDelta(sym(k),sym(l))+(Bbar(k,l)^2)*kroneckerDelta(sym(i),sym(j)))...
                    +(2/9)*(mu1*Ibar1+4*mu2*Ibar2)*kroneckerDelta(sym(i),sym(j))*kroneckerDelta(sym(k),sym(l))...
                    +(1/3)*(mu1*Ibar1+2*mu2*Ibar2)*(kroneckerDelta(sym(i),sym(k))*kroneckerDelta(sym(j),sym(l))+kroneckerDelta(sym(i),sym(l))*kroneckerDelta(sym(j),sym(k)));
            end
        end
    end
end
c=cvol+ciso;
end


