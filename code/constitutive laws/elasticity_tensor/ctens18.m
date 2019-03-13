%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 18
%using the Mooney Rivlin model.
%--------------------------------------------------------------------------
function c = ctens18(kinematics,properties,dim)
mu_1       = properties(1);
mu_2       = properties(2);
J          = kinematics.J;
K          = properties(3);
F          = kinematics.F;
F_bar      = J.^(-1/3)*F;
B_bar      = F_bar*F_bar';
T          = kinematics.n;
I_1        = trace(T);
I_2        = 0.5*(I_1.^2 - trace(T.^2));
c          = zeros(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
               sum = 0;
               sum = sum + (K*J*(2*(J-1))*T(i,j)*T(k,l))-(J*(J-1)*(T(i,k)*T(j,l)...
                   + T(i,l)*T(j,k)));
               sum = sum + 2*mu_2*(B_bar(i,j)*B_bar(k,l)-0.5*(B_bar(i,k)*B_bar(j,l)...
                   +B_bar(i,l)*B_bar(j,k)));
               sum = sum - (2/3)*(mu_1+2*mu_2*I_1)*(B_bar(i,j)*T(k,l)...
                   +B_bar(k,l)*T(i,j));
               sum = sum + (4/3)*mu_2*(B_bar(i,j).^2*T(k,l)...
                   +B_bar(k,l).^2*T(i,j));
               sum = sum + (2/9)*(mu_1*I_1+4*mu_2*I_2)*T(i,j)*T(k,l);
               sum = sum + (1/3)*(mu_1*I_1+2*mu_2*I_2)*(T(i,k)*T(j,l)...
                   + T(i,l)*T(j,k));
               c(i,j,k,l) = sum
            end
        end
    end    
end
