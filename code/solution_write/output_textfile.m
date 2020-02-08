%--------------------------------------------------------------------------
% TXT file save of converged solution every CON.OUTPUT.incout increments.
% - Coordinates, element connectivity and stress.
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
function output_(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------

string='a';
%PRO.rest
%CON.incrm

if (~PRO.rest && CON.incrm==1)
    string='w';
    system('rm results.dat');
end

string2=sprintf('results.dat');
fid4= fopen(string2,string);

if (~PRO.rest && CON.incrm==1)
   % fprintf(fid4,'Variables = disp_y-flag GreensE22-flag lnU22-flag Small-strain22 NE-flag lnV-flag Cauchy22-flag \n');
   % fprintf(fid4,'Variables = disp_x disp_y F11 F12 F21 F22 \n');
end

%--------------------------------------------------------------------------
% Print title, load increment number and load factor.
%--------------------------------------------------------------------------
space = '   ';
output_title = [PRO.title space 'at increment:' space  ...
               num2str(CON.incrm) ', ' space 'load:  ' num2str(CON.xlamb)];

%--------------------------------------------------------------------------
% Print stresses.
%--------------------------------------------------------------------------
for ielement=1:FEM.mesh.nelem  
    
    if ielement == 1
        
        % extract undeformed coordinates
        info2                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
        info2(:,1)                 =  (1:GEOM.npoin)';
        info2(:,2)                 =  BC.icode;
        aux2                       =  zeros(FEM.mesh.n_dofs,1);
        aux2                       =  reshape(aux2,GEOM.ndime,[]);
        info2(:,3:end)             =  [GEOM.x0'  aux2'];

        % extract deformed coordinates
        info3                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
        info3(:,1)                 =  (1:GEOM.npoin)';
        info3(:,2)                 =  BC.icode;
        aux                       =  zeros(FEM.mesh.n_dofs,1);
        % aux(BC.fixdof)            =  GLOBAL.Reactions;
        % aux(BC.freedof)           =  GLOBAL.external_load(BC.freedof);
        aux                       =  reshape(aux,GEOM.ndime,[]);
        info3(:,3:end)             =  [GEOM.x'  aux'];
        
        if FEM.mesh.element_type == 'quad4'
           if QUADRATURE.ngauss == 4 
               %info3(2,3)
               %info3
              %n2xdisp=info3(2,3)-info2(2,3)
           end
        elseif FEM.mesh.element_type == 'hexa8'
           if QUADRATURE.ngauss == 8
                 n8disp=info3(8,4)-info2(8,4);
           end
        end
        
        
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
        %----------------------------------------------------------------------
        % Print stress.
        %----------------------------------------------------------------------    
        % 
        % compute average stress from all qaudrature points. Note that 
        % this could be put into an for loop, however I kept it seperate 
        % here to show more of what is going on...
        if FEM.mesh.element_type == 'quad4'
           if QUADRATURE.ngauss == 4 
               % flagshyp storage convention
               % |xx xy|         |1 2|
               % |   yy|  ---->  |  3|
               %
               xx = 1;
               xy = 2;
               yy = 3;

               % xx stress
               stress_avg(1)=(Stress(xx,1)+Stress(xx,2)+Stress(xx,3)+Stress(xx,4))/4.;
               % xy stress
               stress_avg(2)=(Stress(xy,1)+Stress(xy,3)+Stress(xy,3)+Stress(xy,4))/4.;
               % yy stress
               stress_avg(3)=(Stress(yy,1)+Stress(yy,2)+Stress(yy,3)+Stress(yy,4))/4.;
           end
        elseif FEM.mesh.element_type == 'hexa8'
           if QUADRATURE.ngauss == 8 
               % flagshyp storage convention
               % |xx xy xz|         |1 2 3|
               % |   yy yz|  ---->  |  4 5| %this is currently a guess - 3/2018
               % |      zz|         |    6
               xx = 1;
               xy = 2;
               xz = 3;
               yy = 4;
               yz = 5;
               zz = 6;

               % xx stress
               stress_avg(1)=(Stress(xx,1)+Stress(xx,2)+Stress(xx,3)+Stress(xx,4)+...
                              Stress(xx,5)+Stress(xx,6)+Stress(xx,7)+Stress(xx,8))/8.0;  
               % xy stress
               stress_avg(2)=(Stress(xy,1)+Stress(xy,3)+Stress(xy,3)+Stress(xy,4)+...
                              Stress(xy,5)+Stress(xy,6)+Stress(xy,7)+Stress(xy,8))/8.0;   
               % xz stress
               stress_avg(3)=(Stress(xz,1)+Stress(xz,2)+Stress(xz,3)+Stress(xz,4)+...
                              Stress(xz,5)+Stress(xz,6)+Stress(xz,7)+Stress(xz,8))/8.0;   
               % yy stress
               stress_avg(4)=(Stress(yy,1)+Stress(yy,2)+Stress(yy,3)+Stress(yy,4)+...
                              Stress(yy,5)+Stress(yy,6)+Stress(yy,7)+Stress(yy,8))/8.0;
               % yz stress
               stress_avg(5)=(Stress(yz,1)+Stress(yz,3)+Stress(yz,3)+Stress(yz,4)+...
                              Stress(yz,5)+Stress(yz,6)+Stress(yz,7)+Stress(yz,8))/8.0;   
               % zz stress
               stress_avg(6)=(Stress(zz,1)+Stress(zz,2)+Stress(zz,3)+Stress(zz,4)+...
                              Stress(zz,5)+Stress(zz,6)+Stress(zz,7)+Stress(zz,8))/8.0;            

           end
        end
        % compute average pressure per element
        if FEM.mesh.element_type == 'quad4'
           if QUADRATURE.ngauss == 4 
               pressure_avg=(1.0/3.0)*( stress_avg(1) + stress_avg(3));% pressure in 2D ??? (is 1/3 correct?)           
           end
        elseif FEM.mesh.element_type == 'hexa8'
           if QUADRATURE.ngauss == 8
               pressure_avg=(1.0/3.0)*( stress_avg(1) + stress_avg(4) + stress_avg(6)) ;
           end
        end


        KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                              QUADRATURE,KINEMATICS)  ;     
        %KINEMATICS.F
        F_avg_over_gauss_pts=zeros(GEOM.ndime,GEOM.ndime);
        Green_Strain_Avg=zeros(GEOM.ndime,GEOM.ndime);
        for igauss=1:QUADRATURE.ngauss 
             kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss);
             F_avg_over_gauss_pts= F_avg_over_gauss_pts+ kinematics_gauss.F;
        end
        % xlocal
        F_avg_over_gauss_pts= F_avg_over_gauss_pts/QUADRATURE.ngauss;
        Green_Strain_Avg = (1./2.)*(F_avg_over_gauss_pts'*F_avg_over_gauss_pts-eye(GEOM.ndime));
        b_avg = F_avg_over_gauss_pts*F_avg_over_gauss_pts';
        Eulerian_Strain_Avg = (1./2.)*( eye(GEOM.ndime) - inv(b_avg));
        %Green_Strain_Avg(2,2);

        C_avg=F_avg_over_gauss_pts'* F_avg_over_gauss_pts;
        [C_e_vectors,C_e_values] =eig(C_avg);
        if GEOM.ndime == 2
            %nonzero=any(C_e_vectors(1,3))
            U_avg=[sqrt(C_e_values(1,1)), 0; 0, sqrt(C_e_values(GEOM.ndime,GEOM.ndime))];
        elseif GEOM.ndime == 3
            %nonzero=any(C_e_vectors(1,2))
            U_avg=[sqrt(C_e_values(1,1)), 0, 0; 0, sqrt(C_e_values(2,2)),0;....
                0,0,sqrt(C_e_values(3,3))];
        end
            
        %gradu=F_avg_over_gauss_pts-eye(GEOM.ndime);
        %smalle=.5*(gradu+gradu');
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
        Abaqus_NE= lambda_avg-1; 
        lnV=log(lambda_avg)
        %log(lambda_avg);


        %----------------------------------------------------------------------
        % Print strain.
        %----------------------------------------------------------------------   
        if FEM.mesh.element_type == 'quad4'
           if QUADRATURE.ngauss == 4
               %fprintf(fid3,'%s%s%s%s%s%.10e %.10e ',space,space,space,space,space,...
               %        Green_Strain_Avg(1,1),Green_Strain_Avg(1,2));
               %fprintf(fid3,'%.10e %.10e\n',Green_Strain_Avg(2,1),Green_Strain_Avg(2,2));
           end
        elseif FEM.mesh.element_type == 'hexa8'
           if QUADRATURE.ngauss == 8
               %fprintf(fid3,'%s%s%s%s%s%.5e %.5e %.5e ',space,space,space,space,space,...
               %        Green_Strain_Avg(1,1),Green_Strain_Avg(1,2),Green_Strain_Avg(1,3));
               %fprintf(fid3,'%.5e %.5e %.5e ', Green_Strain_Avg(2,1),Green_Strain_Avg(2,2),Green_Strain_Avg(2,3));
               %fprintf(fid3,'%.5e %.5e %.5e\n',Green_Strain_Avg(3,1),Green_Strain_Avg(3,2),Green_Strain_Avg(3,3));
           end
        end



        if FEM.mesh.element_type == 'quad4'
           if QUADRATURE.ngauss == 4 
              if (~PRO.rest && CON.incrm==1)
                         %      step  F11   F12    F21     F22    lnv=V  sxx    sxy    syy
                   fprintf(fid4,'%d  %.10e  %.10e  %.10e  %.10e  %.10e  %.10e  %.10e  %.10e\n',...
                                 0,   1,     0,    0,       1,      0,     0,     0,    0);
              end 
              fprintf(fid4,'%d %.10e %.10e %.10e %.10e %.10e %.10e %.10e %.10e\n',...
                   CON.incrm,F_avg_over_gauss_pts(1,1),F_avg_over_gauss_pts(1,2),F_avg_over_gauss_pts(2,1),...
                   F_avg_over_gauss_pts(2,2),...
                   lnV,stress_avg(1),stress_avg(2),stress_avg(3)); 
               %F_avg_over_gauss_pts(1,1)
           end
        elseif FEM.mesh.element_type == 'hexa8'
           if QUADRATURE.ngauss == 8
               if (~PRO.rest && CON.incrm==1)
                   fprintf(fid4,'%d %.10e %.10e\n',0,0,0);
               end
               fprintf(fid4,'%d %.10e %.10e\n',...
                   CON.incrm,lnV,stress_avg(4)); 
               %F_avg_over_gauss_pts
               %Green_Strain_Avg(2,2)
           end
        end 
   
    
    
    end

end 


fclose(fid4);






