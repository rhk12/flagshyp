%--------------------------------------------------------------------------
% TXT file save of converged solution every CON.OUTPUT.incout increments.
% - Coordinates, element connectivity and stress.
% - For node CON.OUTPUT.nwant and dof CON.OUTPUT.iwant output displacement
%   and corresponding force (file name '...FLAGOUT.TXT').
%--------------------------------------------------------------------------
function output(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------
string='a';
if (~PRO.rest && CON.incrm==1)
   string='w';
end
%--------------------------------------------------------------------------
% Open file for single node output.
%--------------------------------------------------------------------------
if (~isempty (CON.OUTPUT.nwant) && CON.OUTPUT.nwant~=0)
   fid_flagout = fopen(PRO.outputfile_name_flagout,string);
end
%--------------------------------------------------------------------------
% Open file for output.
%--------------------------------------------------------------------------
fid = fopen(PRO.outputfile_name,string);
%--------------------------------------------------------------------------
% Print title, load increment number and load factor.
%--------------------------------------------------------------------------
space = '       ';
output_title = [PRO.title space 'at increment:' space  ...
               num2str(CON.incrm) ', ' space 'load:  ' num2str(CON.xlamb)];
fprintf(fid,'%c',output_title);
fprintf(fid,'\n');
%--------------------------------------------------------------------------
% Print element type. 
%--------------------------------------------------------------------------
fprintf(fid,'%c',FEM.mesh.element_type);
fprintf(fid,'\n');
%--------------------------------------------------------------------------
% Print number of nodes.
%--------------------------------------------------------------------------
fprintf(fid,'%d',GEOM.npoin);
fprintf(fid,'\n');
%--------------------------------------------------------------------------
% Print boundary codes, coordinates, reactions and external loads.
%--------------------------------------------------------------------------
info                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
info(:,1)                 =  (1:GEOM.npoin)';
info(:,2)                 =  BC.icode;
aux                       =  zeros(FEM.mesh.n_dofs,1);
aux(BC.fixdof)            =  GLOBAL.Reactions;
aux(BC.freedof)           =  GLOBAL.external_load(BC.freedof);
aux                       =  reshape(aux,GEOM.ndime,[]);
info(:,3:end)             =  [GEOM.x'  aux'];
format                    =  ['%d %d ' repmat('% -1.4E ',1,2*GEOM.ndime) '\n'];
fprintf(fid,format,info');
%--------------------------------------------------------------------------
% Print material type and connectivities.
%--------------------------------------------------------------------------
fprintf(fid,'%d',FEM.mesh.nelem);
fprintf(fid,'\n');
info                      =  zeros(FEM.mesh.nelem,2+FEM.mesh.n_nodes_elem);
info(:,1)                 =  (1:FEM.mesh.nelem)';
info(:,2)                 =  MAT.matno;
info(:,3:end)             =  FEM.mesh.connectivity';
format                    =  ['%d %d ' repmat('%d ',1,FEM.mesh.n_nodes_elem) '\n'];
fprintf(fid,format,info');
%--------------------------------------------------------------------------
% Print stresses.
%--------------------------------------------------------------------------
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
    format = [repmat('% -1.4E ',1,size(Stress,1)) '\n'];
    fprintf(fid,format',Stress);
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
    format     = [repmat('% -1.4E ',1,5) '\n'];
    fprintf(fid_flagout,format,[increment,coordinate,Force,xlamb,radius]);
end
fprintf(fid,['\n' repmat('-',1,length(output_title))]);
fprintf(fid,['\n' repmat('-',1,length(output_title)) '\n\n']);
fclose(fid);
if (~isempty (CON.OUTPUT.nwant) && CON.OUTPUT.nwant~=0)
   fclose(fid_flagout);
end





