function c = ctens9(kinematics, properties, dim)
% MooneyRivlin consistent spatial elasticity tensor (spectral form)


mu1   = properties(2);
mu2   = properties(3);
kappa = properties(4);

lambda_princ = kinematics.lambda;   % principal stretches
T            = kinematics.n;        % eigenvectors (columns)
J            = kinematics.J;


I1 = sum(lambda_princ.^2);

I2 = 0;
for a = 1:dim
    for b = a+1:dim
        I2 = I2 + lambda_princ(a)^2 * lambda_princ(b)^2;
    end
end

I1_bar = J^(-2/3) * I1;
I2_bar = J^(-4/3) * I2;

Jm43 = J^(-4/3);
Jm13 = J^(-1/3);

c = zeros(dim,dim,dim,dim);


for l = 1:dim
for k = 1:dim
for j = 1:dim
for i = 1:dim

    cij = 0;
    cvol = 0;

    for alpha = 1:dim
        lambda_a = lambda_princ(alpha);
        Cinva = 1 / (lambda_a^2);

        for beta = 1:dim
            lambda_b = lambda_princ(beta);
            Cinvb = 1 / (lambda_b^2);

            % Eigenvector components
            Na_i = T(i,alpha); Na_j = T(j,alpha);
            Nb_k = T(k,beta);  Nb_l = T(l,beta);


            % ---- Term 1: 2 ¼2 (I  I)
            cij = cij + 2 * mu2 * Jm43 * ...
                (Na_i * Na_j * Nb_k * Nb_l);

            % ---- Term 2: -(2/3)(¼1 + 2¼2 I1_bar)(C^{-1}  I + I  C^{-1})
            coef2 = -(2/3) * Jm43 * (mu1 + 2*mu2*I1_bar);

            cij = cij + coef2 * ...
                (Cinva * Na_i*Na_j * Nb_k*Nb_l + ...
                 Cinvb * Na_i*Na_j * Nb_k*Nb_l);

            % ---- Term 3: (4/3) ¼2 (C^{-1}  C^{-1})
            cij = cij + (4/3) * mu2 * Jm43 * ...
                (Cinva * Cinvb * Na_i*Na_j * Nb_k*Nb_l);

            % ---- Term 4: symmetric part ()
            if alpha ~= beta
                coef4 = (2/3) * Jm43 * (mu1 + 2*mu2*I2_bar);

                cij = cij + coef4 * ...
                    (Cinva * Cinvb * ...
                    T(i,alpha)*T(j,beta) * ...
                    (T(k,alpha)*T(l,beta) + ...
                     T(k,beta)*T(l,alpha)));
            end


            % ---- Term 1: (2J - 1) º C^{-1}  C^{-1}
            coefv1 = Jm13 * (2*J - 1) * kappa;

            cvol = cvol + coefv1 * ...
                (Cinva * Cinvb * ...
                Na_i * Na_j * Nb_k * Nb_l);

            % ---- Term 2: -2(J - 1) º C^{-1}  C^{-1}
            if alpha ~= beta
                coefv2 = -2 * Jm13 * (J - 1) * kappa;

                cvol = cvol + coefv2 * ...
                    (Cinva * Cinvb * ...
                    T(i,alpha)*T(j,beta) * ...
                    (T(k,alpha)*T(l,beta) + ...
                     T(k,beta)*T(l,alpha)));
            end

        end
    end


    c(i,j,k,l) = cij + cvol;

end
end
end
end

end