function plot_stresses(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

space = '   ';

%--------------------------------------------------------------------------
% Print stresses.
%--------------------------------------------------------------------------
% fprintf(fid3,'CELL_DATA %d\n',FEM.mesh.nelem );
% fprintf(fid3,'TENSORS STRESS FLOAT\n');
fprintf(fid3,'%s%s%s<CellData>\n',space,space,space);
if GEOM.ndime == 2
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Stress" ', space,space,space,space);
    fprintf(fid3,'NumberOfComponents="4" ');
    fprintf(fid3,'ComponentName0="xx" '); 
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="yy" ');
    fprintf(fid3,'ComponentName3="pressure" format="ascii">\n');
elseif GEOM.ndime == 3
    fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Stress" ', space,space,space,space);
    fprintf(fid3,'NumberOfComponents="7" ');
    fprintf(fid3,'ComponentName0="xx" ');
    fprintf(fid3,'ComponentName1="xy" ');
    fprintf(fid3,'ComponentName2="xz" ');
    fprintf(fid3,'ComponentName3="yy" ');
    fprintf(fid3,'ComponentName4="yz" ');
    fprintf(fid3,'ComponentName5="zz" ');
    fprintf(fid3,'ComponentName6="pressure" format="ascii">\n');
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
           % |   zz|  ---->  |  3|
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
   
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4 
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e\n',space,space,space,space,space,...
               stress_avg(1),stress_avg(2),stress_avg(3),pressure_avg);        
       end
   elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e %.10e %.10e %.10e \n',...
               space,space,space,space,space,...
               stress_avg(1),stress_avg(2),stress_avg(3),...
               stress_avg(4),stress_avg(5),stress_avg(6),pressure_avg);            
       end
   end  


end 

fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);

end

