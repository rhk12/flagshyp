%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 8.
%--------------------------------------------------------------------------
function Cauchy = stress8(kinematics,properties,dim)
mu              = properties(2);
lambda          = 2*mu;
J               = kinematics.J;
lambda_princ    = kinematics.lambda;
n_princ         = kinematics.n;
sigma_aa        = 2*mu*log(lambda_princ) + lambda*log(J);
Cauchy          = zeros(dim);                
for idim=1:dim    
    Cauchy      = Cauchy + sigma_aa(idim)*(n_princ(:,idim)*n_princ(:,idim)');                  
end

