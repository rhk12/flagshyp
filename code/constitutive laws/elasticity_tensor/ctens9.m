%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9 (Mooney Rivlin).
%--------------------------------------------------------------------------
function c  = ctens9(kinematics,properties,cons,dimension)
mu1              = properties(2);  % property no. 1 is density by default
mu2              = properties(3);    
kappa            = properties(4);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;

% Modified tensors
I1bar = J^(-2/3)*trace(C);
I2bar = J^(-4/3)*(trace(C)^2-trace(C^2))/2;
Cbar = J^(-2/3)*C;
Bbar = Cbar';

% Identity tensor
Id = eye(dimension);

% Spatial tensor of elasticity
cvol = zeros(dimension,dimension,dimension,dimension);
ciso = zeros(dimension,dimension,dimension,dimension);
c = zeros(dimension,dimension,dimension,dimension);
for l=1:dimension
    for k=1:dimension
        for j=1:dimension
            for i=1:dimension
                cvol(i,j,k,l) = kappa*(J*(2*J-1)*Id(i,j)*Id(k,l) - J*(J-1)*(Id(i,k)*Id(j,l)+Id(i,l)*Id(j,k)));

                ciso(i,j,k,l) = 2*mu2*(Bbar(i,j)*Bbar(k,l)-(Bbar(i,k)*Bbar(j,l)+Bbar(i,l)*Bbar(j,k))/2)...
                    -(2/3)*(mu1+2*mu2*I1bar)*(Bbar(i,j)*Id(k,l)+Bbar(k,l)*Id(i,j))...
                    +(4/3)*mu2*(Bbar(i,j)^2*Id(k,l)+Bbar(k,l)^2*Id(i,j)) + (2/9)*(mu1*I1bar+4*mu2*I2bar)*Id(i,j)*Id(k,l)...
                    +(1/3)*(mu1*I1bar+2*mu2*I2bar)*(Id(i,k)*Id(j,l)+Id(i,l)*Id(j,k));

                c(i,j,k,l) = cvol(i,j,k,l)+ciso(i,j,k,l);
           end
       end
    end
end

end


