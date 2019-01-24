%--------------------------------------------------------------------------
% Read control parameters.
%--------------------------------------------------------------------------
function CON = incontr(BC,fid)
CON.ARCLEN.farcl   = 0;
CON.nincr          = fscanf(fid,'%d',1);
CON.xlmax          = fscanf(fid,'%g',1);
CON.dlamb          = fscanf(fid,'%g',1);
CON.miter          = fscanf(fid,'%d',1);
CON.cnorm          = fscanf(fid,'%g',1);
CON.searc          = fscanf(fid,'%g',1);
CON.ARCLEN.arcln   = fscanf(fid,'%g',1);
CON.OUTPUT.incout  = fscanf(fid,'%g',1);
CON.ARCLEN.itarget = fscanf(fid,'%g',1);  
CON.ARCLEN.iterold = CON.ARCLEN.itarget;                                       
CON.OUTPUT.nwant   = fscanf(fid,'%g',1);
CON.OUTPUT.iwant   = fscanf(fid,'%g',1);
CON.ARCLEN.xincr   = zeros(size(BC.freedof,1),1); 
CON.ARCLEN.farcl   = 0;
CON.ARCLEN.afail   = 0;
if abs(CON.searc*abs(CON.ARCLEN.arcln))
   fprintf(['Error reading solution control parameters. '...
            'Line search and arclength methods cannot be both activated. \n']);
end  
if ~CON.searc
   CON.searc        = 1e5; 
end
CON.msearch         = 5;
CON.incrm           = 0;
if CON.ARCLEN.arcln <1e-20
   CON.ARCLEN.farcl = 1;
end
end 

