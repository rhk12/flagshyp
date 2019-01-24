%--------------------------------------------------------------------------
% Compute the stiffness matrix pressure load vector. We compute 
% here a matrix form of the expressions:
% -For 2D problems:
%  0.5*k*(DN_etaa*Nb - Na*DN_etab).
% -For 3D problems:
%  0.5*(dx_chi*(DN_etaa*Nb-Na*DN_etab)-dx_eta*(DN_chia*Nb-Na*DN_chib). 
%--------------------------------------------------------------------------
function   T = pressure_load_stiffness_vector(xlocal_boundary,dim,N,...
                                              DN_Chi,anode,bnode)
switch dim
    case 2
         DN_eta = DN_Chi;
         k      = [0;0;1];
         scalar = DN_eta(:,anode)*N(bnode) - N(anode)*DN_eta(:,bnode);    
         %-----------------------------------------------------------------
         % Obtain final expression for load vector T.         
         %-----------------------------------------------------------------
         T = 0.5*k*scalar;   
    case 3
         DN_chi = DN_Chi(1,:);
         DN_eta = DN_Chi(2,:);
         dx_chi = xlocal_boundary*DN_chi';         
         dx_eta = xlocal_boundary*DN_eta';         
         %-----------------------------------------------------------------
         % Obtain final expression for load vector T.         
         %-----------------------------------------------------------------
         T = dx_chi*N(anode)*DN_eta(bnode) - dx_eta*N(anode)*DN_chi(:,bnode);
end