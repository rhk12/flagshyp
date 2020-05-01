%--------------------------------------------------------------------------
% Obtain stresses (for incompressible or nearly incompressible, 
% only deviatoric component) and internal variables in plasticity.
%--------------------------------------------------------------------------
function [Cauchy,PLAST,PLAST_gauss] = Cauchy_type_selection(kinematics,...
          properties,cons,dim,matyp,PLAST,igauss)
PLAST_gauss = [];
switch matyp
    case 1
         Cauchy = stress1(kinematics,properties,cons);
    case 3
         Cauchy = stress3(kinematics,properties,dim);
    case 4
         Cauchy = stress4(kinematics,properties,dim);
    case 5
         Cauchy = stress5(kinematics,properties,cons,dim);
    case 6
         Cauchy = stress6(kinematics,properties,cons);
    case 7
         Cauchy = stress7(kinematics,properties,dim);
    case 8
         Cauchy = stress8(kinematics,properties,dim);
    case 10
         Cauchy = stress10(kinematics,properties,cons);
    case 17
         %-----------------------------------------------------------------
         % Select internal variables at a particular Gauss point (igauss)
         % of the element.
         %-----------------------------------------------------------------
         PLAST_gauss.OLD.invCp = PLAST.invCp(:,:,igauss);
         PLAST_gauss.OLD.epbar = PLAST.epbar(igauss);    
         [Cauchy,PLAST_gauss]  = stress17(kinematics,properties,dim,...
                                 PLAST_gauss);
         PLAST                 = plasticity_update(PLAST_gauss.UPDATED,...
                                 PLAST,igauss,matyp);
end



