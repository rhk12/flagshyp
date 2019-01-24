%----------------------------------------------------------------------
% Obtain fixed and free degree of freedom numbers (dofs).
%----------------------------------------------------------------------
function BC = find_fixed_free_dofs(GEOM,FEM,BC)
%--------------------------------------------------------------------------
% Based on the boundary codes (BC.icode), determine the (free) degrees 
% of freedom (freedof) and the fixed degress of freedom (fixdof).
%--------------------------------------------------------------------------
dim = GEOM.ndime;
BC.freedof = (1:FEM.mesh.n_dofs)';
BC.fixdof = zeros(FEM.mesh.n_dofs,1);                          
for inode=1:GEOM.npoin
    BC.fixdof((inode-1)*dim+(1:dim)) = boundary_codes(BC.icode(inode),dim);
end
BC.fixdof = BC.fixdof.*BC.freedof;
BC.fixdof = BC.fixdof(BC.fixdof>0);
BC.freedof(BC.fixdof) = [];
end




