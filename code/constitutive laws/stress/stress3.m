%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 3.
%--------------------------------------------------------------------------
function Cauchy = stress3(kinematics,properties,dim)
mu              = properties(2);
lambda          = properties(3);
J               = kinematics.J;
lambda_princ    = kinematics.lambda;
n_princ         = kinematics.n;
sigma_aa        = 2*(mu/J)*log(lambda_princ) + (lambda/J)*log(J);
Cauchy          = zeros(dim);                
for idim=1:dim    
    Cauchy      = Cauchy + sigma_aa(idim)*(n_princ(:,idim)*n_princ(:,idim)');                  
end