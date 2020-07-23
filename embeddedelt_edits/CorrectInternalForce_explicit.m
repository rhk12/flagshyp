function [T_internal,PLAST_element] = CorrectInternalForce_explicit(FEM,GEOM,ielement,...
    element_connectivity,Ve,QUADRATURE,MAT,PLAST,plast_gauss,counter,KINEMATICS)
%Embedded Element Addition

%Get info about host
ihost=ielement;
global_nodes_h= FEM.mesh.connectivity(:,ielement);
x0_host=GEOM.x0(:,global_nodes_h);
x_host=GEOM.x(:,global_nodes_h);
mat_num_h=MAT.matno(ielement);  
properties_h=MAT.props(:,mat_num_h);
matyp_h=MAT.matyp(mat_num_h); 
PLAST_h=PLAST;
plast_gauss_h=plast_gauss;
dim=GEOM.ndime;

%Loop over all embedded elements nf
for iembed=FEM.mesh.embedded
 %Calculate displacment of embedded elements?
 
 %Check if this element is in host element ihost
 if (1)
    
     %Get info about the embedded element
        global_nodes_f= FEM.mesh.connectivity(:,iembed);
        x0_f=GEOM.x0(:,global_nodes_f);
        x_f=GEOM.x(:,global_nodes_f);
        mat_num_f=MAT.matno(iembed);  
        properties_f=MAT.props(:,mat_num_f);
        matyp_f=MAT.matyp(mat_num_f); 
     
     
     %Loop over embedded element gauss points
     for igaussf=1:QUADRATURE.ngauss     
         
         %Find isoparametric coordinates of the gauss point in terms of the 
         %host element natrual domain
         x0g =find_xyz(QUADRATURE.element.Chi(igaussf,:),x0_f); 
         zgf = find_natural_coords(x0g, x0_h, 'hexa8');
         
         %Extract kinematics at the particular Gauss point

         %Calculate shape functions and their derivatives at embedded
         %element gauss poing (INTERPOLATION.N &.DN_chi)
         INTERPOLATION_GF = shape_functions_library(zgf','hexa8');
         
         
     end
     
 end
 
 
 
 
%Figure out what to do about saving plasticity in embedded elements   
    
    
end