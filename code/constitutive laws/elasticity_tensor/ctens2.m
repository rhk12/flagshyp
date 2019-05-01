function c   = ctens2(kinematics,properties,cons)
mu           = properties(2); %Assume mu1 = mu2 = mu
lambda       = properties(3); %Assume k = lambda
j            = kinematics.J;
B            = kinematics.b; %left cauchy green
I_1          = trace(B);
I_2          = 0.5*(I_1*I_1-trace(B*B));
D1           = cons.IDENTITY_TENSORS.c1;
D2           = cons.IDENTITY_TENSORS.c2;
D3           = cons.IDENTITY_TENSORS.c3;
D4           = cons.IDENTITY_TENSORS.c4;
c_vol        = lambda*(j*(2*j-1)*D1-j*(j-1)*D2);
c_iso        = 2*mu*(B*B-1/2*(B*B))-2/3*(mu+2*mu*I_1)*(B*D4+B*D3)+ 4/*mu*(B*B*D4 + B*B*D3)   + 2/9*(mu*I_1+4*mu*I_2)*D1+1/3*(mu*I_1 + 2*mu*I_2)*D2;
c            = c_vol + C_iso;
end

