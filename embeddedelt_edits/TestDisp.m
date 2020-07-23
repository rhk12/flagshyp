%Test find_natural_coordinates
clear;clc;close all;
set(0,'defaultfigurecolor',[1 1 1]);

% % Xembed=[0 0 0;1 0 0 ;0 1 0;1 1 0;0 0 1;1 0 1 ;0 1 1;1 1 1;0 0 0.4; 1 0 0.4; 0 1 0.4; 1 1 0.4; 0 0 0.6; 1 0 0.6; 0 1 0.6; 1 1 0.6];
% % Xnodes=[0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 1 1]';
% % Xee=[0 0 0.4 1 0 0.4 0 1 0.4 1 1 0.4 0 0 0.6 1 0 0.6 0 1 0.6 1 1 0.6]';
% 
% % Xnodes=[0,1,0,1,0,1,0,1;0,0,1,1,0,0,1,1;0,0,0,0,1,1,1,1];
% Xnodes=[1,1,0,0,1,1,0,0;0,1,1,0,0,1,1,0;0,0,0,0,1,1,1,1];
% Xee=[1,1,0,0,1,1,0,0;0,1,1,0,0,1,1,0;0.40,0.40,0.40,0.40,0.60,0.60,0.60,0.60];
% 
% 
% F=[1 0 0; 0 1 0; 0 0 1];
% % F=[2 0 1.6; 0 4 0; 1.6 0 1.5];
% % F=[1.3 -.375 .1; 0.75 0.65 0.1; 0.1 0.2 1];
% % F=[1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1];
% 
% xn = zeros(3,8);
% xe = zeros(3,8);
% for i=1:8
%    xn(:,i) = F*Xnodes(:,i); 
%    xe(:,i) = F*Xee(:,i);
% end
% 
% xe=xn*0.5+0.001*ones(3,8);
% 
% z=zeros(3,8);
% d1=digits(64);
% figure(); hold on; view(3); grid on;
% for j=1:8
%     a=xe(:,j);
%     z=find_natural_coords(a, xn, 'hex');
%     z(:,j)=z;
%     X=find_xyz_in_host(z(:,j),xn);
%     a;  
%     easycheck = a-X;
%     fprintf("xi = [%d %d %d]\n", a(1), a(2), a(3));
%     fprintf("zi = [%d %d %d]\n", z(1), z(2), z(3));
%     fprintf("xi = [%d %d %d]\n", X(1), X(2), X(3));
% end
% digits(d1);
% 
% result=zeros(7,8);
% result(1:3,:)=xe;
% result(5:7,:)=z;
% 
% 
% xn2 = [9.8754E-01  1.0400E+00  9.8754E-01;9.8754E-01  0.0000E+00  9.8754E-01;9.8754E-01  1.0400E+00  0.0000E+00;9.8754E-01  0.0000E+00  0.0000E+00;0.0000E+00  1.0400E+00  9.8754E-01;0.0000E+00  0.0000E+00  9.8754E-01;0.0000E+00  1.0400E+00  0.0000E+00;0.0000E+00  0.0000E+00  0.0000E+00]';
% u=zeros(3,8);
% for j=1:8
% 
%    u(:,j)=find_xyz_in_host(z(:,j), xn2); 
% end

%%

a = [1 0.1 0.5]; 
x = [1,1,0,0,1,1,0,0;0,1,1,0,0,1,1,0;0,0,0,0,1,1,1,1];
% x = [-0.004831175 ,-0.002505181 ,7.6e-13,-0.004327131 ,-0.004831175 ,-0.002505181 ,7.6 00000e-13,-0.004327131 ;0.001288313 ,0.004327131 ,-1.31 0000e-12,-0.002505181 ,0.001288313 ,0.004327131 ,-1.31 0000e-12,-0.002505181 ;0.01 ,0.01 ,0.01 ,0.01 ,0.005 ,0.005 ,0.005 ,0.005 ];
% x(:,6)=[1.3;1.3;1.3];
% x(:,5)=[1.1;0.1;1.4];
% x(:,4)=[0.3;0.1;0.2];
npts = 10;

%For testing
        F=[1 0 0; 0 1 0; 0 0 1];
        F=[2 0 0.6; 0 4 0; 0.6 0 1.5];
%         F=[1.2 0 0.6; 0 1.1 0; 0.6 0 3];
%         F=[2 -.1 -0.6; -.0 .5 0; -0.6 0 1.7]*2;
%         x=x-2;

        xn = zeros(3,8);
        for i=1:8
           xn(:,i) = F*x(:,i); 
        end
        x=xn;
 

z=zeros(3,npts);
xe=zeros(3,npts);
check=zeros(3,npts);
d1=digits(64);
figure(); hold on; view(3); grid on;
for j=1:npts
    xi1 = min(xn(1,:)) + (max(xn(1,:))-min(xn(1,:)))*rand;
    xi2 = min(xn(2,:)) + (max(xn(2,:))-min(xn(2,:)))*rand;
    xi3 = min(xn(3,:)) + (max(xn(3,:))-min(xn(3,:)))*rand;
    a = [xi1 xi2 xi3]';
    xe(:,j)=a;
    
    inel = point_in_hexahedron(a',xn);
    
    if inel
        zz=find_natural_coords(a, xn, 'hex')
        z(:,j)=zz;
        X=find_xyz_in_host(z(:,j),xn);
        a;  
        check(:,j) = a-X;
    
        if abs(check(1))>1E-10 || abs(check(2))>1E-10 || abs(check(3)) >1E-10
            fprintf("fail %u\n",j);
        end
    fprintf("xi = [%d %d %d]\n", a(1), a(2), a(3));
    fprintf("zi = [%d %d %d]\n", zz(1), zz(2), zz(3));
    fprintf("xi = [%d %d %d]\n", X(1), X(2), X(3));    
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


        colors = ['r.' 'b.' 'k.' 'g.' 'm.' 'c.' 'r.' 'b.' 'k.' 'g.' 'm.' 'c.'];

        patch(X,Y,Z,'black','FaceAlpha', 0.2);
        patch(XX,YY,ZZ,'black','FaceAlpha', 0.2);
        plot3(a(1),a(2),a(3), 'r.');
        xlabel('x'); ylabel('y'); zlabel('z');
    
    end
    
    
end
digits(d1);

result=zeros(11,npts);
result(1:3,:)=xe;
result(5:7,:)=z;
result(9:11,:)=check;
