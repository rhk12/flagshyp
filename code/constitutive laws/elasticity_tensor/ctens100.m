%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 100.
%--------------------------------------------------------------------------

function c = ctens1(kinematics,properties,cons)

mu_1         = properties(2);
mu_2         = properties(3);
kappa        = properties(4)
J            = kinematics.J;
F            = kinematics.F;
C            = transpose(F)*F;
I_1          = trace(C);
I_2          = 0.5*(trace(C)^2-trace(C^2));
Fbar         = J^(-1/3)*F; 
B            = Fbar*transpose(Fbar); %note that this is actually B_bar

c_vol=0;
c_iso=0;
for l=1:dim;
    for k=1:dim;
        for j=1:dim;
            for i=1:dim;
              c_vol(i,j,k,l)=kappa(J*(2*J-1)*kroneckerDelta(sym(i),sym(j))*kroneckerDelta(sym(k),sym(l))...
              - J*(J-1)*(kroneckerDelta(sym(i),sym(k))*kroneckerDelta(sym(j),sym(l))+kroneckerDelta(sym(i),sym(l))*kroneckerDelta(sym(j),sym(k))));
              c_iso(i,j,k,l)=2*mu_2(B(i,j)*B(k,l)-0.5*(B(i,k)*B(j,l)+B(i,l)*B(j,k))...
              - 2/3*(mu_1+2*mu_2*I_1)*(B(1,j)*kroneckerDelta(sym(k),sym(l))+B(k,l)*kroneckerDelta(sym(i),sym(j))...
              + 4/3*mu_2*(B(i,j)^2*kroneckerDelta(sym(k),sym(l))+B(k,l)^2*kroneckerDelta(sym(i),sym(j))...
              + 2/9*(mu_1*I_1+4*mu_2*I_2)*kroneckerDelta(sym(i),sym(j))*kroneckerDelta(sym(k),sym(l))...
              + 1/3*(mu_1*I_1+2*mu_2*I_2)(kroneckerDelta(sym(i),sym(k))*kroneckerDelta(sym(j),sym(l))+kroneckerDelta(sym(i),sym(l))*kroneckerDelta(sym(j),sym(k)));
            end
        end
    end
end
c=c_vol+c_iso;           
end
