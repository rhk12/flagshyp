%--------------------------------------------------------------------------
% Compute conttribution (and extract relevant information for subsequent
% assembly) of the geometric term of the stiffness matrix.
%--------------------------------------------------------------------------
function [element_indexi,element_indexj,element_stiffness,counter] = ...
          geometric_matrix(FEM,dim,element_connectivity,DN_sigma_DN,JW,...
          counter,element_indexi,element_indexj,element_stiffness)
for bnode=1:FEM.mesh.n_nodes_elem
    for anode=1:FEM.mesh.n_nodes_elem
        % Geometric stiffness matrix contribution.
        DNa_sigma_DNb  = DN_sigma_DN(anode,bnode);
        % Index for row identification.        
        element_indexi(counter:...
        counter+dim-1) = FEM.mesh.dof_nodes(:,element_connectivity(anode));
        % Index for column identification.       
        element_indexj(counter:...
        counter+dim-1) = FEM.mesh.dof_nodes(:,element_connectivity(bnode));
        element_stiffness(counter:...
        counter+dim-1) = DNa_sigma_DNb*JW;
        counter        = counter + dim;
    end
end
