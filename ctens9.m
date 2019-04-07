%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)
mu_1         = properties(1);
mu_2         = properties(2);
k            = properties(3);
J            = kinematics.J;
F            = kinematics.F;
b            = kinematics.b;
C            = F'*F;  
C_bar        = J^(-2/3)*C;
I            = eye(size(J));
I_1          = trace(C);
I_2          = 0.5*(I_1.^2-trace(C.^2));
I1_bar       = J^(-2/3)*I_1;
I2_bar       = J^(-4/3)*I_2;
F_bar        = J^(-1/3)*F;
c            = zeros(dim,dim,dim,dim);
c_vol        = zeros(dim,dim,dim,dim);
c_iso        = zeros(dim,dim,dim,dim);

sum  = 0;
sum_iso = 0;
sum_vol = 0;
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim

                % Volumetric Stiffness Tensor
                sum_vol = sum_vol + J^(-1/3)*(2*J-1)*k*inv(C_bar(i,j))*inv(C_bar(k,l))-2*J^(-1/3)*(J-1)*0.5*(inv(C_bar(i,j))+inv(C_bar(k,l)));
                
                % Isochoric Stiffness Tensor
                sum_iso1 = 2*J^(-4/3)*mu_2*(I(i,j)*I(k,l)-1);
                sum_iso2 = (-2/3)*J^(-4/3)*(mu_1+2*mu_2*I1_bar)*(inv(C_bar(i,j))*I(k,l)+I(i,j)*inv(C_bar(k,l)));
                sum_iso3 = (4/3)*J^(-4/3)*mu_2*(inv(C_bar(i,j))*C_bar(k,l)+C_bar(i,j)*inv(C_bar(k,l)));
                sum_iso4 = (2/9)*J^(-4/3)*(mu_1*I1_bar+4*mu_2*I2_bar)*inv(C_bar(i,j))*inv(C_bar(k,l));
                sum_iso5 = (2/3)*J^(-4/3)*(mu_1*I1_bar+2*mu_2*I2_bar)*0.5*(inv(C_bar(i,j))+inv(C_bar(k,l)));
                
                sum_iso = sum_iso + sum_iso1 + sum_iso2 + sum_iso3 + sum_iso4 + sum_iso5;
                
                
                c(i,j,k,l) = c(i,j,k,l) + sum;
            end
        end
    end    
end
