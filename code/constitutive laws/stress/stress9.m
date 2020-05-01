%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 9 - Mooney-Rivlin.
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim)

%Pull from Properties
mu_1            = properties(1);
mu_2            = properties(2);
kappa           = properties(3);

%Pull from Kinematics
J               = kinematics.J;
F               = kinematics.F;
b               = kinematics.b;

C               = F'*F; %Page 4 in paper
C_bar           = J^(-2/3)*C; %Page 4 in paper

I               = eye(size(J));
I1              = trace(C); %Page 4 in Paper
I2              = (1/2)*(I1^2-trace(C^2)); %Page 4 in Paper
I1_bar          = J^(2/3)*I1; %Page 5 in Paper
I2_bar          = J^(-4/3)*I2; %Page 5 in Paper

S_vol           = J^(1/3)*(J-1)*kappa*C_bar^(-1); %Page 7, eqn. 13b
S_iso           = J^(-2/3)*((-1/3)*(mu_1*I1_bar+2*mu_2*I2_bar)*C_bar^(-1)+(mu_1+mu_2*I1_bar)*I-mu_2*C_bar); %Page 8, eqn. 15

S               = S_vol + S_iso; %Page 7, eqn. 8a

Cauchy          = J^(-1)*F*S*F'; %Page 5
               
end

