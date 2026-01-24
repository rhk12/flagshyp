%--------------------------------------------------------------------------
% Evaluates the constitutive tensor using the Mooney-Rilvin model.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties)

mu_1            = properties(1);
mu_2            = properties(2);

J               = kinematics.J;
b               = kinematics.b;
F               = kinematics.F;

C_bar           = J^(-2/3)*(F'*F);
I1_bar          = J^(-2/3)*trace(b);
I2_bar          = J^(-4/3)*1/2*(I1_bar^2-trace(C_bar^2));
B_bar           = (J^(-2/3)*(F'*F))';

for i = 1:3
    for j = 1:3
        for k = 1:3
            for l = 1:3
                c(i,j,k,l) = 2*mu_2*(B_bar(i,j)*B_bar(k,l) - 0.5*(B_bar(i,k)*B_bar(j,l) ...
                    + B_bar(i,l)*B_bar(j,k)))-(2/3)*(mu_1 + 2*mu_2*I1_bar)*(B_bar(i,j)*kroneckerDelta(k,l) ...
                    + B_bar(k,l)*kroneckerDelta(i,j)) + (4/3)*mu_2^2*(B_bar(i,j)^2*kroneckerDelta(k,l) ...
                    + B_bar(k,l)^2*kroneckerDelta(i,j)) + (2/9)*(mu_1*I1_bar + 4*mu_2*I2_bar)*kroneckerDelta(i,j)*kroneckerDelta(k,l) ...
                    + (1/3)*(mu_1*I1_bar + 2*mu_2*I2_bar)*(kroneckerDelta(i,k)*kroneckerDelta(j,l) + kroneckerDelta(i,l)*kroneckerDelta(j,k));
            end
        end
    end
end