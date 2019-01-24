%--------------------------------------------------------------------------
% Select internal variables within the element (plasticity).
%--------------------------------------------------------------------------
function  PLAST_element = selecting_internal_variables_element(PLAST,matyp,ielement)
switch matyp
    case 2
         PLAST_element.ep    = PLAST.ep(ielement);
         PLAST_element.epbar = PLAST.epbar(ielement);
    case 17
         PLAST_element.epbar = PLAST.epbar(:,ielement);
         PLAST_element.invCp = PLAST.invCp(:,:,:,ielement);
    otherwise
         PLAST_element       = [];
end
