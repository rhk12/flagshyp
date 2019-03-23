%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
% Utilizes Mooney-Rivlin
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)
% mu1          = properties(2);
% mu2          = properties(4);
% lambda       = 2*mu;
% lambda_princ = kinematics.lambda;
% J            = kinematics.J;
% sigma_aa     = 2*mu*log(lambda_princ) + lambda*log(J);
% T            = kinematics.n; 
% c            = zeros(dim,dim,dim,dim);

%*_b indicates bar notations
mu1             = properties(2);
mu2             = properties(4);
k               = properties(3);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;
C_b             = J^(-2/3)*C;
iCb             = inv(C_b);
F_b             = J^(-1/3)*F;
I               = eye(size(J));
I1              = trace(C);
I2              = 0.5*(I1^2-trace(C^2));
I1_b            = J^(-2/3)*I1;
I2_b            = J^(-4/3)*I2;
J43             = J^(-4/3);


c               = zeroes(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                sum    =  0;
                sumv   =  0;
                sumi   =  0;
                %Stiffness Tensor Volumetric
                sumv = sumv + J^(-1/3)*(2*J-1)*k*iCb(i,j))*iCb(k,l))...
                    -2*J^(-1/3)*(J-1)*(1/2)*(iCb(i,j))+iCb(k,l)));
                %Stiffness Tensor Isochoric
                sumi = 2*J43*mu2*(I(i,j)*I(k,l)-1)...
                    -(2/3)*J43*(mu1+2*mu2*I1_b)*(iCb(i,j)*I(k,l)+I(i,j)*iCb(k,l)...
                    +(4/3)*J43*mu2*(iCb(i,j)*C(k,l)+C(i,j)*iCb(k,l)...
                    +(2/9)*J43*(mu1*I1_b+4*mu2*I2_b)*(iCb(i,j)*iCb(k,l)...
                    +(2/3)*J43*(mu1*I1_b+2*mu2*I2_b)*0.5*(iCb(i,j)+iCb(k,l);
                
                sum = sumv + sumi;
                
            end
                c(i,j,k,l) = sum;
            end
        end
    end    
end


