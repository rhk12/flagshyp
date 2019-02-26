function plot_Eulerian_strain(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

space = '   ';


if GEOM.ndime == 2
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="e (Eulerian)" ',space,space,space,space);
    fprintf(fid3,'NumberOfComponents="4" ');
    fprintf(fid3,'ComponentName0="xx" '); 
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="yx" ');
    fprintf(fid3,'ComponentName3="yy" ');
    fprintf(fid3,'format="ascii">\n');
elseif GEOM.ndime == 3
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="e (Eulerian)" ',space,space,space,space);
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
     

    KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                          QUADRATURE,KINEMATICS)  ;     
    %KINEMATICS.F
    F_avg_over_gauss_pts=zeros(GEOM.ndime,GEOM.ndime);
    for igauss=1:QUADRATURE.ngauss 
         kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss);
         F_avg_over_gauss_pts= F_avg_over_gauss_pts+ kinematics_gauss.F;
         % KINEMATICS.F
    end
    % compute average F (over gauss points)
    F_avg_over_gauss_pts= F_avg_over_gauss_pts/QUADRATURE.ngauss;
  
    %KINEMATICS.b;
    b_avg = F_avg_over_gauss_pts * F_avg_over_gauss_pts';
    
    e=(1./2.)*(eye(GEOM.ndime)-inv(b_avg));
   
    %----------------------------------------------------------------------
    % Print Eulerian Strain.
    %----------------------------------------------------------------------   
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e \n',space,space,space,space,space,...
                   e(1,1),e(1,2), e(2,1),e(2,2));
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8
            fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e %.10e %.10e %.10e %.10e %.10e  \n',space,space,space,space,space,...
                   e(1,1),e(1,2),e(1,3),e(2,1),e(2,2),e(2,3),e(3,1),e(3,2),e(3,3)   );          
       end
    end
    
 
end
 
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space); 



end

