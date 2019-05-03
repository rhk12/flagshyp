%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 8.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)

mu           = properties(2); %assume mu1 = mu2
kappa        = properties(3);
J            = kinematics.J;
F            = kinematics.F;
C            = F'*F;
Cbar         = (J^(-2/3)).*C;
Cbarinv      = inv(Cbar);
I1           = trace(C);
I2           = .5*(I1^2 - trace(C^2));
I1bar        = J^(-2/3)*I1;
I2bar        = J^(-4/3)*I2;
I            = eye(size(J));

cvol         = zeros(dim,dim,dim,dim);
ciso         = zeros(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                
                cvol(i,j,k,l) = ...
                    J^(-1/3)*kappa*((2*J-1)*Cbarinv(i,j)*Cbarinv(k,l) + ...
                    2*(J-1)*Cbarinv(i,l)*Cbarinv(jk));
                
                ciso(i,j,k,l) = ...
                    2/3*J^(-4/3)*mu*(3*(I(i,j)*I(k,l)-.5*((i==k)*(j==l)+(i==1)*(j==k))) - ...
                    (1-2*I1bar)*(Cbarinv(i,j)*I(k,l)+I(i,j)*Cbarinv(k,l)) + ...
                    2*(Cbarinv(i,j)*Cbar(k,l)+Cbar(i,j)*Cbarinv(k,l)) + ...
                    (1/3)*(I1bar+4*I2bar)*(Cbarinv(i,j)*Cbarinv(k,l)) + ...
                    (I1bar +2*I2bar)*(Cbarinv(i,l)*Cbarinv(j,k)));
                
            end
        end
    end
end

c = cvol + ciso;

end


