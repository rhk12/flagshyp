%-------------------------------------------------------------------------- 
% Utility function for the assembly of element force vectors into the 
% global force vector.   
%-------------------------------------------------------------------------- 
function Force = force_vectors_assembly(elt_force,global_nodes,Force,dofs)
global explicit

global_dofs          = dofs(:,global_nodes);

if explicit == 0
    Force(global_dofs,1) = Force(global_dofs,1) + elt_force;
else
    Force(global_dofs,1) = elt_force;
end

end
 

