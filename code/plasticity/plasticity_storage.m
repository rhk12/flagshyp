%--------------------------------------------------------------------------
% Stores internal variables. 
% -For material 17, stores the inverse of the right Cauchy-Green 
%  tensor (invCp) and the plastic equivalent strain (ep) for 
%  an element at all Gauss points. 
% -For material 2, stores the scalar plastic strain (ep) and the
%  equivalent plastic strain (barep) for the truss element.
%--------------------------------------------------------------------------
function PLAST = plasticity_storage(PLAST_element,PLAST,matyp,element_number)
switch matyp
     case 17
          PLAST.invCp(:,:,:,element_number) = PLAST_element.invCp;
          PLAST.epbar(:,element_number)     = PLAST_element.epbar;      
     case 2
          PLAST.ep(element_number)          = PLAST_element.ep;
          PLAST.epbar(element_number)       = PLAST_element.epbar;
    otherwise
          PLAST                             = [];        
end

