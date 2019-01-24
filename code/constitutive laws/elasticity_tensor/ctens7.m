%--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 7.
%--------------------------------------------------------------------------
function c   = ctens7(kinematics,properties,dim)
mu           = properties(2);
J            = kinematics.J;
lambda_princ = kinematics.lambda;
sigma_aa     = -(2*mu/(3*J))*log(J) + (2*mu/J)*log(lambda_princ);  
T            =  kinematics.n; 
c            = zeros(dim,dim,dim,dim);
for l=1:dim
    for k=1:dim
        for j=1:dim
            for i=1:dim
                sum = 0;
                for alpha=1:dim    
                    sum = sum + (2*(mu/J - sigma_aa(alpha)))*T(i,alpha)*T(j,alpha)*T(k,alpha)*T(l,alpha);
                    for beta=1:dim 
                        sum      = sum - 2*mu/(3*J)*(T(i,alpha)*T(j,alpha)*T(k,beta)*T(l,beta));
                        lambda_a = lambda_princ(alpha);
                        lambda_b = lambda_princ(beta);
                        sigma_a  = sigma_aa(alpha);
                        sigma_b  = sigma_aa(beta);
                        if  (alpha ~= beta)
                            sum  = sum + muab_choice(lambda_a,lambda_b,...
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


                
                
