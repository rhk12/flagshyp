%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 10 (Mooney-Rivlin), derived from material 5.
%--------------------------------------------------------------------------
function c  = ctens10(kinematics,properties,cons,dimension)
kappa       = properties(3);
mu1         = properties(4);
mu2         = properties(5);

J               = kinematics.J;
b               = kinematics.b;
Ib              = kinematics.Ib;
IIb             = 1/2*(Ib^2 - trace(b*b));
bmod            = J^(-2/3)*kinematics.b;
Ibmod              = J^(-2/3)*Ib;
IIbmod             = J^(-4/3)*IIb;
switch dimension
    case 2
         Ib = Ib + 1;
end
% c1 = cons.IDENTITY_TENSORS.c1;   
% c2 = cons.IDENTITY_TENSORS.c2;   
% c3 = zeros(dimension,dimension,dimension,dimension);
% for l=1:dimension
%     for k=1:dimension
%         for j=1:dimension
%             for i=1:dimension
%                 c3(i,j,k,l) = c3(i,j,k,l) + kinematics.b(i,j)*cons.I(k,l) +...
%                                             cons.I(i,j)*kinematics.b(k,l);
%            end
%        end
%     end
% end
% c = 2*(mu*J^(-5/3))*(1/6*Ib*c2 - 1/3*c3 + 1/9*Ib*c1);

%%% Mooney-Rivlin below..... Needs verification! ? Is B^2 = B*B or B^t*B?
cvol = zeros(dimension, dimension, dimension, dimension);
ciso = zeros(dimension, dimension, dimension, dimension);

for i = 1:dimension
    for j = 1:dimension
        for k = 1:dimension
            for l = 1:dimension
                cvol(i,j,k,l) = kappa*(J*(2*J-1)+cons.I(i,j)*cons.I(k,l) - J*(J-1)*(cons.I(i,k)*cons.I(j,l) + cons.I(i,l)*cons.I(j,k)));
                ciso(i,j,k,l) = 2*mu2*(bmod(i,j))*bmod(k,l) - 1/2*(bmod(i,k)*bmod(j,l) + bmod(i,l)*bmod(j,k)) ...
                            -2/3*(mu1 + 2*mu2*Ibmod)*(bmod(i,j)*cons.I(k,l) + bmod(k,l)*cons.I(i,j))...
                            +4/3*mu2*(bmod(i,j)*bmod(i,j)*cons.I(k,l) + bmod(k,l)*bmod(k,l)*cons.I(i,j))...
                            +2/9*(mu1*Ibmod + 4*mu2*IIbmod)*cons.I(i,j)*cons.I(k,l)...
                            +1/3*(mu1*Ibmod + 2*mu2*IIbmod)*(cons.I(i,k)*cons.I(j,l) + cons.I(i,l)*cons.I(j,k));

            end
        end
    end
end

c = cvol+ciso;
end


