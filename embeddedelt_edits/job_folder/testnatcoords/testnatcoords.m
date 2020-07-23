clear; clc; close all;
set(0,'defaultfigurecolor',[1 1 1]);

load('e_elets.mat'); load('h_elets.mat'); load('GEOM.mat');

e_nodes = e_elets(:);
Zeta = zeros(4,16);
xx = zeros(3,10);
i = [2 6 9 13 ]+[0 0 0.0001]';
xfail7 = [-0.0013	-0.0023	-0.0011	-0.0025	-0.0017	-0.0011	-0.001 ...
    -0.0018; 0.0019	0.0005	0.0003	0.0007	0.0004	0.0008	0.0005	0.0027; ...
0.0093	0.0091	0.0091	0.0089	0.0082	0.0082	0.0092	0.01];

xfail1 = [   -0.0028   -0.0029    0.0033]'; 


figure(); hold on; view(3); grid on;
 for i = 1:1
%     xi = GEOM.x0(:,e_nodes(i)) 
%     j=GEOM.EmbedHost(i,2);

    j=7;
    xn = GEOM.x0(:,h_elets(:,j));
%     xn(3,:)=xn(3,:)*0.5;

    xi1 = min(xn(1,:)) + (max(xn(1,:))-min(xn(1,:)))*rand;
    xi2 = min(xn(2,:)) + (max(xn(2,:))-min(xn(2,:)))*rand;
    xi3 = min(xn(3,:)) + (max(xn(3,:))-min(xn(3,:)))*rand;
    xi = [xi1 xi2 xi3]';

    xi = xfail7(:,i);
%     xi(3,:)=xi(3,:)*0.5;


    inel = point_in_hexahedron(xi',xn);
  
    if inel
        %Find the natural coordinates of the node
        Zeta(1,i) = e_nodes(i); 
        Z = find_natural_coords(xi, xn, 'hex')
        Zeta(2:4,i) = Z;



        %Plot stuff
        faces = zeros(3,3,12);
        faces(:,:,1) = [xn(:,4) xn(:,3) xn(:,2)];
        faces(:,:,2) = [xn(:,2) xn(:,1) xn(:,4)];
        faces(:,:,3) = [xn(:,1) xn(:,2) xn(:,6)];
        faces(:,:,4) = [xn(:,6) xn(:,5) xn(:,1)];
        faces(:,:,5) = [xn(:,2) xn(:,3) xn(:,7)];
        faces(:,:,6) = [xn(:,7) xn(:,6) xn(:,2)];
        faces(:,:,7) = [xn(:,3) xn(:,4) xn(:,8)];
        faces(:,:,8) = [xn(:,8) xn(:,7) xn(:,3)];
        faces(:,:,9) = [xn(:,1) xn(:,5) xn(:,8)];
        faces(:,:,10) = [xn(:,8) xn(:,4) xn(:,1)];
        faces(:,:,11) = [xn(:,5) xn(:,6) xn(:,7)];
        faces(:,:,12) = [xn(:,7) xn(:,8) xn(:,5)];


        X=[faces(1,:,1);faces(1,:,2);faces(1,:,3);faces(1,:,4);faces(1,:,5);faces(1,:,6)]'; 
        Y=[faces(2,:,1);faces(2,:,2);faces(2,:,3);faces(2,:,4);faces(2,:,5);faces(2,:,6)]';
        Z=[faces(3,:,1);faces(3,:,2);faces(3,:,3);faces(3,:,4);faces(3,:,5);faces(3,:,6)]';

        XX=[faces(1,:,7);faces(1,:,8);faces(1,:,9);faces(1,:,10);faces(1,:,11);faces(1,:,12)]'; 
        YY=[faces(2,:,7);faces(2,:,8);faces(2,:,9);faces(2,:,10);faces(2,:,11);faces(2,:,12)]';
        ZZ=[faces(3,:,7);faces(3,:,8);faces(3,:,9);faces(3,:,10);faces(3,:,11);faces(3,:,12)]';


        colors = ['r' 'b' 'k' 'g' 'm' 'c' 'r' 'b' 'k' 'g' 'm' 'c'];

        patch(X,Y,Z,'black','FaceAlpha', 0.2);
        patch(XX,YY,ZZ,'black','FaceAlpha', 0.2);
        plot3(xi(1),xi(2),xi(3), 'r.');
        xlabel('x'); ylabel('y'); zlabel('z');
    end

 end


%%