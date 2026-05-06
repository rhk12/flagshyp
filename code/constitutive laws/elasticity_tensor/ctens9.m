function c = ctens9(kinematics, properties, dim)
% Mooney-Rivlin consistent spatial elasticity tensor (4th order tensor form)
% Extract material properties
    mu1   = properties(2);
    mu2   = properties(3);
    kappa = properties(4);
% Extract kinematics
    F = kinematics.F;
    J = kinematics.J;
% Derived quantities
    I = eye(dim);
    C = F' * F;
    C_inv = inv(C);
    C_bar = J^(-2/3) * C;
    C_bar_inv = inv(C_bar);
    I1_bar = trace(C_bar);
    I2_bar = 0.5 * (I1_bar^2 - trace(C_bar * C_bar));
% --- Helper functions for 4th Order Tensors --
% Dyadic product: (A \otimes B)_ijkl = A_ij * B_kl
    ox_4 = @(A, B) reshape(A(:) * B(:)', [dim, dim, dim, dim]);
% Symmetric product: (A \odot B)_ijkl = 0.5*(A_ik*B_jl + A_il*B_jk)
    odot_4 = @(A, B) symm_prod_4(A, B, dim);
% Fourth-order Identity: II_ijkl = delta_ik * delta_jl
    II = zeros(dim, dim, dim, dim);
for i = 1:dim
for j = 1:dim
            II(i,j,i,j) = 1;
end
end
% --- Term-by-term calculation from image_adea01.png --
    term1 = 2 * J^(-4/3) * mu2 * (ox_4(I, I) - II);
    term2 = -(2/3) * J^(-4/3) * (mu1 + 2*mu2*I1_bar) * (ox_4(C_bar_inv, I) + ox_4(I, C_bar_inv));
    term3 = (4/3) * J^(-4/3) * mu2 * (ox_4(C_bar_inv, C_bar) + ox_4(C_bar, C_bar_inv));
    term4 = (2/9) * J^(-4/3) * (mu1*I1_bar + 4*mu2*I2_bar) * (ox_4(C_bar_inv, C_bar_inv));
    term5 = (2/3) * J^(-4/3) * (mu1*I1_bar + 2*mu2*I2_bar) * odot_4(C_bar_inv, C_bar_inv);
% Isochoric Part
    c_iso = term1 + term2 + term3 + term4 + term5;
% --- Volumetric Part (Tangent of Svol = kappa*J*(J-1)*C_inv) --
    p = kappa * (J - 1);
    dp = kappa * (2*J - 1);
    c_vol = J^(-1/3) * dp * ox_4(C_inv, C_inv) - 2 * J^(-1/3) * p * odot_4(C_inv, C_inv);
% Total 4th order tensor
    c = c_iso + c_vol;
end
function out = symm_prod_4(A, B, dim)
% Computes (A \odot B)_ijkl = 0.5 * (A_ik*B_jl + A_il*B_jk)
    out = zeros(dim, dim, dim, dim);
for i = 1:dim
for j = 1:dim
for k = 1:dim
for l = 1:dim
                    out(i,j,k,l) = 0.5 * (A(i,k)*B(j,l) + A(i,l)*B(j,k));
end
end
end
end
end