%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 9.
% In common parlance this is known as a Mooney-Rivlin model.
%--------------------------------------------------------------------------
function c  = ctens9(kinematics,properties,cons,dimension)
mu1         = properties(1);
mu2         = properties(2);
kappa       = properties(3);
b           = kinematics.b;
b_squared   = kinematics.b*kinematics.b;
Ib          = kinematics.Ib;
%C           = kinematics.C;
%C_squared   = kinematics.C*kinematics.C;
J           = kinematics.J;
% The following does not work because CONSTANT is not passed to ctens
% But c1 and c2 might be inside cons, haven't checked
%c1          = CONSTANT.IDENTITY_TENSORS.c1;   % c1 = delta_ij*delta_kl
%c2          = CONSTANT.IDENTITY_TENSORS.c2;   % c2 = delta_ik*delta_jl + delta_il*delta_jk  
switch dimension
    case 2
         Ib = Ib + 1;  % Unclear why this was included for Material 5. You're assuming some kind of thickness for the 2D system?
end
% The following loop calculates the isochoric part of the spatial elasticity tensor
c = zeros(dimension,dimension,dimension,dimension);
for l=1:dimension
    for k=1:dimension
        for j=1:dimension
            for i=1:dimension
                c(i,j,k,l) = c(i,j,k,l) + 2*mu2*(J^(-4/3)*b(i,j)*b(k,l)...
                -0.5*J^(-4/3)*(b(i,k)*b(j,l) + b(i,l)*b(j,k)))...
                -(2/3)*(mu1 + 2*mu2*J^(-2/3)*Ib)*J^(-2/3)*(b(i,j)*cons.I(k,l) + b(k,l)*cons.I(i,j))...
                +(4/3)*mu2*J^(-4/3)*(b_squared(i,j)*cons.I(k,l) + b_squared(k,l)*cons.I(i,j))...
                +(2/9)*(mu1*J^(-2/3)*Ib + 2*mu2*J^(-4/3)*(Ib^2 - trace(b_squared)))*cons.I(i,j)*cons.I(k,l)...
                +(1/3)*(mu1*J^(-2/3)*Ib + mu2*J^(-4/3)*(Ib^2 - trace(b_squared)))*(cons.I(i,k)*cons.I(j,l) + cons.I(i,l)*cons.I(j,k));
           end
       end
    end
end
% The following loop adds the volumetric part of the spatial elasticity tensor
% The textbook claims that calculating the volumetric part at each node
% causes volumetric locking (too stiff behavior), so this code may not work
% for multiple elements (instead the mean dilatation approximation can be
% used.
% %{
% Comment out this section before turning on mean dilatation
for l=1:dimension
    for k=1:dimension
        for j=1:dimension
            for i=1:dimension
                c(i,j,k,l) = c(i,j,k,l) + kappa*(J*(2*J - 1)*cons.I(i,j)*cons.I(k,l)...
                    - J*(J - 1)*(cons.I(i,k)*cons.I(j,l) + cons.I(i,l)*cons.I(j,k)));
           end
       end
    end
end
% %}
end


