%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9 - Mooney-Rivlin.
%--------------------------------------------------------------------------
function c   = ctens9(kinematics,properties,dim)

%Pull from Properties
mu_1            = properties(1);
mu_2            = properties(2);
kappa           = properties(3);

%Pull from Kinematics
J               = kinematics.J;
F               = kinematics.F;
b               = kinematics.b;

F_bar           = J^(-1/3)*F; %Page 4 in paper 

C               = F'*F; %Page 4 in paper
C_bar           = J^(-2/3)*C; %Page 4 in paper

B_bar           = F_bar*F_bar'; %Page 27 in paper

I               = eye(size(J));
I1              = trace(C); %Page 4 in Paper
I2              = (1/2)*(I1^2-trace(C^2)); %Page 4 in Paper
I1_bar          = J^(2/3)*I1; %Page 5 in Paper
I2_bar          = J^(-4/3)*I2; %Page 5 in Paper

c               = zeros(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                
                %c_vol from Page 27, eqn. A.5c
                c_vol(i,j,k,l) = kappa*(J*(2*J-1)*C_bar(i,j)^(-1)*C_bar(k,l)^(-1)-J*(J-1)*(C_bar(i,k)^(-1)*C_bar(j,l)^(-1)+C_bar(i,l)^(-1)*C_bar(j,k)^(-1)));
                
                %c_iso from Page 27, eqn. A.7
                c_iso(i,j,k,l) = 2*mu_2*(B_bar(i,j)*B_bar(k,l)-(1/2)*(B_bar(i,k)*B_bar(j,l)+B_bar(i,l)*B_bar(j,k)))...
                    -(2/3)*(mu_1+2*mu_2*I1_bar)*(B_bar(i,j)*C_bar(k,l)^(-1)+B_bar(k,l)*C_bar(i,j)^(-1))...
                    +(4/3)*mu_2*(B_bar(i,j)^2*C_bar(k,l)^(-1)+B_bar(k,l)^2*C_bar(i,j)^(-1))...
                    +(2/9)*(mu_1*I1_bar+4*mu_2*I2_bar)*C_bar(i,j)^(-1)*C_bar(k,l)^(-1)...
                    +(1/3)*(mu_1*I1_bar+2*mu_2*I2_bar)*(C_bar(i,k)^(-1)*C_bar(j,l)^(-1)+C_bar(i,l)^(-1)*C_bar(j,k)^(-1));
                
                %Page 6, eqn. 11a
                c(i,j,k,l) = c_vol(i,j,k,l)+c_iso(i,j,k,l);
                
            end
        end
    end    
end


