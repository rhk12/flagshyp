%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for Mooney-Rivlin material type 9. 
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons)
mu1             = properties(2);
mu2             = properties(3);
k               = properties(5);
J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;

% Right Cauchy-Green Tensor
C = F'*F;
% Modified Right Cauchy-Green Tensor
Cbar = J^(-2/3)*C;
% Find I1 and I2 (Defined Page 4)
I1 = trace(C);
I2 = 0.5*(I1^2-trace(C^2));
% Find I1bar and I2bar (Defined Page 4)
I1bar = J^(-2/3)*I1;
I2bar = J^(-4/3)*I2;
% Modified Right Cauchy-Green Tensor
Bbar = Cbar';
% This is a manual input
dim=3;
% Deltas, Use Method from constant_entities.m
delta_val = eye(dim);
% Initialize c
c =  zeros(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                c(i,j,k,l) = 2*mu2*(Bbar(i,j)*Bbar(k,l)-.5*(Bbar(i,k)*Bbar(j,l)+Bbar(i,l)*Bbar(j,k))) ...
                    -(2/3)*(mu1+2*mu2*I1bar)*(Bbar(i,j)*delta_val(k,l)+Bbar(k,l)*delta_val(i,j))...
                    +(4/3)*mu2*(Bbar(i,j)^2*delta_val(k,l)...
                    +Bbar(k,l)^2*delta_val(i,j))+(2/9)*(mu1*I1bar+4*mu2*I2bar)*delta_val(i,j)*delta_val(k,l) ...
                    +(1/3)*(mu1*I1bar+2*mu2*I2bar)*(delta_val(i,k)*delta_val(j,l)+delta_val(i,l)*delta_val(j,k));
            end
        end
    end
end

end


