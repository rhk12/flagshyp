%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for Mooney-Rivlin material-9. 
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
k               = properties(5);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;
dim=3;

C = F'*F;
Cbar = J^(-2/3)*C;
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
I1bar = J^(-2/3)*I1;
I2bar = J^(-4/3)*I2;
Bbar = Cbar';
c =  zeros(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                c(i,j,k,l) = 2*mu2*(Bbar(i,j)*Bbar(k,l)-.5*(Bbar(i,k)*Bbar(j,l)+Bbar(i,l)*Bbar(j,k))) ...
                    -(2/3)*(mu1+2*mu2*I1bar)*(Bbar(i,j)*delta(k,l)+Bbar(k,l)*delta(i,j))...
                    +(4/3)*mu2*(Bbar(i,j)^2*delta(k,l)...
                    +Bbar(k,l)^2*delta(i,j))+(2/9)*(mu1*I1bar+4*mu2*I2bar)*delta(i,j)*delta(k,l) ...
                    +(1/3)*(mu1*I1bar+2*mu2*I2bar)*(delta(i,k)*delta(j,l)+delta(i,l)*delta(j,k));
            end
        end
    end
end

function val = delta(i, j)
    val = double(i == j);
end

end


