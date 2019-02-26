%--------------------------------------------------------------------------
% Compute contribution (and extract relevant information for subsequent
% assembly) of the constitutive term of the stiffness matrix.
%--------------------------------------------------------------------------
function [element_indexi,element_indexj,element_stiffness,counter] = ...
          constitutive_matrix(FEM,dim,element_connectivity,...
          kinematics_gauss,c,JW,counter,element_indexi,element_indexj,...
          element_stiffness)
for bnode=1:FEM.mesh.n_nodes_elem
    for anode=1:FEM.mesh.n_nodes_elem
        for j=1:dim
            % Index for column identification.
            indexj = FEM.mesh.dof_nodes(j,element_connectivity(bnode));   
            for i=1:dim
                % Index for row identification.
                indexi = FEM.mesh.dof_nodes(i,element_connectivity(anode));   
                sum    =  0;
                for k=1:dim
                    for l=1:dim
                        % Constitutive stiffness matrix contribution.
                        sum = sum + kinematics_gauss.DN_x(k,anode)*...
                              c(i,k,j,l)*kinematics_gauss.DN_x(l,bnode)*JW;
                    end
                end
                %----------------------------------------------------------
                % Store indices for subsequent sparse assembly.
                %----------------------------------------------------------
                element_indexi(counter)    = indexi;
                element_indexj(counter)    = indexj;
                element_stiffness(counter) = sum;
                counter                    = counter + 1;
            end
        end
    end
end