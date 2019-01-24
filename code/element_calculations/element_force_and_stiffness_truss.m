%--------------------------------------------------------------------------
% Computes the element vector of global internal forces and the tangent
% stiffness matrix (3D truss).
%--------------------------------------------------------------------------
function [T_internal,indexi,indexj,global_stiffness,counter,PLAST,Cauchy] = ...
          element_force_and_stiffness_truss(properties,x_local,X_local,...
          element_connectivity,FEM,PLAST,counter,indexi,indexj,...
          global_stiffness,GEOM)
area  = properties(4);  
E     = properties(2);  
ty0   = properties(5);  
H     = properties(6);  
ep    = PLAST.ep;    
epbar = PLAST.epbar; 
%--------------------------------------------------------------------------
% Temporary variables.
%--------------------------------------------------------------------------
L       = norm(X_local(:,2) - X_local(:,1));  
dx      = x_local(:,2) - x_local(:,1);        
l       = norm(dx);                           
n       = dx/l;                               
V       = area*L;                             
lambda  = l/L;                                
epsilon = log(lambda);
%--------------------------------------------------------------------------
% Return mapping algorithm for trusses.
% - Trial stage.
%--------------------------------------------------------------------------
epsilon_trial = epsilon - ep;
tau_trial     = E*epsilon_trial;
%--------------------------------------------------------------------------
% - Check yield criterion.
%--------------------------------------------------------------------------
f = abs(tau_trial) - (ty0+H*epbar);  
%--------------------------------------------------------------------------
% - Return mapping algorithm.
%--------------------------------------------------------------------------
if f>0
   Dgamma          = f/(E + H); 
   E_computational = E*H/(E + H); 
else
   Dgamma          = 0;         
   E_computational = E;   
end
Dep                = Dgamma*sign(tau_trial);  
tau                = tau_trial - E*Dep;       
ep                 = ep + Dep;                 
epbar              = epbar + Dgamma;          
%--------------------------------------------------------------------------
% Computation of the internal force vector.
%--------------------------------------------------------------------------
T          = tau*V/l;                  
Tb         = T*n;                         
T_internal = [-Tb;Tb];  
%--------------------------------------------------------------------------
% Computation of the stiffness matrix.
%--------------------------------------------------------------------------
k          = (V/l^2)*(E_computational - 2*tau);          
Kbb        = k*(n*n') + (T/l)*eye(3);            
K_internal = [[Kbb -Kbb];[-Kbb  Kbb]];           
%--------------------------------------------------------------------------
% Sparse assembly of the stiffness matrix.
%--------------------------------------------------------------------------
element_indexi               = reshape(FEM.mesh.dof_nodes(:,element_connectivity),[],1);
element_indexi               = repmat(element_indexi,1,6);
element_indexj               = element_indexi';
n_dofs_elem                  = (FEM.mesh.n_nodes_elem*GEOM.ndime)^2;
aux_vector                   = counter:counter+n_dofs_elem-1;
indexi(aux_vector)           = element_indexi(:);
indexj(aux_vector)           = element_indexj(:);
global_stiffness(aux_vector) = K_internal(:);
%--------------------------------------------------------------------------
% Global index for sparse assembly.
%--------------------------------------------------------------------------
counter = counter + n_dofs_elem;
%--------------------------------------------------------------------------
% Storage of plastic variables.
%--------------------------------------------------------------------------
PLAST.ep    = ep;
PLAST.epbar = epbar;
%--------------------------------------------------------------------------
% Storage of stress for postprocessing purposes.
%--------------------------------------------------------------------------
J      = lambda^(1-2*properties(3));
Cauchy = tau/J;
end