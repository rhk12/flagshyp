%--------------------------------------------------------------------------
% Checking function for materials in principal directions.
%--------------------------------------------------------------------------
function muab = muab_choice(lambda_alpha,lambda_beta,sigma_alpha,sigma_beta,J,mu)
if abs(lambda_alpha-lambda_beta)<1e-5
   muab = mu/J - sigma_alpha;     
else
   muab = (sigma_alpha*lambda_beta^2-sigma_beta*lambda_alpha^2)/(lambda_alpha^2-lambda_beta^2); 
end

