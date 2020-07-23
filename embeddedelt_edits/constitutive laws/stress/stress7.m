%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 7.
%--------------------------------------------------------------------------
function Cauchy = stress7(kinematics,properties,dim)
mu              = properties(2);
J               = kinematics.J;
lambda_princ    = kinematics.lambda;
n_princ         = kinematics.n;
sigma_aa        = -(2*mu/(3*J))*log(J) + (2*mu/J)*log(lambda_princ);
Cauchy          = zeros(dim);                
for idim=1:dim    
    Cauchy      = Cauchy + sigma_aa(idim)*(n_princ(:,idim)*n_princ(:,idim)');                  
end