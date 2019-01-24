%-------------------------------------------------------------------------- 
% Utility function for the assembly of element force vectors into the 
% global force vector.   
%-------------------------------------------------------------------------- 
function Force = force_vectors_assembly(force,global_nodes,Force,dofs)
global_dofs          = dofs(:,global_nodes);
Force(global_dofs,1) = Force(global_dofs(:),1) + force;
end
 

