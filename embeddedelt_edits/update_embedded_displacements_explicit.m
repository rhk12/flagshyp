 %--------------------------------------------------------------------------
%  Update coodinates of embedded element displacements.
%--------------------------------------------------------------------------

%Variables passed in from code
%GEOM.x = update_embedded_displacements_explicit(BC.tiedof, BC.tienodes,...
%                 FEM.mesh,GEOM); 
            
function x       = update_embedded_displacements_explicit(tiedof,...
                    tienodes,mesh,GEOM)
%|-/
%Enforce Embedded Element constraint

    %Use reference coordinates of host elt to establish embedded element
    %natural coordinates. The updated location is found using current nodal
    %coordinatess
    dim = GEOM.ndime;
    x0 = GEOM.x0;
    x = GEOM.x;
    Ze = GEOM.Embed_Zeta;
    TieXUpdate = zeros(mesh.n_dofs,1);
    h_elets = mesh.connectivity(:,mesh.host);

    %Loop through embedded nodes, m
    %Disp at a tie node is = displacment of that point in the host elet
    for i=1:length(tienodes)
        m=tienodes(i);

        %degrees of freedom corrispoinding to embedded node m
        mDof = (m-1)*dim+(1:dim);

        %Initial xyz coordinate of embedded node m
%         Xe0=x0(:,m);
   

        %Find the location of the embedded nodes in terms of the natural
        %coordinates of the host element
%         d1=digits(64);
%         Ze=find_natural_coords(Xe0, host_x0n, 'hex');
%         digits(d1);

        %Get the current coordinates of the host element
        host = GEOM.EmbedHost(i,2);        %host element number
        host_nn=mesh.connectivity(:,host); %nodes of host element
        host_xn = x(:,host_nn);            %nodal coordinates of host elet

        %Calculate shape function values at embedded node location
        XeUpdate=find_xyz_in_host(Ze(2:4,i), host_xn);

        %Fill TieUpdate with new xyz locations
        TieXUpdate((m-1)*dim+(1:dim));
        TieXUpdate((m-1)*dim+(1:dim)) = XeUpdate;
    end

    x(tiedof) = TieXUpdate(tiedof);
%|-/


end