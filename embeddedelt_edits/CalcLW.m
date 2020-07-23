Stress = stress_output(GEOM.ndime,PLAST,1,1,GEOM.x,GEOM.x0,...
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
    [b_e_vectors,b_e_values] = eig(b_avg);
    
    V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
              sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)'+ ...
              sqrt(b_e_values(3,3))*b_e_vectors(:,3)*b_e_vectors(:,3)';
           
           lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)'+ ...
               log(sqrt(b_e_values(3,3)))*b_e_vectors(:,3)*b_e_vectors(:,3)'
