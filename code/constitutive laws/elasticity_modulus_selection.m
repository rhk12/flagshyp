%--------------------------------------------------------------------------
% Obtain elasticity tensor (for incompressible or nearly incompressible, 
% only deviatoric component).
%--------------------------------------------------------------------------
function c_tensor = elasticity_modulus_selection(kinematics,properties,...
                    cons,dimension,matyp,PLAST,plast_gauss,igauss)
c_tensor = [];
switch matyp
    case 1
         c_tensor = ctens1(kinematics,properties,cons);            
    case 3
         c_tensor = ctens3(kinematics,properties,dimension);
    case 4
         c_tensor = ctens4(kinematics,properties,dimension);
    case 5
         c_tensor = ctens5(kinematics,properties,cons,dimension);
    case 6
         c_tensor = ctens6(kinematics,properties,cons);
    case 7
         c_tensor = ctens7(kinematics,properties,dimension);
    case 8
         c_tensor = ctens8(kinematics,properties,dimension);            
    case 17
         %-----------------------------------------------------------------
         % Select internal variables at a particular Gauss point (igauss)
         % of the element.
         %-----------------------------------------------------------------
         plast_gauss.OLD.invCp = PLAST.invCp(:,:,igauss);
         plast_gauss.OLD.epbar = PLAST.epbar(igauss);   
         c_tensor = ctens17(kinematics,properties,dimension,plast_gauss);
end  

