%--------------------------------------------------------------------------
% TXT file save of converged solution every CON.OUTPUT.incout increments.
% - Coordinates, element connectivity and stress.
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
function output_vtu(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------

if (~PRO.rest && CON.incrm==0)
    string='w';
    system('rm out-*.vtu');
    system('rm out-*.vtk');
end


string2=sprintf('out-%d.vtu',CON.incrm);
fid3= fopen(string2,'w');


%--------------------------------------------------------------------------
% Print title, load increment number and load factor.
%--------------------------------------------------------------------------
space = '   ';
output_title = [PRO.title space 'at increment:' space  ...
               num2str(CON.incrm) ', ' space 'load:  ' num2str(CON.xlamb)];


fprintf(fid3,'<?xml version="1.0"?>\n');
fprintf(fid3,'<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian">\n');
fprintf(fid3,'%s<UnstructuredGrid>\n',space);
fprintf(fid3,'%s%s<Piece NumberOfPoints="%d" NumberOfCells="%d">\n',...
    space,space,GEOM.npoin, FEM.mesh.nelem);


%--------------------------------------------------------------------------
% Print element type. 
%--------------------------------------------------------------------------
% fprintf(fid,'%c',FEM.mesh.element_type);
% fprintf(fid,'\n');
%--------------------------------------------------------------------------
% Print number of nodes.
%--------------------------------------------------------------------------
% fprintf(fid,'%d',GEOM.npoin);
% fprintf(fid,'\n');
%fprintf(fid3,'POINTS %d FLOAT\n',GEOM.npoin);
%--------------------------------------------------------------------------
% Print boundary codes, coordinates, reactions and external loads.
%--------------------------------------------------------------------------
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

fprintf(fid3,'%s%s%s<Points>\n',space,space,space);
fprintf(fid3,'%s%s%s%s<DataArray type="Float32" NumberOfComponents="3" format="ascii">\n',...
    space,space,space,space);

for i = 1:GEOM.npoin
    if GEOM.ndime == 2
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
        info3(i,3),info3(i,4),0.0);
    elseif GEOM.ndime == 3
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
        info3(i,3),info3(i,4),info3(i,5));
    end
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);
fprintf(fid3,'%s%s%s</Points>\n',space,space,space);
%--------------------------------------------------------------------------
% Print material type and connectivities.
%--------------------------------------------------------------------------
% fprintf(fid,'%d',FEM.mesh.nelem);


%fprintf(fid3,'CELLS %d %d\n',FEM.mesh.nelem,FEM.mesh.nelem*(4+1) );

% fprintf(fid,'\n');
info                      =  zeros(FEM.mesh.nelem,2+FEM.mesh.n_nodes_elem);
info(:,1)                 =  (1:FEM.mesh.nelem)';
info(:,2)                 =  MAT.matno;
info(:,3:end)             =  FEM.mesh.connectivity';
% format                    =  ['%d %d ' repmat('%d ',1,FEM.mesh.n_nodes_elem) '\n'];
% fprintf(fid,format,info');

fprintf(fid3,'%s%s%s<Cells>\n',space,space,space);

fprintf(fid3,'%s%s%s%s<DataArray type="Int32" Name="connectivity" format="ascii">\n',....
    space,space,space,space);

if FEM.mesh.element_type == 'quad4'
    for i = 1:FEM.mesh.nelem
        fprintf(fid3,'%s%s%s%s%s%d %d %d %d\n',space,space,space,space,space,info(i,3)-1,info(i,4)-1,...
        info(i,5)-1,info(i,6)-1 );
    end
elseif FEM.mesh.element_type == 'hexa8'
    for i = 1:FEM.mesh.nelem
        fprintf(fid3,'%s%s%s%s%s%d %d %d %d %d %d %d %d\n',space,space,space,space,space,...
            info(i,3)-1,info(i,4)-1,info(i,5)-1,info(i,6)-1,...
            info(i,7)-1,info(i,8)-1,info(i,9)-1,info(i,10)-1);
    end
end

fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);




fprintf(fid3,'%s%s%s%s<DataArray type="Int32" Name="offsets" format="ascii">\n',....
    space,space,space,space);
for i = 1:FEM.mesh.nelem
    fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,i*FEM.mesh.n_nodes_elem);
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);


fprintf(fid3,'%s%s%s%s<DataArray type="UInt8" Name="types" format="ascii">\n',...
   space,space,space,space);
%fprintf(fid3,'CELL_TYPES %d\n',FEM.mesh.nelem);
for i = 1:FEM.mesh.nelem
    if FEM.mesh.element_type == 'quad4'
        fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,9);  % element type = quad
    elseif FEM.mesh.element_type == 'hexa8'
        fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,12);  % element type = hex
    end 
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);
fprintf(fid3,'%s%s%s</Cells>\n',space,space,space);

%--------------------------------------------------------------------------
% Print Point/Node Data
%--------------------------------------------------------------------------

% dispacements
% fprintf(fid3,'POINT_DATA %d\n',GEOM.npoin);
% fprintf(fid3,'VECTORS DISP FLOAT\n');
% for i = 1:GEOM.npoin
%     fprintf(fid3,'%.10e %.10e %.10e\n',info3(i,3)-info2(i,3),info3(i,4)-info2(i,4),0.0);
% end
fprintf(fid3,'%s%s%s<PointData>\n',space,space,space);

fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Disp" NumberOfComponents="3" ComponentName0="x" ComponentName1="y" ComponentName2="z" format="ascii">\n',...
    space,space,space,space);
for i = 1:GEOM.npoin
    if GEOM.ndime == 2
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
            info3(i,3)-info2(i,3),info3(i,4)-info2(i,4),0.0);
    elseif GEOM.ndime == 3
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
            info3(i,3)-info2(i,3),info3(i,4)-info2(i,4),info3(i,5)-info2(i,5)); 
    end
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);



fprintf(fid3,'%s%s%s%s<DataArray type="Int32" Name="Boundary" NumberOfComponents="1" ComponentName0="BC_Value" format="ascii">\n',...
    space,space,space,space);
for i = 1:GEOM.npoin
    fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,info2(i,2));
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);


fprintf(fid3,'%s%s%s</PointData>\n',space,space,space);



% velocities

% accelerations



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
    xlocal-x0local;
    
    F_avg_over_gauss_pts= F_avg_over_gauss_pts/QUADRATURE.ngauss;
    Green_Strain_Avg = (1./2.)*(F_avg_over_gauss_pts'*F_avg_over_gauss_pts-eye(GEOM.ndime));
    
    C_avg=F_avg_over_gauss_pts'* F_avg_over_gauss_pts;
    [C_e_vectors,C_e_values] =eig(C_avg);
    
    U_avg=[sqrt(C_e_values(1,1)), 0; 0, sqrt(C_e_values(GEOM.ndime,GEOM.ndime))];
    gradu=F_avg_over_gauss_pts-eye(GEOM.ndime);
    smalle=.5*(gradu+gradu');
    
     %lnU=log(sqrt(C_e_values(1,1)))*C_e_vectors(:,1)*C_e_vectors(:,1)'+ ...
     %    log(sqrt(C_e_values(2,2)))*C_e_vectors(:,2)*C_e_vectors(:,2)'
    
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
    logm(sqrtm(b_avg));
    
    [b_e_vectors,b_e_values] = eig(b_avg);

    
    % take care of ln(0) = -Inf 
    if FEM.mesh.element_type == 'quad4'
       if QUADRATURE.ngauss == 4 % the 2 is b/c it is the largest e-value from matlab 
           V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
           lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
               log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
             
           %lnV=log(V_avg);
         
           
           if isinf(lnV(1,2)) == 1
               lnV(1,2)=0;
           end
           if isinf(lnV(2,1)) == 1
               lnV(2,1)=0;
           end
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8 % the 3 is b/c it is the largest e-value from matlab 
           if isinf(lnV(1,2)) == 1
               lnV(1,2)=0;
           end
           if isinf(lnV(2,1)) == 1
               lnV(2,1)=0;
           end
           if isinf(lnV(1,3)) == 1
               lnV(1,3)=0;
           end
           if isinf(lnV(3,1)) == 1
               lnV(3,1)=0;
           end
           if isinf(lnV(2,3)) == 1
               lnV(2,3)=0;
           end
           if isinf(lnV(3,2)) == 1
               lnV(3,2)=0;
           end
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
           fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e %.10e ',space,space,space,space,space,...
                   lnV(1,1),lnV(1,2), lnV(2,1),lnV(2,2));
           %fprintf(fid3,'%.10e %.10e\n',Green_Strain_Avg(2,1),Green_Strain_Avg(2,2));
       end
    elseif FEM.mesh.element_type == 'hexa8'
       if QUADRATURE.ngauss == 8
           %fprintf(fid3,'%s%s%s%s%s%.5e %.5e %.5e ',space,space,space,space,space,...
            %       Green_Strain_Avg(1,1),Green_Strain_Avg(1,2),Green_Strain_Avg(1,3));
           %fprintf(fid3,'%.5e %.5e %.5e ', Green_Strain_Avg(2,1),Green_Strain_Avg(2,2),Green_Strain_Avg(2,3));
           %fprintf(fid3,'%.5e %.5e %.5e\n',Green_Strain_Avg(3,1),Green_Strain_Avg(3,2),Green_Strain_Avg(3,3));
       end
    end
    
 
end
 
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space); 







fprintf(fid3,'%s%s%s</CellData>\n',space,space,space);



%--------------------------------------------------------------------------
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
if (~isempty (CON.OUTPUT.nwant) && CON.OUTPUT.nwant~=0)
    increment  = CON.incrm;   
    coordinate = GEOM.x(CON.OUTPUT.iwant,CON.OUTPUT.nwant);
    Force      = GLOBAL.external_load(FEM.mesh.dof_nodes(CON.OUTPUT.iwant,CON.OUTPUT.nwant));
    xlamb      = CON.xlamb;
    radius     = CON.ARCLEN.arcln;
%     format     = [repmat('% -1.4E ',1,5) '\n'];
%     fprintf(fid_flagout,format,[increment,coordinate,Force,xlamb,radius]);
end
% fprintf(fid,['\n' repmat('-',1,length(output_title))]);
% fprintf(fid,['\n' repmat('-',1,length(output_title)) '\n\n']);
% fclose(fid);

fprintf(fid3,'%s%s</Piece>\n',space,space);
fprintf(fid3,'%s</UnstructuredGrid>\n',space);
fprintf(fid3,'</VTKFile>\n');


fclose(fid3);

% if (~isempty (CON.OUTPUT.nwant) && CON.OUTPUT.nwant~=0)
%    fclose(fid_flagout);
% end





