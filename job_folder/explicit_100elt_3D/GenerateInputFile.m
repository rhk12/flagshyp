
% Code to generate an input file for FlagShyp
clear all, close all 
% Load Data files with 2 variables 
% coordindates= array Nnodes by 4 for a 3D model = [nodeid,x,y,z]
% Connectivity= array Nelt by 9 for hexa8 elements= [eltid,node1,...,node8 ]
load('BarData.mat')
Nnodes=size(coordinates,1); 
Nelt=size(Connectivity,1);

% Find the nodes at the back face at z=0
backfaceid=find(coordinates(:,3)==0); 
% Find the nodes on the the opposite face ie at max z, which is pushed 
pushedface=find(coordinates(:,3)==max(coordinates(:,3)));

% Recall BC codes in FLagSHyp 
% 0: free
% 1: x prescribed 
% 2: y prescribed
% 3: x,y prescribed
% 4: z prescribed
% 5: x,z prescribed
% 6: y,z prescribed
% 7: x,y,z prescribed

% Prescribed BCs in z
bcs=zeros(Nnodes,1); 
% The back face is fixed
bcs(backfaceid)=7*ones(length(backfaceid),1); 
% The other face is pushed in z
bcs(pushedface)=4*ones(length(pushedface),1); 

% the corner at x=y=z=0 is also fixed 
botedge=find(coordinates(backfaceid,2)==0); 
corner=backfaceid(botedge(find(coordinates(backfaceid(botedge),1)==0)));
disp(strcat('Corner node ID: ', num2str(corner)));
disp(strcat('Coordinates at corner:', num2str(coordinates(corner,:)))); 
bcs(corner)=7; 

% Create a corner: the side face (located at x=0)  is prescribed with x=0
sideface=find(coordinates(:,1)==0); 
bcs(sideface)=1*ones(length(sideface),1); 
% Bottom face (y=0) is prescribed with y=0 
botface=find(coordinates(:,2)==0);
bcs(botface)=2*ones(length(botface),1);
% Make sure that the long edge relating the bottom face and side face has
% consistent BCS: prescribed in x and y
longsideedge=find(coordinates(sideface,1)==0);
bcs(longsideedge)=3*ones(length(longsideedge),1); 

% Side edge of the face that is pulled is constrained with x=0 + pulled in
% z direction
sideedge_pushedface=pushedface(find(coordinates(pushedface,1)==0))
bcs(sideedge_pushedface)=5*ones(length(sideedge_pushedface),1);
botedge_pushedface=pushedface(find(coordinates(pushedface,2)==0))
bcs(sideedge_pushedface)=5*ones(length(sideedge_pushedface),1);

% Change variable name to be consistent with output_vtu.m file 
NodeInput=[(1:Nnodes)',bcs,coordinates]; 
PRO.title='BarElongation'; 
CON.incrm=0; %This is just to look at the mesh and bcs
CON.xlamb=0;% 
GEOM.npoin=Nnodes; 
FEM.mesh.nelem=Nelt;
GEOM.ndime=3; 
FEM.mesh.n_dofs=GEOM.ndime*GEOM.npoin; 
GEOM.x0=coordinates'; 
GEOM.x=GEOM.x0; %No deformation for now
FEM.mesh.n_nodes_elem=8; 
FEM.mesh.connectivity=Connectivity(:,2:end)'; 
MAT.matno=ones(Nelt,1);
FEM.mesh.element_type='hexa8';
BC.icode=bcs;

%% Create the input file
filename='explicit_dyn_bartest.dat'; 
fid1=fopen(filename,'w'); 
fprintf(fid1,'3D BarElongation\n'); % Problem title 
fprintf(fid1,strcat(FEM.mesh.element_type,'\n')); % Type of elements
% Number of nodes
fprintf(fid1,'%d\n',Nnodes); 
% Print node id, bc code and node coordinates
for inode=1:Nnodes
    fprintf(fid1,'%d %d %1.3f %1.3f %1.3f\n',inode,bcs(inode),round(coordinates(inode,1),3),round(coordinates(inode,2),3),round(coordinates(inode,3),3)) ;
end
% Number of elements
fprintf(fid1,'%d\n',Nelt); 
% Connectivity and material id
nmat=1; idmat=1; 
for ielt=1:Nelt
    fprintf(fid1,'%d %d %d %d %d %d %d %d %d %d\n',ielt,idmat,Connectivity(ielt,2),....
Connectivity(ielt,3),Connectivity(ielt,4),Connectivity(ielt,5),Connectivity(ielt,6),...
Connectivity(ielt,7),Connectivity(ielt,8),Connectivity(ielt,9));
end
fprintf(fid1,'%d\n',nmat); 
mat_type=1; % 3D neo hookean compressible
% Properties required are density, shear modulus and lambda Lame
% coefficients 
% Use value of E, rho and nu from Abaqus model
E=200e9; Poisson=0.3;
mu=E/(2*(1+Poisson)); 
lambda=E*Poisson/((1+Poisson)*(1-2*Poisson)); 
props(idmat,1)=7800.0; % Density
props(idmat,2)=mu; % Shear modulus mu
props(idmat,3)=lambda; % Lame coeff
fprintf(fid1,'%d %d %1.4e %1.4e %1.4e\n',idmat, mat_type, props(idmat,1),props(idmat,2),props(idmat,3));
% Use notation of FLagSHup manual 
%  Number of loads
n_point_loads=0; 
%Number of nonzeros prescribed displacements
n_prescribed_displacements=length(pushedface); 
dir=3*ones(n_prescribed_displacements,1); 
dispmagn=-0.1; 
nincrm=10; 
n_pressure_loads=0; 
ndime=3; 
gravt=[0.;0.;0.];
fprintf(fid1,'%d %d %d %1.1f %1.1f %1.1f\n', n_point_loads, n_prescribed_displacements,...
n_pressure_loads,gravt(1),gravt(2),gravt(3));

for i=1:length(pushedface)
fprintf(fid1,'%d %d %1.4f\n',pushedface(i),dir(i),dispmagn/nincrm);
end
%Max value of load scaling parameter
xlmax=20.0;
% Load parameter increment
dlamb=1.0;
miter=25; %Max number of interations per increment
cnorm=1e-6; % Convergence tolerance
searc=0.0; % Line search paramter : not in use
arcln=0.0; % Arc length parameter : not in use
incout=1; %Output at every load increment
itarget=1; % Target iterations per incremet 
nwant=3; %Single output node
iwant=2; % Output dof
fprintf(fid1,'%d %2.1f %2.1f %d %.1e %2.1f %2.1f %d %d %d %d\n',...
nincrm,xlmax,dlamb,miter,cnorm,searc,arcln,incout,itarget,nwant,iwant);
fclose(fid1); 
% End of input file 

% Generate geometry with boundary conditions readable in paraview: adapted
% from output_vtu.m 
string2=sprintf('Geometry-%d.vtu',0);
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
% Print boundary codes, coordinates
%--------------------------------------------------------------------------
% extract undeformed coordinates
info_undeformed                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
info_undeformed(:,1)                 =  (1:GEOM.npoin)';
info_undeformed(:,2)                 =  BC.icode;
aux2                       =  zeros(FEM.mesh.n_dofs,1);
aux2                       =  reshape(aux2,GEOM.ndime,[]);
info_undeformed(:,3:end)             =  [GEOM.x0'  aux2'];


fprintf(fid3,'%s%s%s<Points>\n',space,space,space);
fprintf(fid3,'%s%s%s%s<DataArray type="Float32" NumberOfComponents="3" format="ascii">\n',...
    space,space,space,space);

for i = 1:GEOM.npoin
    if GEOM.ndime == 2
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
        info_undeformed(i,3),info_undeformed(i,4),0.0);
    elseif GEOM.ndime == 3
        fprintf(fid3,'%s%s%s%s%s%.10e %.10e %.10e\n',space,space,space,space,space,...
        info_undeformed(i,3),info_undeformed(i,4),info_undeformed(i,5));
    end
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);
fprintf(fid3,'%s%s%s</Points>\n',space,space,space);
%--------------------------------------------------------------------------
% Print material type and connectivities.
%--------------------------------------------------------------------------

info                      =  zeros(FEM.mesh.nelem,2+FEM.mesh.n_nodes_elem);
info(:,1)                 =  (1:FEM.mesh.nelem)';
info(:,2)                 =  MAT.matno;
info(:,3:end)             =  FEM.mesh.connectivity';

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
fprintf(fid3,'%s%s%s<PointData>\n',space,space,space);


fprintf(fid3,'%s%s%s%s<DataArray type="Int32" Name="Boundary" NumberOfComponents="1" ComponentName0="BC_Value" format="ascii">\n',...
    space,space,space,space);
for i = 1:GEOM.npoin
    fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,info_undeformed(i,2));
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);

    
fprintf(fid3,'%s%s%s</PointData>\n',space,space,space);

fprintf(fid3,'%s%s</Piece>\n',space,space);
fprintf(fid3,'%s</UnstructuredGrid>\n',space);
fprintf(fid3,'</VTKFile>\n');


fclose(fid3);
