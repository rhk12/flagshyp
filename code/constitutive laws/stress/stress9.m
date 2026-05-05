%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for MooneyRivlin material
%--------------------------------------------------------------------------
function Cauchy = stress9(kinematics,properties,dim)

mu1   = properties(2);
mu2   = properties(3);
kappa = properties(4);

J            = kinematics.J;
lambda_princ = kinematics.lambda;   % principal stretches
n_princ      = kinematics.n;        % eigenvectors

b_bar = J^(-2/3) * (lambda_princ.^2);

% First invariant
I1_bar = sum(b_bar);

sigma_aa = zeros(dim,1);

for alpha = 1:dim
    ba = b_bar(alpha);

    sigma_aa(alpha) = (2/J) * ( ...
        mu1 * ba + ...
        mu2 * (I1_bar * ba - ba^2) ...
    ) + kappa * (J - 1);
end


Cauchy = zeros(dim);

for alpha = 1:dim
    Cauchy = Cauchy + sigma_aa(alpha) * ...
        (n_princ(:,alpha) * n_princ(:,alpha)');
end

end