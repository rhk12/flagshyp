%--------------------------------------------------------------------------
% Evaluates the Cauchy stress tensor for material type 4.
%--------------------------------------------------------------------------
function Cauchy = stress4(kinematics,properties,dim)
mu              = properties(2);
lambda          = properties(3);
j               = kinematics.J;
lambda_princ    = kinematics.lambda;
n_princ         = kinematics.n;
gamma           = 2*mu/(lambda + 2*mu); 
J               = j^(gamma);
lambda          = gamma*lambda;
sigma_aa        = 2*(mu/J)*log(lambda_princ) + (lambda/J)*log(j);
Cauchy          = zeros(dim);                
for idim=1:dim    
    Cauchy      = Cauchy + sigma_aa(idim)*(n_princ(:,idim)*n_princ(:,idim)');                  
end