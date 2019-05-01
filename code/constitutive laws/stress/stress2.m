function Cauchy = stress2(kinematics,properties,cons)
mu           = properties(2); %Assume mu1 = mu2 = mu
lambda       = properties(3); %Assume k = lambda
j            = kinematics.J;
B            = kinematics.b; %left cauchy green
I_1          = trace(B);
I_2          = 0.5*(I_1*I_1-trace(B*B));
sigma_vol    = j^(-2/3)*(j-1)*lambda*cons.I;
sigma_iso    = j^(-5/3)*(-1/3*(mu*I_1+2*mu*I_2)*cons.I+(mu+mu*I_1)*B+mu*B*B);
Cauchy       = sigma_vol + sigma_iso;                      
end