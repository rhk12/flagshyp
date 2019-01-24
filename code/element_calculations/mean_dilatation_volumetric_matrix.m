%--------------------------------------------------------------------------
% Compute conttribution (and extract relevant information for subsequent
% assembly) of the mean dilatation term (Kk) of the stiffness matrix.
%--------------------------------------------------------------------------
function [element_indexi,element_indexj,element_stiffness,counter] = ...
          mean_dilatation_volumetric_matrix(FEM,dim,element_connectivity,...
          DN_x_mean,counter,element_indexi,element_indexj,...
          element_stiffness,kappa_bar,ve)   
for bnode=1:FEM.mesh.n_nodes_elem
    for anode=1:FEM.mesh.n_nodes_elem
        DN_x_meana_DN_x_meanb = DN_x_mean(:,anode)*DN_x_mean(:,bnode)';
        indexi = FEM.mesh.dof_nodes(:,element_connectivity(anode));
        indexi = repmat(indexi,1,dim);
        indexj = FEM.mesh.dof_nodes(:,element_connectivity(bnode));
        indexj = repmat(indexj,1,dim);
        indexj = indexj';
        % Index for row identification.        
        element_indexi(counter:counter+dim^2-1) = indexi;
        % Index for column identification.        
        element_indexj(counter:counter+dim^2-1) = indexj;
       % Mean dilatation stiffness matrix contribution.        
        element_stiffness(counter:counter+dim^2-1) = kappa_bar*ve*...
                                                  DN_x_meana_DN_x_meanb(:);
        counter = counter + dim^2;
    end
end
