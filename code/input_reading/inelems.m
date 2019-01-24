%--------------------------------------------------------------------------
% Read the number of elements, element connectivity and material number.
%--------------------------------------------------------------------------
function [FEM,MAT] = inelems(FEM,fid)
FEM.mesh.nelem = fscanf(fid,'%d',1);  
format = ['%d %d ' repmat('%g ',1,FEM.mesh.nelem)];
info = (fscanf(fid,format,[2+FEM.mesh.n_nodes_elem,FEM.mesh.nelem]))';
elements = info(:,1);
MAT.matno = info(elements,2);
FEM.mesh.connectivity = info(elements,3:end)';
end



