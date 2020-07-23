
chi = [-1:0.1:1]'; eta = [-1:0.1:1]; iota = [-1:0.1:1]'*[-1:0.1:1];
chi=chi*5; eta=eta*5; iota=iota*5;

     N1 = -((chi - 1)*(eta - 1).*(iota - 1))/ 8;
     N2 = ((chi + 1)*(eta - 1).*(iota - 1))/ 8;
     N3 = ((chi - 1)*(eta + 1).*(iota - 1))/ 8;
     N4 = -((chi + 1)*(eta + 1).*(iota - 1))/ 8;
     N5 = ((chi - 1)*(eta - 1).*(iota + 1))/ 8;
     N6 = -((chi + 1)*(eta - 1).*(iota + 1))/ 8;
     N8 = -((chi - 1)*(eta + 1).*(iota + 1))/8;
     N7 = ((chi + 1)*(eta + 1).*(iota + 1))/8;

    NN=zeros(21,21,8);
    NN(:,:,1)=N1;
    NN(:,:,2)=N2;
    NN(:,:,3)=N3;
    NN(:,:,4)=N4;
    NN(:,:,5)=N5;
    NN(:,:,6)=N6;
    NN(:,:,7)=N7;
    NN(:,:,8)=N8;

    
    
x=[1,1,-1,-1,1,1,-1,-1;-1,1,1,-1,-1,1,1,-1;-1,-1,-1,-1,1,1,1,1];

faces = zeros(3,4,6);
faces(:,:,1) = [x(:,4) x(:,3) x(:,2) x(:,1)];
faces(:,:,2) = [x(:,1) x(:,2) x(:,6) x(:,5)];
faces(:,:,3) = [x(:,2) x(:,3) x(:,7) x(:,6)];
faces(:,:,4) = [x(:,3) x(:,4) x(:,8) x(:,7)];
faces(:,:,5) = [x(:,1) x(:,5) x(:,8) x(:,4)];
faces(:,:,6) = [x(:,5) x(:,6) x(:,7) x(:,8)];

    xx=[faces(1,:,1);faces(1,:,2);faces(1,:,3);faces(1,:,4);faces(1,:,5);faces(1,:,6)]'; 
    yy=[faces(2,:,1);faces(2,:,2);faces(2,:,3);faces(2,:,4);faces(2,:,5);faces(2,:,6)]';
    zz=[faces(3,:,1);faces(3,:,2);faces(3,:,3);faces(3,:,4);faces(3,:,5);faces(3,:,6)]';

%  
%     figure(); hold on; view(3); grid on;
%     patch(xx,yy,zz,'black','FaceAlpha', 0.1);
%     surf(chi, eta, N1);
%     xlabel("chi"); ylabel("eta"); zlabel("iota");
%     hold off;
    
    
 leg =["N1" "N2" "N3" "N4" "N5" "N6" "N7" "N8"];   
 for i=1:8
    figure(); hold on; view(3); grid on;
    patch(xx,yy,zz,'black','FaceAlpha', 0.1);
    surf(chi, eta, iota, NN(:,:,i));
    xlabel("chi"); ylabel("eta"); zlabel("iota");
    title(leg(i));
    hold off; 
        
 end