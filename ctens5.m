%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 5.
%--------------------------------------------------------------------------
function c  = ctens5(kinematics,properties,cons,dimension)
mu          = properties(2);
Ib          = kinematics.Ib;
J           = kinematics.J;
switch dimension
    case 2
         Ib = Ib + 1;
end
c1 = cons.IDENTITY_TENSORS.c1;   
c2 = cons.IDENTITY_TENSORS.c2;   
c3 = zeros(dimension,dimension,dimension,dimension);
for l=1:dimension
    for k=1:dimension
        for j=1:dimension
            for i=1:dimension
                c3(i,j,k,l) = c3(i,j,k,l) + kinematics.b(i,j)*cons.I(k,l) +...
                                            cons.I(i,j)*kinematics.b(k,l);
           end
       end
    end
end
c = 2*(mu*J^(-5/3))*(1/6*Ib*c2 - 1/3*c3 + 1/9*Ib*c1);
end


