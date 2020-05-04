%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
% Mooney-Rivilin
%--------------------------------------------------------------------------
function c_tensor = MVctens(kinematics,properties,dimension)
% mu         = properties(2);
% lambda     = properties(3);
% J          = kinematics.J;
% lambda_    = lambda/J;
% mu_        = (mu - lambda*log(J))/J;
% c          = lambda_*cons.IDENTITY_TENSORS.c1 + mu_*cons.IDENTITY_TENSORS.c2;

mu1          = properties(2);
mu2          = properties(4);
k            = properties(3);
J            = kinematics.J;
F            = kinematics.F;
C            = F'*F;
C_b          = J^(-2/3)*C;
iCb          = inv(C_b);
F_b          = J^(-1/3)*F;
I            = eye(size(J));
I1           = trace(C);
I2           = 0.5*(I1^2 - trace(C^2));
I1_b         = J^(-2/3)*I1;
I2_b         = J^(-4/3);
J43          = J^(-4/3);


c            = zeros(dimension,dimension,dimension,dimension);
for l = 1:dimension
    for k = 1:dimension
        for j = 1:dimension
            for i = 1:dimension
                
                sum      =  0;
                sumv     =  0;
                sumi     =  0;
                %Stiffness Tensor Volumetric
                sumv = sumv + J^(-1/3)*(2*J-1)*k*iCb(i,j)*iCb(k.l)...
                    -2*J^(-1/3)*(J-1)*(1/2)*(iCb(i,j)+iCb(k,l));
                %Stiffness Tensor Isochoric
                sumi = 2*J43*mu2*(I(i,j)*I(k,l)-1)...
                    -(2/3)*J43*(mu1+2*mu2*I1_b)*(iCb(i,j)*I(k,l)+I(i,j)*iCb(k,l))...
                    +(4/3)*J43*mu2*(iCb(i,j)*C(k,l)+C(i,j)*iCb(k,l))...
                    +(2/9)*J43*(mu1*I1_b+4*mu2*I2_b)*(iCb(i,j)*iCb(k,l))...
                    +(1/3)*J43*(mu1*I1_b+2*mu2*I2_b)*0.5*(iCb(i,j)+iCb(k,l));
                
                sum = sumv + sumi;
                
            end
                c(i,j,k,l) = sum;
        end
    end
end
end











