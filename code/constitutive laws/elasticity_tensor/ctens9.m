%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)
mu1          = properties(2);
mu2          = properties(4);
kap            = properties(3);
J            = kinematics.J;
F            = kinematics.F;
b            = kinematics.b;
Ib           = kinematics.Ib;
I2           = (1/2)*(Ib^2-trace(b^2));
I1_bar       = J^(-2/3)*Ib;
I2_bar       = J^(-4/3)*I2;
F_bar        = J^(-1/3)*F;
b_bar        = F_bar*F_bar';
c            = zeros(dim,dim,dim,dim);
cvol         = zeros(dim,dim,dim,dim);
ciso         = zeros(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                cvol(i,j,k,l) = kap*(J*(2+J-1)*(kd(i,j)*kd(k,l))-...
                    J*(J-1)*(kd(i,k)*kd(j,l)+kd(i,l)*kd(j,k)));
                
                ciso(i,j,k,l) = 2*mu2*(b_bar(i,j)*b_bar(k,l)-.5*(b_bar(i,k)*b_bar(j,l)+b_bar(i,l)*b_bar(j,k)))-...
                    (2/3)*(mu1+2*mu2*I1_bar)*(b_bar(i,j)*kd(k,l)+b_bar(k,l)*kd(i,j))+...
                    (4/3)*mu2*(b_bar(i,j)^2*kd(k,l)+b_bar(k,l)^2*kd(i,j))+...
                    (2/9)*(mu1*I1_bar+4*mu2*I2_bar)*(kd(i,j)*kd(k,l))+...
                    (1/3)*(mu1*I1_bar+2*mu2*I2_bar)*(kd(i,k)*kd(j,l)+kd(i,l)*kd(j,k));
                
                c(i,j,k,l) = ciso(i,j,k,l) + cvol(i,j,k,l);
            end
        end
    end    
end