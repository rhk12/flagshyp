%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,dim)
mu1         = properties(2);
mu2         = properties(3);
kappa       = properties(4);
J           = kinematics.J;
F           = kinematics.J;
b           = kinematics.J;
J           = kinematics.J;
F_bar       = (J^(-1/3))*F
B_bar       = F_bar*(F_bar.')
C           = (F.')*F
C_bar       = (J^(-2/3))*C
invC_bar    = (C_bar^(-1))
I           = eye(size(J))
I1          = trace(C)
I1_bar      = (J^(-2/3))*I1
I2          = (1/2)((I1^2)-trace(C^2))
I2_bar      = (J^(-4/3))*I2

c           = zeroes(dim,dim,dim,dim)
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                Cvol(i,j,k,l) = (J^(-1/3))*(2*J-1)*kappa*(invC_bar(i,j)*invC_bar(k,l)...
                    -2*(J^(-1/3))*kappa*(invC_bar(i,l)*InvC_bar(j,k));
                Ciso(i,j,k,l)  = 2*(J^(-4/3))*mu2*(B_bar(i,j)*B_bar(k,l)-0.5*(B_bar(i,k)*B_bar(j,l)...
                    +B_bar(i,l)*B_bar(j,k)))...
                    -(2/3)*(J^(-4/3))*(mu1+2*mu2*I1_bar)*(invC_bar(i,j)*I(k,l)+I(i,j)*invC_bar(k,l)...
                    +(4/3)*(J^(-4/3))*mu2*(invC_bar(i,j)*C_bar(k,l)+C_bar(i,j)*invC_bar(k,l)...
                    +(2/9)*(J^(-4/3))*(mu1*I1_bar+4*mu2*I2_bar)*(invC_bar(i,j)*invC_bar(k.l)...
                    +(2/3)*(J^(-4/3))*(mu1*I1_bar+2*mu2*I2_bar)*(0.5)*(invC_bar(i,k)*invC_bar(j,l)+invC_bar(i,l)*invC_bar(j,k))
                
                c(i,j,k,l) = Cvol(i,j,k,l)+Ciso(i,j,k,l)
            end
        end
    end
end

                






end


