%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)
mu1             = properties(2);
mu2             = properties(3);
kappa           = properties(4);
J               = kinematics.J;
F               = kinematics.F; 
C               = transpose(F)*F;
C_              = J^(-2/3)*C;
B_              = transpose(C_);
I1              = trace(C);
I2              = 0.5*((I1^2)-trace(C*C));
I3              = J^2;
I1_bar          = (J^(-2/3))*I1;
I2_bar          = (J^(-4/3))*I2;
I3_bar          = 1;
c            = zeros(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                sum    =  0;
                sum    = sum + kappa*(((J*((2*J)-1))*kroneckerDelta(i,j)*kroneckerDelta(k,l))-((J*(J-1))*((kroneckerDelta(i,k)*kroneckerDelta(j,l))+(kroneckerDelta(i,l)*kroneckerDelta(j,k)))));
                sum    = sum + 2*mu2*((B_(i,j)*B_(k,l))-(0.5*(B_(i,k)*B_(j,l))))-((2/3)*(mu1+mu2*I1_bar)*((B_(i,j)*kroneckerDelta(k,l))+(B_(k,l)*kroneckerDelta(i,j))))+(((4/3)*mu2)*(((B_(i,j)^2)*kroneckerDelta(k,l))+((B_(k,l)^2)*kroneckerDelta(i,j))))+((2/9)*((mu1*I1_bar)+(4*mu2*I2_bar))*kroneckerDelta(i,j)*kroneckerDelta(k,l))+((1/3)*((mu1*I1_bar)+(2*mu2*I2_bar))*(((kroneckerDelta(i,k))*(kroneckerDelta(j,l)))+((kroneckerDelta(i,l))*(kroneckerDelta(j,k)))));
                c(i,j,k,l) = c(i,j,k,l) + sum;
            end
        end
    end    
end
end