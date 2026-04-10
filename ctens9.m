%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (isochoric/deviatoric part) for 
% material type 9: Mooney-Rivlin hyperelastic model.
%
% Based on Cheng and Zhang (2017), Eq. A.7:
%   (c_iso)_ijkl = 2*mu2*[Bbar_ij*Bbar_kl - 0.5*(Bbar_ik*Bbar_jl + Bbar_il*Bbar_jk)]
%     - (2/3)*(mu1 + 2*mu2*Ibar1)*(Bbar_ij*d_kl + Bbar_kl*d_ij)
%     + (4/3)*mu2*(Bbar2_ij*d_kl + Bbar2_kl*d_ij)
%     + (2/9)*(mu1*Ibar1 + 4*mu2*Ibar2)*d_ij*d_kl
%     + (1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*(d_ik*d_jl + d_il*d_jk)
%
% Properties: properties(2) = mu1
%             properties(3) = mu2
%             properties(4) = kappa (bulk modulus, used in mean dilatation)
%
% The volumetric/pressure contribution is handled separately via
% mean_dilatation_pressure_addition.m.
%--------------------------------------------------------------------------
function c = ctens9(kinematics,properties,cons,dimension)
mu1    = properties(2);
mu2    = properties(3);
J      = kinematics.J;
b      = kinematics.b;
Ib     = kinematics.Ib;
dim    = dimension;
%--------------------------------------------------------------------------
% Modified left Cauchy-Green tensor and invariants.
%--------------------------------------------------------------------------
Bbar   = J^(-2/3) * b;
Ibar1  = J^(-2/3) * Ib;
switch dim
    case 2
         Ibar1 = Ibar1 + J^(-2/3);
end
Bbar2  = Bbar * Bbar;
switch dim
    case 2
         trBbar2 = Bbar2(1,1) + Bbar2(2,2) + J^(-4/3);
    case 3
         trBbar2 = Bbar2(1,1) + Bbar2(2,2) + Bbar2(3,3);
end
Ibar2  = 0.5*(Ibar1^2 - trBbar2);
%--------------------------------------------------------------------------
% Identity tensors from CONSTANT structure (4th-order tensors stored as
% dim x dim x dim x dim arrays):
%   c1(i,j,k,l) = delta_ij * delta_kl
%   c2(i,j,k,l) = delta_ik * delta_jl + delta_il * delta_jk
%--------------------------------------------------------------------------
c1 = cons.IDENTITY_TENSORS.c1;
c2 = cons.IDENTITY_TENSORS.c2;
I  = cons.I;
%--------------------------------------------------------------------------
% Build 4th-order tensors needed for Eq. A.7.
%--------------------------------------------------------------------------
% Term 1: Bbar_ij * Bbar_kl  (dyadic product of Bbar with itself)
BbarBbar = zeros(dim,dim,dim,dim);
% Term 2: Bbar_ik * Bbar_jl + Bbar_il * Bbar_jk  (symmetric product)
BbarSym  = zeros(dim,dim,dim,dim);
% Term 3: Bbar_ij * delta_kl + delta_ij * Bbar_kl
BbarI    = zeros(dim,dim,dim,dim);
% Term 4: Bbar2_ij * delta_kl + delta_ij * Bbar2_kl
Bbar2I   = zeros(dim,dim,dim,dim);

for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                BbarBbar(i,j,k,l) = Bbar(i,j)*Bbar(k,l);
                BbarSym(i,j,k,l)  = Bbar(i,k)*Bbar(j,l) + Bbar(i,l)*Bbar(j,k);
                BbarI(i,j,k,l)    = Bbar(i,j)*I(k,l) + I(i,j)*Bbar(k,l);
                Bbar2I(i,j,k,l)   = Bbar2(i,j)*I(k,l) + I(i,j)*Bbar2(k,l);
            end
        end
    end
end
%--------------------------------------------------------------------------
% Assemble the isochoric spatial elasticity tensor (Eq. A.7):
%--------------------------------------------------------------------------
c = 2*mu2*(BbarBbar - 0.5*BbarSym) ...
    - (2/3)*(mu1 + 2*mu2*Ibar1)*BbarI ...
    + (4/3)*mu2*Bbar2I ...
    + (2/9)*(mu1*Ibar1 + 4*mu2*Ibar2)*c1 ...
    + (1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*c2;
%--------------------------------------------------------------------------
% Divide by J to convert from Kirchhoff-based to Cauchy-based tensor.
% (The spatial elasticity tensor c_ijkl as used in flagshyp is the 
% Cauchy-based form, consistent with how stress5/ctens5 work.)
%--------------------------------------------------------------------------
c = c / J;
end
