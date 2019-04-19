%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 8.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)
mu1         = properties(2);
mu2         = properties(3);
kappa       = properties(4);

J           = kinematics.J;
C           = (J.')*J;
Cbar        = J^(-2/3)*C;
CbarInv     = inv(Cbar);

I1          = trace(C);
I1bar       = (J^(-2/3))*I1
I2          = (1/2)((I1^2)-trace(C^2))
I2bar       = (J^(-4/3))*I2

c           = zeros(dim,dim,dim,dim);
I           = eye(size(J));
bigI        = eye(dim, dim, dim, dim);
CbarInv      = inv(C);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                
                % eqn 
                Cvol(i,j,k,l) = J^(-1/3)*(2*J - 1)*kappa/CbarInv(i,j)*CbarInv(k,l) - 2*J^(-1/3)*(J-1)*kappa*CbarInv(i,l)*CbarInv(j,k);
                
                % eqn (25)
                Ciso(i,j,k,l) = 2*J^(-4/3)*mu2*(I(i,j)*I(k,l)- bigI) - 2/3*J^(-4/3)*(mu1 + 2*mu2*I1bar)*(CbarInv(i,j)*I(k,l) + I(i,j)*CbarInv(k,l)) ...
                                + 4/3*J^(4/3)*mu2*(CbarInv(i,j)*Cbar(k,l) + Cbar(i,j)*CbarInv(k,l)) ...
                                + 2/9*J^(-4/3)*(mu1*I1bar + 4*mu2*I2bar)*(CbarInv(i,j)*CbarInv(k,l)) ...
                                + 2/3*J^(-4/3)*(mu1*I1bar + 2*mu2*I2bar)*(CbarInv(i,l)*CbarInv(j,k));
                % eqn 11a
                C(i,j,k,l) = Cvol(i,j,k,l) + Ciso(i,j,k,l); 
            end
        end
    end    
end


