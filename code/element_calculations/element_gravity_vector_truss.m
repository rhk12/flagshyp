%--------------------------------------------------------------------------    
% Compute element force gravity vector for truss elements.
%--------------------------------------------------------------------------    
function gravity_vector = element_gravity_vector_truss(xlocal,rho0_vector,properties)                                          
density = properties(1);
Area    = properties(4);  
L       = norm(xlocal(:,2) - xlocal(:,1));
V       = Area*L;                         
gravity_vector = 0.5*[rho0_vector;rho0_vector]*density*V;

                                                 