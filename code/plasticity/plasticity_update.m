%--------------------------------------------------------------------------
% Update the value of the internal variables at a Gauss point 
% (not for trusses).
%--------------------------------------------------------------------------
function  PLAST = plasticity_update(PLAST_gauss,PLAST,igauss,matyp)
switch matyp
    case 17
         PLAST.invCp(:,:,igauss) = PLAST_gauss.invCp;
         PLAST.epbar(igauss) = PLAST_gauss.epbar;         
    otherwise
         PLAST = [];
end 
