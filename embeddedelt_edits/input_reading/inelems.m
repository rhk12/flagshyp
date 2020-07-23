%--------------------------------------------------------------------------
% Read the number of elements, element connectivity and material number.
%--------------------------------------------------------------------------
function [FEM,MAT] = inelems(FEM,fid)
FEM.mesh.nelem = fscanf(fid,'%d',1);  
format = ['%d %d %d' repmat('%g ',1,FEM.mesh.nelem)];
info = (fscanf(fid,format,[3+FEM.mesh.n_nodes_elem,FEM.mesh.nelem]))';
elements = info(:,1);
MAT.matno = info(elements,2);
FEM.mesh.connectivity = info(elements,4:end)';

%|-/
FEM.mesh.embedcode = info(elements,3);
FEM.mesh.host = elements(FEM.mesh.embedcode==0);
FEM.mesh.embedded = elements(FEM.mesh.embedcode==1);
%
end



