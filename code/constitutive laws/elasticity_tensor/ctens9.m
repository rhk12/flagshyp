%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,dim)

mu1             = properties(2);
mu2             = properties(4);
k               = properties(3);
J               = kinematics.J;
F               = kinematics.F;
C               = F'*F;
C_bar           = J^(-2/3)*C;
invC_bar        = inv(C_bar);
F_bar           = J^(-1/3)*F;
I               = eye(size(J));
I1              = trace(C);
I2              = 0.5*(I1^2-trace(C^2));
I1_bar          = J^(-2/3)*I1;
I2_bar          = J^(-4/3)*I2;

c               = zeroes(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                
                sum    =  0;
                sum_vol   =  0;
                sum_iso   =  0;
                
                %------------------------------------------------------
                %Volumetric Stiffness Tensor
                sum_vol = sum_vol + J^(-1/3)*(2*J-1)*k*invC_bar(i,j))*invC_bar(k,l))...
                    -2*J^(-1/3)*(J-1)*(1/2)*(invC_bar(i,j))+invC_bar(k,l)));
                %------------------------------------------------------
                
                
                
                %------------------------------------------------------
                %Isochoric Stiffness Tensor
                sum_iso = 
                    2*J^(-4/3)*mu2*(I(i,j)*I(k,l)-1)...
                    -(2/3)*J^(-4/3)*(mu1+2*mu2*I1_bar)*(invC_bar(i,j)*I(k,l)+I(i,j)*invC_bar(k,l)...
                    +(4/3)*J^(-4/3)*mu2*(invC_bar(i,j)*C(k,l)+C(i,j)*invC_bar(k,l)...
                    +(2/9)*J^(-4/3)*(mu1*I1_bar+4*mu2*I2_bar)*(invC_bar(i,j)*invC_bar(k,l)...
                    +(2/3)*J^(-4/3)*(mu1*I1_bar+2*mu2*I2_bar)*0.5*(invC_bar(i,j)+invC_bar(k,l);

                sum = sum_vol + sum_iso;
                %------------------------------------------------------
            
            end
                c(i,j,k,l) = sum;
            end
        end
    end    
end




