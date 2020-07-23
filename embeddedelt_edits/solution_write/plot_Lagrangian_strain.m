function plot_Lagrangian_strain(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

space = '   ';


if GEOM.ndime == 2
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="E(Lagrangian)" ',space,space,space,space);
    fprintf(fid3,'NumberOfComponents="4" ');
    fprintf(fid3,'ComponentName0="xx" '); 
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="yx" ');
    fprintf(fid3,'ComponentName3="yy" ');
    fprintf(fid3,'format="ascii">\n');
elseif GEOM.ndime == 3
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="E(Lagrangian)" ',space,space,space,space);
    fprintf(fid3,'NumberOfComponents="9" ');
    fprintf(fid3,'ComponentName0="xx" ');
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="xz" ');
    fprintf(fid3,'ComponentName3="yx" ');
    fprintf(fid3,'ComponentName4="yy" ');
    fprintf(fid3,'ComponentName5="yz" ');
    fprintf(fid3,'ComponentName6="zx" ');
    fprintf(fid3,'ComponentName7="zy" ');
    fprintf(fid3,'ComponentName8="zz" ');    
    fprintf(fid3,'format="ascii">\n');
end
for ielement=1:FEM.mesh.nelem  

    %----------------------------------------------------------------------
    % Temporary variables associated with a particular element
    % ready for stress outpue calculation.
    %----------------------------------------------------------------------
    global_nodes    = FEM.mesh.connectivity(:,ielement); 
    material_number = MAT.matno(ielement);               
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number);      
    xlocal          = GEOM.x(:,global_nodes);            
    x0local         = GEOM.x0(:,global_nodes);               
    Ve              = GEOM.Ve(ielement);                 
    %----------------------------------------------------------------------
    % Select internal variables within the element (PLAST).
    %----------------------------------------------------------------------
    PLAST_element = selecting_internal_variables_element(PLAST,matyp,ielement);    
    %----------------------------------------------------------------------
    % Compute stresses at Gauss point level.
    %----------------------------------------------------------------------
    Stress = stress_output(GEOM.ndime,PLAST_element,matyp,Ve,xlocal,x0local,...
                           properties,QUADRATURE,CONSTANT,FEM,KINEMATICS,GEOM);    

    KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                          QUADRATURE,KINEMATICS)  ;     
    %KINEMATICS.F
    F_avg_over_gauss_pts=zeros(GEOM.ndime,GEOM.ndime);
    for igauss=1:QUADRATURE.ngauss 
         kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss);
         F_avg_over_gauss_pts= F_avg_over_gauss_pts+ kinematics_gauss.F;
%          KINEMATICS.F
        
    end
    %xlocal-x0local
    
    F_avg_over_gauss_pts= F_avg_over_gauss_pts/QUADRATURE.ngauss;
    Green_Strain_Avg = (1./2.)*(F_avg_over_gauss_pts'*F_avg_over_gauss_pts-eye(GEOM.ndime));
    
    C_avg=F_avg_over_gauss_pts'* F_avg_over_gauss_pts;
    [C_e_vectors,C_e_values] =eig(C_avg);
    
    U_avg=[sqrt(C_e_values(1,1)), 0; 0, sqrt(C_e_values(GEOM.ndime,GEOM.ndime))];
    gradu=F_avg_over_gauss_pts-eye(GEOM.ndime);
    %smalle=.5*(gradu+gradu')
    
    %lnE=log(Green_Strain_Avg(2,2))
    %KINEMATICS.n;
    %KINEMATICS.lambda
    %QUADRATURE.ngauss
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4 % the 2 is b/c it is the largest e-value from matlab 
           lambda_avg=(KINEMATICS.lambda(2,1)+ KINEMATICS.lambda(2,2)+ ...
                       KINEMATICS.lambda(2,3)+ KINEMATICS.lambda(2,4))/4.0;
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8 % the 3 is b/c it is the largest e-value from matlab 
           lambda_avg=(KINEMATICS.lambda(3,1)+ KINEMATICS.lambda(3,2)+ ...
                       KINEMATICS.lambda(3,3)+ KINEMATICS.lambda(3,4)+...
                       KINEMATICS.lambda(3,5)+ KINEMATICS.lambda(3,6)+ ...
                       KINEMATICS.lambda(3,7)+ KINEMATICS.lambda(3,8))/8.0;
       end
    end
   
    
   % fprintf(fid4,'%.5f %.5f %.5f %.5f %.5f %.5f %.5f \n',...
   %   xlocal(2,3)-x0local(2,3),Green_Strain_Avg(2,2),log(U_avg(2,2)),smalle(2,2),Abaqus_NE,lnV,stress_avg(3));
 % xlocal;

       
    %----------------------------------------------------------------------
    % Print Green Strain.
    %----------------------------------------------------------------------   
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e ',space,space,space,space,space,...
                   Green_Strain_Avg(1,1),Green_Strain_Avg(1,2));
           fprintf(fid3,'%.10e %.10e\n',Green_Strain_Avg(2,1),Green_Strain_Avg(2,2));
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8
           fprintf(fid3,'%s%s%s%s%s%.5e %.5e %.5e ',space,space,space,space,space,...
                   Green_Strain_Avg(1,1),Green_Strain_Avg(1,2),Green_Strain_Avg(1,3));
           fprintf(fid3,'%.5e %.5e %.5e ', Green_Strain_Avg(2,1),Green_Strain_Avg(2,2),Green_Strain_Avg(2,3));
           fprintf(fid3,'%.5e %.5e %.5e\n',Green_Strain_Avg(3,1),Green_Strain_Avg(3,2),Green_Strain_Avg(3,3));
       end
    end
    
 
end
 
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space); 

end

