%--------------------------------------------------------------------------
%  This function implements the arc-length method to obtain the load
%  factor. 
%--------------------------------------------------------------------------
function   [displ,CON] = arclen(CON,displ,dispf)
CON.ARCLEN.afail = 0;
%--------------------------------------------------------------------------
% Initialisation.
%--------------------------------------------------------------------------
urdx = 0;
dxdx = 0;
%--------------------------------------------------------------------------
% First obtains all the dot products required.
%--------------------------------------------------------------------------
ufuf = dispf'*dispf;
urur = displ'*displ;
ufur = dispf'*displ;
%--------------------------------------------------------------------------
% For the first iteration set up  
% (current Uf)X(last incr. total incremental displ.)
% then zero total incremental displ. ready for current increment.
%--------------------------------------------------------------------------
ufdx = dispf'*CON.ARCLEN.xincr;
if (CON.niter==1) 
   CON.ARCLEN.xincr = 0;
   %----------------------------------------------------------------------
   % a 'patch' because K(inverse)*residual should not be
   % included in the update on the 1st. increment.
   %----------------------------------------------------------------------
   displ = 0*displ;
else
   urdx = displ'*CON.ARCLEN.xincr;
   dxdx = CON.ARCLEN.xincr'*CON.ARCLEN.xincr;
end
%--------------------------------------------------------------------------
% Set up arcln for first increment, first iteration.
%--------------------------------------------------------------------------
if (~CON.ARCLEN.farcl && CON.incrm*CON.niter==1) 
    CON.ARCLEN.arcln = sqrt(urur);   
end 
%--------------------------------------------------------------------------
% Finding first iteration gamma and the sign of gamma.
%--------------------------------------------------------------------------
if (CON.niter==1) 
   gamma = abs(CON.ARCLEN.arcln)/sqrt(ufuf);
   if ufdx==0
   else
      gamma = gamma*sign(ufdx);
   end
  else
     %---------------------------------------------------------------------
     % Solves quadratic equation.
     %---------------------------------------------------------------------
     a1 = ufuf;
     a2 = 2*(ufdx+ufur);
     a3 = dxdx + 2*urdx + urur - CON.ARCLEN.arcln*CON.ARCLEN.arcln;
     discr = a2^2 - 4*a1*a3;
     if (discr<0)
        CON.ARCLEN.afail = 1;
        return
     end
     discr = sqrt(discr);
     if (a2<0) 
        discr = -discr;
     end
     discr = -(a2+discr)/2;
     gamm1 = discr/a1;
     gamm2 = a3/discr;
     %---------------------------------------------------------------------
     % Determines which of the two solutions is better.
     % using Crisfields generalised cosine check.
     %---------------------------------------------------------------------
     gamma = gamm1;
     cos1  = urdx+gamm1*ufdx;
     cos2  = urdx+gamm2*ufdx;
     if(cos2>cos1) 
         gamma = gamm2;
     end
end
%--------------------------------------------------------------------------
% Updates the displacements and the accumulated displacements.
%--------------------------------------------------------------------------
displ = displ + gamma*dispf;
CON.ARCLEN.xincr = CON.ARCLEN.xincr + displ;
%--------------------------------------------------------------------------
% Updates the values of the increment of lambda and lambda.
%--------------------------------------------------------------------------
CON.dlamb = CON.dlamb+gamma;
CON.xlamb = CON.xlamb+gamma;
%--------------------------------------------------------------------------
% Check infinite numbers for xlamb (additional failure criterion).
%--------------------------------------------------------------------------
if isnan(CON.xlamb)
   CON.ARCLEN.afail = 1; 
end
    
