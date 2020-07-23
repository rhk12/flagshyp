
function GEOM = nodes_in_host(GEOM,FEM,tienodes)

%Identify the host element of each embedded node

e_elets = tienodes;
e_nodes = e_elets(:);
h_elets = FEM.mesh.connectivity(:,FEM.mesh.host);

n_nodes = length(e_nodes);
n_elt = length(FEM.mesh.host);

%Loop throgh embedded nodes
 %  Find the elements who's centroids are closest to the current point
 %  Check if the point is in any of those 
 %      if inside one, set IN(point) = true; continue to next point
 %      if it's not in any of those, assume it is not in the part at all,
 

 %Calculate the centroid of every element and find max element length le
 centroids = zeros(n_elt,3);
 le = 0;
 for ielement=1:n_elt
     %Get the coordinates of the element nodes
     xn = GEOM.x0(:,h_elets(:,ielement));
     centroids(ielement,:) = [mean(xn(1,:)) mean(xn(2,:)) mean(xn(3,:))];
 
     %Calculate characteristic element length
     [l,lei] = calc_element_size(FEM,GEOM,ielement);
     if lei>le
         le=lei;
     end
     
 end


 EmbedHost=zeros(n_nodes,2);
 Zeta = zeros(4,n_nodes);
 
 for i = 1:n_nodes
 i
  xi = GEOM.x0(:,e_nodes(i));
    
     for j=1:n_elt
         d=sqrt((xi(1)-centroids(j,1))^2 + (xi(2)-centroids(j,2))^2 + (xi(3)-centroids(j,3))^2);

         if d <= 0.8*le
            xn = GEOM.x0(:,h_elets(:,j));
            inel = point_in_hexahedron(xi',xn);
            if inel == true
                EmbedHost(i,1) = e_nodes(i);
                EmbedHost(i,2) = FEM.mesh.host(j);
                
                %Find the natural coordinates of the node
                Zeta(1,i) = e_nodes(i); 
                Zeta(2:4,i) = find_natural_coords(xi, xn, FEM.mesh.element_type);
                
                break;
            end
         end
     end
 end
 
 GEOM.EmbedHost = EmbedHost;
 GEOM.Embed_Zeta = Zeta;
end