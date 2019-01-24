%--------------------------------------------------------------------------
% Evaluates the deviatoric algotihmic tangent modulus for Von
% Misses Plasticity with isotropic hardening (material 17). 
%--------------------------------------------------------------------------
function c =  ctens17(kinematics,properties,dim,PLAST)
mu = properties(2);
H  = properties(6);
J  = kinematics.J;
%--------------------------------------------------------------------------
% Trial stage.  
%--------------------------------------------------------------------------
lambdae_trial = PLAST.trial.lambdae;
tau_trial     = PLAST.trial.tau;    
na_trial      = PLAST.trial.n;      
T             = na_trial;
%--------------------------------------------------------------------------
% Cauchy stress tensor and its eigenvalues.  
%--------------------------------------------------------------------------
Cauchyaa = PLAST.stress.Cauchyaa;
%--------------------------------------------------------------------------
% Obtain the coefficient calphabeta.
%--------------------------------------------------------------------------
Dgamma = PLAST.yield.Dgamma;   
nua    = PLAST.yield.nu_a;     
if PLAST.yield.f>0
   %-----------------------------------------------------------------------
   %  Radial return algorithm. Return Dgamma (increment in the plastic
   %  multiplier) and the direction vector nua.
   %-----------------------------------------------------------------------   
   denominator = sqrt(2/3)*norm(tau_trial,'fro');
   c_alphabeta = (1-2*mu*Dgamma/denominator)*(2*mu*eye(dim) - 2/3*mu*ones(dim)) - ...
                 (2*mu)^2*(1/(3*mu+H) - sqrt(2/3)*Dgamma/norm(tau_trial,'fro'))*(nua*nua'); 
else
   c_alphabeta = 2*mu*eye(dim) - 2/3*mu*ones(dim);
end         
%--------------------------------------------------------------------------
% Computes elasticity tensor.
%--------------------------------------------------------------------------
c = zeros(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim 
            for i=1:dim
                sum = 0;
                for alpha=1:dim    
                    sum = sum - 2*Cauchyaa(alpha)*T(i,alpha)*T(j,alpha)*...
                                                  T(k,alpha)*T(l,alpha);
                    for beta=1:dim 
                        sum = sum + (c_alphabeta(alpha,beta)/J)*...
                                (T(i,alpha)*T(j,alpha)*T(k,beta)*T(l,beta));
                        lambda_a = lambdae_trial(alpha);
                        lambda_b = lambdae_trial(beta);
                        sigma_a  = Cauchyaa(alpha);
                        sigma_b  = Cauchyaa(beta);
                        if  (alpha ~= beta)
                            sum = sum + muab_choice(lambda_a,lambda_b,...
                            sigma_a,sigma_b,J,mu)*(T(i,alpha)*T(j,beta)*(T(k,alpha)*...
                                                   T(l,beta)+T(k,beta)*T(l,alpha)));                        
                        end
                    end
                end
                c(i,j,k,l) = c(i,j,k,l) + sum;
            end
        end
    end    
end
end
