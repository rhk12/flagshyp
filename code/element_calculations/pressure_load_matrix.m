%--------------------------------------------------------------------------
% Compute boundary (UNIT pressure load) stiffness matrix contribution.
%--------------------------------------------------------------------------
function [element_indexi,element_indexj,element_stiffness,counter] = ...
          pressure_load_matrix(FEM,element_connectivity,xlocal_boundary,...
          dim,N,DN_chi,W,counter,element_indexi,element_indexj,element_stiffness)
for bnode=1:FEM.mesh.n_face_nodes_elem
    for anode=1:FEM.mesh.n_face_nodes_elem
        kpab             = pressure_load_stiffness_vector(xlocal_boundary,...
                           dim,N,DN_chi,anode,bnode);  
        Levi_civita_Kpab = Levi_civita_contraction_vector(kpab,dim);
        %------------------------------------------------------------------
        % Compute and store indices for subsequent sparse assembly.
        %------------------------------------------------------------------
        indexi = FEM.mesh.dof_nodes(:,element_connectivity(anode));
        indexi = repmat(indexi,1,dim);
        indexj = FEM.mesh.dof_nodes(:,element_connectivity(bnode));
        indexj = repmat(indexj,1,dim);
        indexj = indexj';        
        element_indexi(counter:counter+dim^2-1)    = indexi;
        element_indexj(counter:counter+dim^2-1)    = indexj;
        element_stiffness(counter:counter+dim^2-1) = Levi_civita_Kpab(:)*W;
        counter = counter + dim^2;
    end
end
            
            

    
    