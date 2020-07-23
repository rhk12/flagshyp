%--------------------------------------------------------------------------
% Read the number of materials and material properties.  
%--------------------------------------------------------------------------
function MAT = matprop(MAT,FEM,fid)
MAT.nmats                    = fscanf(fid,'%d',1);
MAT.props                    = zeros(6,MAT.nmats);
MAT.matyp                    = zeros(MAT.nmats,1);
props                        = @material_choice;
for jm=1:MAT.nmats    
    im                       = fscanf(fid,'%d',1);    
    MAT.matyp(im)            = fscanf(fid,'%d',1);
    properties               = props(MAT.matyp(im));
    format                   = repmat('%g ',1,length(properties));
    mat_properties           = (fscanf(fid,format,[length(properties),1]));
    if MAT.matyp(im)==17
       mu                    = mat_properties(2,im);
       lambda                = mat_properties(3,im);
       kappa                 = lambda + 2/3*mu;
       mat_properties        = [mat_properties(1:3); kappa; mat_properties(4:5)];
       properties            = 1:6;
    end
    MAT.props(properties,im) = mat_properties;
end
%--------------------------------------------------------------------------
% Compute the number of nearly incompressible elements in the domain.
%--------------------------------------------------------------------------
n_nearly_incompressible = 0;  
for ielement=1:FEM.mesh.nelem
    material_number = MAT.matno(ielement);     
    matyp = MAT.matyp(material_number);        
     if matyp==5 || matyp==7 || matyp==17
        n_nearly_incompressible = n_nearly_incompressible + 1;
     end    
end
MAT.n_nearly_incompressible = n_nearly_incompressible;
%--------------------------------------------------------------------------
% Obtain number of material properties for a given material type.
%--------------------------------------------------------------------------
function  property_numbers    = material_choice(matyp)
    switch matyp
        case 2
             property_numbers = (1:6);
        case 4
             property_numbers = (1:4);
        case 17
             property_numbers = (1:5);
        otherwise
             property_numbers = (1:3);
    end
end
end 

