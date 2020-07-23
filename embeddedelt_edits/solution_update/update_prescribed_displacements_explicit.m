%--------------------------------------------------------------------------
%  Update coodinates of displacement (Dirichlet) boundary conditions.
%--------------------------------------------------------------------------

%Variables passed in from code
%GEOM.x = update_prescribed_displacements_explicit(BC.dofprescribed,...
%                 BC.tiedof, BC.tienodes,elementtype,dim ...
            %   FEM.mesh,GEOM.x0,GEOM.x,CON.xlamb,BC.presc_displacement,t_n,tMax); 
            
function x       = update_prescribed_displacements_explicit(dofprescribed,...
                   tiedof, tienodes,eltype,dim,mesh,x0,x,...
                   xlamb,presc_displacement,time_n, total_time)

Dirichlet_dof    = dofprescribed;

AppliedDisp = presc_displacement(Dirichlet_dof);

ramp = time_n * (AppliedDisp / total_time);
presc_displacement(Dirichlet_dof);

% %|-/
% %Enforce Embedded Element constraint
% 
%     %Eventually need to update this to find the correct host element for each
%     %embedded node. Right now it's hardcoded to just take the element defined
%     %by the first 8 nodes in the mesh
% 
%     %Use reference coordinates of host elt to establish embedded element
%     %natural coordinates. The updated location is found using current nodal
%     %coordinates
%     TieXUpdate = zeros(mesh.n_dofs,1);
%     host_x0n = x0(:,1:8);
%     host_xn = x(:,1:8);
% %     host_xn
%     %Loop through embedded nodes, m
%     %Disp at a tie node is = displacment of that point in the host elet
%     for i=1:length(tienodes)
%         m=tienodes(i);
% %         fprintf("m %i\n",m);
%         %degrees of freedom corrispoinding to embedded node m
%         mDof = (m-1)*dim+(1:dim);
% 
%         %Current xyz coordinate of embedded node m
%         Xe0=x0(:,m);
%     %     Xe=x(:,m)
% 
%         %Find the location of the embedded nodes in terms of the natural
%         %coordinates of the host element
%         d1=digits(64);
%         Ze=find_natural_coords(Xe0, host_x0n, 'hex');
%         digits(d1);
%         
%         %Calculate shape function values at embedded node location
%         XeUpdate=find_xyz_in_host(Ze, host_xn);
% 
%         %Fill TieUpdate with new xyz locations
%         TieXUpdate((m-1)*dim+(1:dim));
%         TieXUpdate((m-1)*dim+(1:dim)) = XeUpdate;
%     end
% 
%     x(tiedof) = TieXUpdate(tiedof);
%|-/

x(Dirichlet_dof) = x0(Dirichlet_dof) + ramp;

end