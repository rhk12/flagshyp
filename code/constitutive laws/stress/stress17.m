%--------------------------------------------------------------------------
% Computes the deviatoric component of the stress for Von
% Misses Plasticity with isotropic hardening (material 17). 
%--------------------------------------------------------------------------
function [Cauchy,PLAST] = stress17(kinematics,properties,dim,PLAST)
invCp          = PLAST.OLD.invCp;
ep             = PLAST.OLD.epbar;
mu             = properties(2);
DIM            = dim;
J              = kinematics.J;
F(1:dim,1:dim) = kinematics.F;
%--------------------------------------------------------------------------
% Trial stage.   
%--------------------------------------------------------------------------
be_trial(1:dim,1:dim) = F*(invCp*F');
[V,D]                 = eig(be_trial);             
lambdae_trial         = sqrt(diag(D));    
na_trial              = V;               
%--------------------------------------------------------------------------
% In plane strain applications, we set DIM=3, as out of plane stresses can
% be developed.
%--------------------------------------------------------------------------
tauaa_trial = (2*mu)*log(lambdae_trial) - (2*mu/3)*log(J);  
switch dim
    case 2
         DIM              = 3;  
         lambdae_trial(3) = 1/det(invCp);     
         tauaa_trial      = (2*mu)*log(lambdae_trial)- (2*mu/3)*log(J);                  
         na_trial         = [[na_trial(:,1);0] [na_trial(:,2);0] [0;0;1]];
         be_trial(3,3)    = lambdae_trial(3);             
end
tau_trial = zeros(DIM);                
for idim=1:DIM
    tau_trial = tau_trial + tauaa_trial(idim)*(na_trial(:,idim)*na_trial(:,idim)');                  
end 
%--------------------------------------------------------------------------
% Checking for yielding.
%--------------------------------------------------------------------------
f = Von_Mises_yield_function(tau_trial,ep,properties(5),properties(6));
%--------------------------------------------------------------------------
% Update the elastic left Cauchy-Green deformation tensor (be) and
% stresses. 
%--------------------------------------------------------------------------
if f>0    
   %-----------------------------------------------------------------------
   % Radial return algorithm. Return Dgamma (increment in the plastic
   % multiplier) and the direction vector nua.
   %-----------------------------------------------------------------------   
   [Dgamma,nu_a]    = radial_return_algorithm(f,tau_trial,tauaa_trial,mu,properties(6));  
   lambdae          = exp(log(lambdae_trial) - Dgamma*nu_a); 
   norm_tauaa_trial = norm(tauaa_trial,'fro');     
   tauaa            = (1-2*mu*Dgamma/(sqrt(2/3)*norm_tauaa_trial))*tauaa_trial; 
   tau = zeros(dim);                
   be  = zeros(dim);                
   for idim=1:DIM
       tau = tau + tauaa(idim)*(na_trial(1:dim,idim)*na_trial(1:dim,idim)');    
       be  = be  + lambdae(idim)^2*(na_trial(1:dim,idim)*na_trial(1:dim,idim)');
   end
else
   tau    = tau_trial(1:dim,1:dim);   
   tauaa  = tauaa_trial(1:dim);       
   Dgamma = 0;
   nu_a   = zeros(dim,1);
   be     = be_trial(1:dim,1:dim);
end       
%--------------------------------------------------------------------------
%  Obtain the Cauchy stress tensor.     
%--------------------------------------------------------------------------
Cauchy                = tau/J;   
Cauchyaa              = tauaa/J; 
PLAST.stress.Cauchy   = Cauchy;
PLAST.stress.Cauchyaa = Cauchyaa; 
%--------------------------------------------------------------------------
%  Update plasticity variables.   
%--------------------------------------------------------------------------
invF                = inv(F);
PLAST.UPDATED.invCp = invF*(be*invF');
PLAST.UPDATED.epbar = ep + Dgamma;
%--------------------------------------------------------------------------
%  Store trial values (necessary for evaluation of the elasticity tensor).
%--------------------------------------------------------------------------
PLAST.trial.lambdae = lambdae_trial(1:dim); 
PLAST.trial.tau     = tau_trial(1:dim,1:dim);
PLAST.trial.n       = na_trial(1:dim,1:dim); 
%--------------------------------------------------------------------------
%  Store the yield criterion (necessary for evaluation of the elasticity
%  tensor).
%--------------------------------------------------------------------------
PLAST.yield.f      = f;
PLAST.yield.Dgamma = Dgamma;
PLAST.yield.nu_a   = nu_a(1:dim);
