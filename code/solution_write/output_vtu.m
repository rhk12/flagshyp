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
    %system('rm out-*.vtk');
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




if (CON.incrm==0)
    %GLOBAL
    if GEOM.ndime == 2
        fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Reactions" NumberOfComponents="2" ComponentName0="x" ComponentName1="y" format="ascii">\n',...
            space,space,space,space);
        for i = 1:GEOM.npoin
            %     fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,GLOBAL.Reactions(2*i+0),GLOBAL.Reactions(2*i+1));
            fprintf(fid3,'%s%s%s%s%s%0.10e %0.10e\n',space,space,space,space,space,0.0, 0.0);
        end
    elseif GEOM.ndime == 3
        fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Reactions" NumberOfComponents="3" ComponentName0="x" ComponentName1="y" ComponentName2="z" format="ascii">\n',...
            space,space,space,space);
        for i = 1:GEOM.npoin
            % fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,GLOBAL.Reactions(3*i+0),GLOBAL.Reactions(3*i+1),GLOBAL.Reactions(3*i+2));
            fprintf(fid3,'%s%s%s%s%s%0.10e %0.10e %0.10e\n',space,space,space,space,space,0.0,0.0,0.0);
        end
    end
else
    %GLOBAL.Reactions
    aux(BC.fixdof)            =  GLOBAL.Reactions;
    %aux(BC.freedof)           =  GLOBAL.external_load(BC.freedof)
    %aux                       =  reshape(aux,GEOM.ndime,[])
    
    %aux(1,1)
    
    if GEOM.ndime == 2
        fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Reactions" NumberOfComponents="2" ComponentName0="x" ComponentName1="y" format="ascii">\n',...
                space,space,space,space);
        for i = 1:GEOM.npoin
       %     fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,GLOBAL.Reactions(2*i+0),GLOBAL.Reactions(2*i+1));
             fprintf(fid3,'%s%s%s%s%s%0.10e %0.10e\n',space,space,space,space,space,aux(1,i), aux(2,i));
        end
    elseif GEOM.ndime == 3
        fprintf(fid3,'%s%s%s%s<DataArray type="Float32" Name="Reactions" NumberOfComponents="3" ComponentName0="x" ComponentName1="y" ComponentName2="z" format="ascii">\n',...
                space,space,space,space);
        for i = 1:GEOM.npoin
           % fprintf(fid3,'%s%s%s%s%s%d\n',space,space,space,space,space,GLOBAL.Reactions(3*i+0),GLOBAL.Reactions(3*i+1),GLOBAL.Reactions(3*i+2));
             fprintf(fid3,'%s%s%s%s%s%0.10e %0.10e %0.10e\n',space,space,space,space,space,aux(1,i), aux(2,i), aux(3,i));
        end
    end
end
fprintf(fid3,'%s%s%s%s</DataArray>\n',space,space,space,space);

    
fprintf(fid3,'%s%s%s</PointData>\n',space,space,space);


plot_stresses(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

plot_Lagrangian_strain(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

plot_Eulerian_strain(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3)

plot_lnV(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS,fid3);




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





