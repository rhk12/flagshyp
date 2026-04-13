%--------------------------------------------------------------------------
% Computes and assembles the lumped mass matrix using Row-Sum Lumping.
%--------------------------------------------------------------------------
function [GLOBAL, updated_PLAST] = mass_assembly(xlamb,...
          GEOM, MAT, FEM, GLOBAL, CONSTANT, QUADRATURE, PLAST, KINEMATICS)   
      
% 1. Initialization
ndims = GEOM.ndime; 
npoin = GEOM.npoin;
massSize = ndims * npoin;

% Initialize global mass matrix as a sparse matrix for efficiency
AssembledMass = sparse(massSize, massSize);
updated_PLAST = PLAST;
    
% 2. Main element loop to compute Consistent Mass Matrix
for ielement = 1:FEM.mesh.nelem
    % Gather element variables
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    material_number = MAT.matno(ielement);     
    properties      = MAT.props(:,material_number); 
    x0local         = GEOM.x0(:,global_nodes); 
    
    % Interpolation data
    N = FEM.interpolation.element.N;
    DN_chi = FEM.interpolation.element.DN_chi;
    
    % Density is typically the first material property
    rho = properties(1);
    
    % Determine element size: nodes per element (nshp)
    nshp = length(global_nodes);
    
    % Initialize element consistent mass matrix (Me) and interpolator (Nm)
    Me = zeros(nshp * ndims, nshp * ndims);
    Nm = zeros(ndims, nshp * ndims);

    % Loop over quadrature points
    for igauss = 1:QUADRATURE.ngauss
        % Build the Nm matrix for the current Gauss point
        Nm(:) = 0;
        for n = 1:nshp
            idx = (n-1)*ndims;             
            for d = 1:ndims
                Nm(d, idx + d) = N(n, igauss);
            end
        end
        
        % Compute Jacobian and its determinant with respect to initial geometry
        DX_chi = x0local * DN_chi(:,:,igauss)';
        detJ   = abs(det(DX_chi));
        
        % Prefactor for integration: Weight * Volume * Density
        prefactor = QUADRATURE.W(igauss) * detJ * rho;
    
        % Compute consistent mass matrix contribution: Integral( rho * N^T * N )
        Me = Me + prefactor * (Nm' * Nm);
    end
    
    % 3. Assemble element mass into global matrix
    % Map element nodes to global degrees of freedom
    dofs = zeros(nshp * ndims, 1);
    for n = 1:nshp
        for d = 1:ndims
            dofs((n-1)*ndims + d) = (global_nodes(n)-1)*ndims + d;
        end
    end
    
    AssembledMass(dofs, dofs) = AssembledMass(dofs, dofs) + Me;
end

%--------------------------------------------------------------------------
% 4. Perform Row-Sum Lumping
%--------------------------------------------------------------------------
% The lumped mass at index i is the sum of all elements in row i.
% This ensures conservation of total mass.
diag_vector = full(sum(AssembledMass, 2));

% Store the result as a sparse diagonal matrix in GLOBAL.M
GLOBAL.M = sparse(1:massSize, 1:massSize, diag_vector, massSize, massSize);

end
