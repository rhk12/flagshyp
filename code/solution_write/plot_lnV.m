function plot_lnV(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

space = '   ';


if GEOM.ndime == 2
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="LE (lnV)" ',space,space,space,space);
    fprintf(fid3,'NumberOfComponents="4" ');
    fprintf(fid3,'ComponentName0="xx" '); 
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="yx" ');
    fprintf(fid3,'ComponentName3="yy" ');
    fprintf(fid3,'format="ascii">\n');
elseif GEOM.ndime == 3
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="LE (lnV)" ',space,space,space,space);
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
         % KINEMATICS.F
    end
    % compute average F (over gauss points)
    F_avg_over_gauss_pts= F_avg_over_gauss_pts/QUADRATURE.ngauss;
  
    %KINEMATICS.b;
    b_avg = F_avg_over_gauss_pts * F_avg_over_gauss_pts';
   
    % can be used to check calculation
    %logm(sqrtm(b_avg));
    
    [b_e_vectors,b_e_values] = eig(b_avg);

    
    % take care of ln(0) = -Inf 
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4 % the 2 is b/c it is the largest e-value from matlab 
           V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
           lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
             
           %lnV=log(V_avg);
         
%            
%            if isinf(lnV(1,2)) == 1
%                lnV(1,2)=0;
%            end
%            if isinf(lnV(2,1)) == 1
%                lnV(2,1)=0;
%            end
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8 % the 3 is b/c it is the largest e-value from matlab 
          V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
              sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)'+ ...
              sqrt(b_e_values(3,3))*b_e_vectors(:,3)*b_e_vectors(:,3)';
           
           lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)'+ ...
               log(sqrt(b_e_values(3,3)))*b_e_vectors(:,3)*b_e_vectors(:,3)'
           
%            if isinf(lnV(1,2)) == 1
%                lnV(1,2)=0;
%            end
%            if isinf(lnV(2,1)) == 1
%                lnV(2,1)=0;
%            end
%            if isinf(lnV(1,3)) == 1
%                lnV(1,3)=0;
%            end
%            if isinf(lnV(3,1)) == 1
%                lnV(3,1)=0;
%            end
%            if isinf(lnV(2,3)) == 1
%                lnV(2,3)=0;
%            end
%            if isinf(lnV(3,2)) == 1
%                lnV(3,2)=0;
%            end
       end
    end
    %lnV
    Abaqus_NE= V-eye(GEOM.ndime);
 
    
   % fprintf(fid4,'%.5f %.5f %.5f %.5f %.5f %.5f %.5f \n',...
   %   xlocal(2,3)-x0local(2,3),Green_Strain_Avg(2,2),log(U_avg(2,2)),smalle(2,2),Abaqus_NE,lnV,stress_avg(3));
 % xlocal;

       
    %----------------------------------------------------------------------
    % Print Logrithmic Strain.
    %----------------------------------------------------------------------   
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e \n',space,space,space,space,space,...
                   lnV(1,1),lnV(1,2), lnV(2,1),lnV(2,2));
           %fprintf(fid3,'%.10e %.10e\n',Green_Strain_Avg(2,1),Green_Strain_Avg(2,2));
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e  %.10e %.10e %.10e  %.10e %.10e\n',space,space,space,space,space,...
                   lnV(1,1),lnV(1,2), lnV(1,3),lnV(2,1),lnV(2,2), lnV(2,3),lnV(3,1), lnV(3,2),lnV(3,3)); 
       end
    end
    
 
end
 
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space); 








end

