%--------------------------------------------------------------------------
% TXT file save of converged solution every CON.OUTPUT.incout increments.
% - Coordinates, element connectivity and stress.
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
function output_vtk(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------
string='w';
% if (~PRO.rest && CON.incrm==1)
%    string='w';
% end


string2=sprintf('out-%d.vtk',CON.incrm);
fid3= fopen(string2,string);
%--------------------------------------------------------------------------
% Print title, load increment number and load factor.
%--------------------------------------------------------------------------
space = '       ';
output_title = [PRO.title space 'at increment:' space  ...
               num2str(CON.incrm) ', ' space 'load:  ' num2str(CON.xlamb)];

fprintf(fid3,'# vtk DataFile Version 3.0\n');
%fprintf(fid3,'Title\n');
fprintf(fid3,'%c',output_title);
fprintf(fid3,'\n');
fprintf(fid3,'ASCII\n');
fprintf(fid3,'DATASET UNSTRUCTURED_GRID\n');
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
fprintf(fid3,'POINTS %d FLOAT\n',GEOM.npoin);
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

for i = 1:GEOM.npoin
    fprintf(fid3,'%.10e %.10e %.10e\n',info3(i,3),info3(i,4),0.0);
end

%--------------------------------------------------------------------------
% Print material type and connectivities.
%--------------------------------------------------------------------------
% fprintf(fid,'%d',FEM.mesh.nelem);
fprintf(fid3,'CELLS %d %d\n',FEM.mesh.nelem,FEM.mesh.nelem*(4+1) );

% fprintf(fid,'\n');
info                      =  zeros(FEM.mesh.nelem,2+FEM.mesh.n_nodes_elem);
info(:,1)                 =  (1:FEM.mesh.nelem)';
info(:,2)                 =  MAT.matno;
info(:,3:end)             =  FEM.mesh.connectivity';
% format                    =  ['%d %d ' repmat('%d ',1,FEM.mesh.n_nodes_elem) '\n'];
% fprintf(fid,format,info');
for i = 1:FEM.mesh.nelem
    fprintf(fid3,'%d %d %d %d %d\n',4, info(i,3)-1,info(i,4)-1,...
        info(i,5)-1,info(i,6)-1 );
end
fprintf(fid3,'CELL_TYPES %d\n',FEM.mesh.nelem);
for i = 1:FEM.mesh.nelem
    fprintf(fid3,'%d\n',9);  % element type
end

%--------------------------------------------------------------------------
% Print Point/Node Data
%--------------------------------------------------------------------------

% dispacements
fprintf(fid3,'POINT_DATA %d\n',GEOM.npoin);
fprintf(fid3,'VECTORS DISP FLOAT\n');
for i = 1:GEOM.npoin
    fprintf(fid3,'%.10e %.10e %.10e\n',info3(i,3)-info2(i,3),info3(i,4)-info2(i,4),0.0);
end

% velocities

% accelerations



%--------------------------------------------------------------------------
% Print stresses.
%--------------------------------------------------------------------------
fprintf(fid3,'CELL_DATA %d\n',FEM.mesh.nelem );
fprintf(fid3,'TENSORS STRESS FLOAT\n');

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
%     format = [repmat('% -1.4E ',1,size(Stress,1)) '\n'];
%     fprintf(fid,format',Stress);

    % Stress(1,1) % xx stress
    % Stress(2,2) % xy stress
    % Stress(3,3) % yy stress
    fprintf(fid3,'%.10e %.10e %.10e\n',  Stress(1,1),Stress(2,2), 0.0);
    fprintf(fid3,'%.10e %.10e %.10e\n',  Stress(2,2),Stress(3,3), 0.0);
    fprintf(fid3,'%.10e %.10e %.10e\n\n',0.0        ,0.0,         0.0);

end 
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
fclose(fid3);
% if (~isempty (CON.OUTPUT.nwant) && CON.OUTPUT.nwant~=0)
%    fclose(fid_flagout);
% end





