%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
%  GENERATE THE GEOMETRY OF THE TWISTING COLUMN
%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
clear all
clc
%--------------------------------------------------------------------------
% Generate the geometry for the column (without the added artificial 
% domain where pressure boundary conditions will be added)
%--------------------------------------------------------------------------
Xmin1                               =  -0.5;
Xmax1                               =  0.5;
Ymin1                               =  -0.5;
Ymax1                               =  0.5;
Zmin1                               =  0; 
Zmax1                               =  6;
h                                   =  0.25;  %  Size of all the elements of the mesh
Ndivx1                              =  (Xmax1 - Xmin1)/h;
Ndivy1                              =  (Ymax1 - Ymin1)/h;
Ndivz1                              =  (Zmax1 - Zmin1)/h;
[nodes_a,connectivity_a]            =  prismatic_mesh_generator(Xmin1,Xmax1,Ymin1,Ymax1,Zmin1,Zmax1,Ndivx1,Ndivy1,Ndivz1);
%--------------------------------------------------------------------------
% Generate the geometry for the artificial domain where pressure boundary 
% conditions will be added) 
%--------------------------------------------------------------------------
Xmin2                               =  -1.5;
Xmax2                               =  1.5; 
Ymin2                               =  -0.5;
Ymax2                               =  0.5; 
Zmin2                              =  6;
Zmax2                              =  7;
Ndivx2                              =  (Xmax2 - Xmin2)/h;
Ndivy2                              =  (Ymax2 - Ymin2)/h;
Ndivz2                              =  (Zmax2 - Zmin2)/h;
%Ndivz2                              =  2;
[nodes_b,connectivity_b]            =  prismatic_mesh_generator(Xmin2,Xmax2,Ymin2,Ymax2,Zmin2,Zmax2,Ndivx2,Ndivy2,Ndivz2);
connectivity_b                      =  connectivity_b + size(nodes_a,1);
%--------------------------------------------------------------------------
% Concatenate geometry and connectivities of both domains 
%--------------------------------------------------------------------------
nodes                               =  [nodes_a;nodes_b];
connectivity                        =  [connectivity_a;connectivity_b];
  
%--------------------------------------------------------------------------
% Remove coordinates of the redundant nodes and rename the connectivities
%--------------------------------------------------------------------------
[a1,ia,ic]                         =  unique(nodes,'rows','stable');
nodes                              =  nodes(ia,:);
connectivity                       =  ic(connectivity);

%--------------------------------------------------------------------------
% Determine boundary codes. Fixed coordinate z=0.
%--------------------------------------------------------------------------
boundary_codes                     =  zeros(size(nodes,1),1);
constrained_nodes                  =  search_specific_location_nodes(nodes,[],[],[],[],Zmin1,Zmin1,1e-6);
boundary_codes(constrained_nodes)  =  7;       
 
%--------------------------------------------------------------------------
% Determine nodes where the positive pressure will be applied  
%--------------------------------------------------------------------------
positive_pressure_nodes                  =  search_specific_location_nodes(nodes,(Xmin2+Xmax2)/2,Xmax2,Ymax2,Ymax2,Zmin2,Zmax2,1e-6);
[positive_pressure_coordinates,i]        =  sortrows(nodes(positive_pressure_nodes,:),[3 1 2]);
positive_pressure_element_connectivity   =  connectivity_given_ordered_nodes(positive_pressure_coordinates(:,[1 3]));  %  Find the connectivity given a set of order nodes.
positive_pressure_nodes                  =  positive_pressure_nodes(i);
positive_pressure_element_connectivity   =  positive_pressure_nodes(positive_pressure_element_connectivity); 
%--------------------------------------------------------------------------
% Determine nodes where the positive pressure will be applied 
%--------------------------------------------------------------------------
negative_pressure_nodes                  =  search_specific_location_nodes(nodes,Xmin2,(Xmin2+Xmax2)/2,Ymax2,Ymax2,Zmin2,Zmax2,1e-6);
[negative_pressure_coordinates,i]            =  sortrows(nodes(negative_pressure_nodes,:),[3 1 2]);
negative_pressure_element_connectivity   =  connectivity_given_ordered_nodes(negative_pressure_coordinates(:,[1 3]));  %  Find the connectivity given a set of order nodes.
negative_pressure_nodes                  =  negative_pressure_nodes(i);
negative_pressure_element_connectivity   =  negative_pressure_nodes(negative_pressure_element_connectivity); 

%--------------------------------------------------------------------------
% Determine node where to plot (arc-length)
%--------------------------------------------------------------------------
for inode=1:size(nodes,1)
    if abs(nodes(inode,1) - Xmax2)<1e-6
       if abs(nodes(inode,2) - Ymax2)<1e-6
          if abs(nodes(inode,3) - Zmax2)<1e-6
             node_ploting                =  inode;
             break;
          end
       end
    end
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
%  GENERATE INPUT FILE OF THE TWISTING COLUMN 
% 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
fid                      =  fopen('twisting_column.dat','w');

%--------------------------------------------------------------------------
% Print title 
%--------------------------------------------------------------------------
file_title              =  '3-D twisting column';
fprintf(fid,'%c',file_title);
fprintf(fid,'\n');
%--------------------------------------------------------------------------
% Print element type 
%--------------------------------------------------------------------------
fprintf(fid,'hexa8');
fprintf(fid,'\n');

%--------------------------------------------------------------------------
% Print number of nodes
%--------------------------------------------------------------------------
fprintf(fid,'%d',size(nodes,1));
fprintf(fid,'\n');
 
%--------------------------------------------------------------------------
% Print boundary codes, coordinates, Residuals and external loads
%--------------------------------------------------------------------------
info                      =  [(1:size(nodes,1))'  boundary_codes  nodes];
format                    =  ['%d %d ' repmat('% -1.4E ',1,size(nodes,2)) '\n'];
fprintf(fid,format,info');

%--------------------------------------------------------------------------
% Print material type and connectivities
%--------------------------------------------------------------------------
fprintf(fid,'%d',size(connectivity,1));
fprintf(fid,'\n');
info                      =  zeros(size(connectivity,1),2+size(connectivity,2));
info(:,1)                 =  (1:size(connectivity,1))';
info(:,2)                 =  1;
info(:,3:end)             =  connectivity;
format                    =  ['%d %d ' repmat('%d ',1,size(connectivity,2)) '\n'];
fprintf(fid,format,info');

%--------------------------------------------------------------------------
% Print material properties
%--------------------------------------------------------------------------
fprintf(fid,'%d',1);  %  Print number of materials
fprintf(fid,'\n');

fprintf(fid,'%d %d',[1  17]);
fprintf(fid,'\n');

rho                       =  1;
mu                        =  100;
lambda                    =  100;
ty                        =  5000000000000000;
H                         =  50;  
fprintf(fid,'%d %d %d  %d  %d',[rho mu lambda  ty  H]);
fprintf(fid,'\n');

%--------------------------------------------------------------------------
% Loads
%--------------------------------------------------------------------------
nbpel                     =  (size(negative_pressure_element_connectivity,1) + size(positive_pressure_element_connectivity,1));
fprintf(fid,'%d  %d  %d  % -1.4E  % -1.4E  % -1.4E',[0  0  (size(negative_pressure_element_connectivity,1) + size(positive_pressure_element_connectivity,1))  0   0  0]);
fprintf(fid,'\n');

%--------------------------------------------------------------------------
% Pressure loads
%--------------------------------------------------------------------------
pressure                  =  1e1;
info                      =  zeros(nbpel,6);
info(:,1)                 =  (1:nbpel)';
info(:,2:5)               =  [positive_pressure_element_connectivity;negative_pressure_element_connectivity];
%info(:,6)                 =  4;
info(:,6)                 =  pressure*[ones(nbpel/2,1);-ones(nbpel/2,1)];
format                    =  '%d  %d  %d  %d    %d  %-1.4E \n';
fprintf(fid,format,info');

%--------------------------------------------------------------------------
% Control parameters 
%--------------------------------------------------------------------------
info                      =  [1000 10  0.01  10  1e-6  0  -1  1  5  node_ploting  1];
format                    =  '%d   %d   %g   %g   %d   %d  %d  %d  %d  %d  %d';
fprintf(fid,format,info');
fclose(fid);




    
    
    
    