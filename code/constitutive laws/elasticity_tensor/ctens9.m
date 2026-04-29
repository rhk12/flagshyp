function c = ctens9(kinematics,properties,cons)
mu1 = properties(2);
mu2 = properties(3);
kappa = properties(4);
J = kinematics.J;
b = kinematics.b;
b2 = b*b;
I =cons.I;
c1 = cons.IDENTITY_TENSORS.c1;
c2 = cons.IDENTITY_TENSORS.c2;
I1 = trace(b);
I2 = 0.5*(I1^2 - trace(b*b));
I1_bar = I1/J^(2/3);
I2_bar = I2/J^(4/3);
dim = size(I,1);

cbb = zeros(dim,dim,dim,dim);
cbs = zeros(dim,dim,dim,dim);
cbI = zeros(dim,dim,dim,dim);
cb2I = zeros(dim,dim,dim,dim);

for l = 1:dim
	for k = 1:dim
		for j = 1:dim
			for i = 1:dim
				cbb(i,j,k,l) = b(i,j)*b(k,l);
				cbs(i,j,k,l) = b(i,k)*b(j,l) + b(i,l)*b(j,k);
				cbI(i,j,k,l) = b(i,j)*I(k,l) + I(i,j)*b(k,l);
				cb2I(i,j,k,l) = b2(i,j)*I(k,l) + I(i,j)*b2(k,l);
			end
		end
	end
end

c_vol = kappa*(J*(2*J-1)*c1 - J*(J-1)*c2);

c_iso = 2*mu2*(cbb - 0.5*cbs) - (2/3)*(mu1 + 2*mu2*I1_bar)*cbI + (4/3)*mu2*cb2I + (2/9)*(mu1*I1_bar + 4*mu2*I2_bar)*c1 + (1/3)*(mu1*I1_bar + 2*mu2*I2_bar)*c2;

c = c_vol + c_iso;
end

