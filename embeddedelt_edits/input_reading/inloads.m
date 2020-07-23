%--------------------------------------------------------------------------
% Read nodal point loads, prescribed displacements, surface pressure loads
% and gravity (details in textbook).
%--------------------------------------------------------------------------
function [LOAD,BC,FEM,GLOBAL] = inloads(GEOM,FEM,BC,fid)
n_point_loads                 = fscanf(fid,'%d',1);             
BC.n_prescribed_displacements = fscanf(fid,'%d',1);             
LOAD.n_pressure_loads         = fscanf(fid,'%d',1);             
LOAD.gravt                    = fscanf(fid,'%g',GEOM.ndime);    
%--------------------------------------------------------------------------
% Initialisation.
%--------------------------------------------------------------------------
BC.presc_displacement         = zeros(FEM.mesh.n_dofs,1);
LOAD.pressure                 = zeros(LOAD.n_pressure_loads, 1);  
GLOBAL.nominal_external_load  = zeros(FEM.mesh.n_dofs,1);
%--------------------------------------------------------------------------
% Read point loads.
%--------------------------------------------------------------------------
format                        = ['%d ' repmat('%g ',1,GEOM.ndime)];
info                          = (fscanf(fid,format,[1+GEOM.ndime,n_point_loads]))';
nodes                         = info(:,1);
global_dofs                   = reshape(FEM.mesh.dof_nodes(:,nodes),[],1);
force_value                   = (info(:,2:end))';
GLOBAL.nominal_external_load(global_dofs,1) = force_value(:);
%--------------------------------------------------------------------------
% Read non-zero prescribed displacements.
%--------------------------------------------------------------------------
format                        = '%d %d %g';
info                          = (fscanf(fid,format,[3,BC.n_prescribed_displacements]))';
nodes                         = info(:,1);
local_dof                     = info(:,2);
global_dof                    = (GEOM.ndime*(nodes - 1) + local_dof);
prescribed_value              = info(:,3);
BC.presc_displacement(global_dof,1) = prescribed_value;
BC.dofprescribed              = global_dof;          
%--------------------------------------------------------------------------
% Read pressure boundary elements. 
%--------------------------------------------------------------------------
format = ['%d ' repmat('%d ',1,FEM.mesh.n_face_nodes_elem) '%g'];
info = (fscanf(fid,format,[2+FEM.mesh.n_face_nodes_elem,LOAD.n_pressure_loads]))';
LOAD.pressure_element         = info(:,1);         
FEM.mesh.connectivity_faces   = info(:,2:end-1)';  
LOAD.pressure                 = info(:,end);
end
 

