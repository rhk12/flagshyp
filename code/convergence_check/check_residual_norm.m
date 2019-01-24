%--------------------------------------------------------------------------
% Check for equilibrium convergence.
%--------------------------------------------------------------------------
function [rnorm,GLOBAL] = check_residual_norm(CON,BC,GLOBAL,freedof)
%--------------------------------------------------------------------------
% Obtain the reactions.
%--------------------------------------------------------------------------
GLOBAL.Reactions = GLOBAL.Residual(BC.fixdof) + GLOBAL.external_load(BC.fixdof);
%--------------------------------------------------------------------------
% Evaluates the residual norm.
%--------------------------------------------------------------------------
rnorm = GLOBAL.Residual(freedof)'*GLOBAL.Residual(freedof);
fnorm = (GLOBAL.nominal_external_load(freedof) - GLOBAL.nominal_pressure(freedof))'*...
        (GLOBAL.nominal_external_load(freedof) - GLOBAL.nominal_pressure(freedof));
fnorm = fnorm*CON.xlamb^2;
enorm =  GLOBAL.Reactions'*GLOBAL.Reactions;
rnorm =  sqrt(rnorm/(fnorm + enorm));
%--------------------------------------------------------------------------
% Print convergence related information.
%--------------------------------------------------------------------------
fprintf(1,['Step: ','%3i',' iteration: ','%3i',' residual: ','%10.7g' ' \n'], ...
       CON.incrm, CON.niter, rnorm);        

