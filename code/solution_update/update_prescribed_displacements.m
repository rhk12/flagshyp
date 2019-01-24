%--------------------------------------------------------------------------
%  Update coodinates of displacement (Dirichlet) boundary conditions.
%--------------------------------------------------------------------------
function x       = update_prescribed_displacements(dofprescribed,x0,x,...
                   xlamb,presc_displacement)
Dirichlet_dof    = dofprescribed;  
x(Dirichlet_dof) = x0(Dirichlet_dof) + xlamb*presc_displacement(Dirichlet_dof);


