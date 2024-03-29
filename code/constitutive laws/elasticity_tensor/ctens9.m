%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
%--------------------------------------------------------------------------
function c = ctens9(kinematics)
mu1 = 0.595522*10^5;
mu2 = 0.050381*10^5;

J          = kinematics.J;
C          = transpose(kinematics.F)*kinematics.F;
Cbar       = J^(-2/3)*C;
Bbar_ij       = transpose(Cbar); 
I1              = J^(-2/3)*trace(C);
I2              = J^(-4/3)*1/2*(I1^2-trace(C^2));
% Dimension of the space, usually 3 for three-dimensional problems.
dimension = 3;

% Initialize the fourth-order tensor Cijkl as a 4D matrix filled with zeros.
c = zeros(dimension, dimension, dimension, dimension);



% Populate C with the values defined by equation A.7.
for i = 1:dimension
    for j = 1:dimension
        for k = 1:dimension
            for l = 1:dimension
                c(i,j,k,l) = 2*mu2*(Bbar_ij(i,j)*Bbar_ij(k,l) - 0.5*(Bbar_ij(i,k)*Bbar_ij(j,l) + Bbar_ij(i,l)*Bbar_ij(j,k))) ...
                            - (2/3)*(mu1 + 2*mu2*I1)*(Bbar_ij(i,j)*kroneckerDelta(k,l) + Bbar_ij(k,l)*kroneckerDelta(i,j)) ...
                            + (4/3)*mu2^2*(Bbar_ij(i,j)^2*kroneckerDelta(k,l) + Bbar_ij(k,l)^2*kroneckerDelta(i,j)) ...
                            + (2/9)*(mu1*I1 + 4*mu2*I2)*kroneckerDelta(i,j)*kroneckerDelta(k,l) ...
                            + (1/3)*(mu1*I1 + 2*mu2*I2)*(kroneckerDelta(i,k)*kroneckerDelta(j,l) + kroneckerDelta(i,l)*kroneckerDelta(j,k));
            end
        end
    end
end
% The Kronecker delta function.
function val = kroneckerDelta(i, j)
    val = double(i == j);
end
end


