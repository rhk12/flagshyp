function XX = find_xyz_in_host(Z, xx)
%Returns xyz coordinates corisponding to natural coordinates Z in element
%with node coordinates x

    chi = Z(1); eta = Z(2); iota = Z(3);

%     x=[0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 1 1]';
%Reorder a 3x8 matrix to be a mess of a column matrix
x = [xx(:,1)' xx(:,2)' xx(:,3)' xx(:,4)' xx(:,5)' xx(:,6)' xx(:,7)' xx(:,8)']';
        x1=x(1); y1=x(2); z1=x(3); x2=x(4); y2=x(5); z2=x(6); x3=x(7); y3=x(8); 
        z3=x(9); x4=x(10); y4=x(11); z4=x(12); x5=x(13); y5=x(14); z5=x(15);
        x6=x(16); y6=x(17); z6=x(18); x7=x(19); y7=x(20); z7=x(21); x8=x(22);
        y8=x(23); z8=x(24);


     N1 = -((chi - 1)*(eta - 1)*(iota - 1))/ 8;
     N2 = ((chi + 1)*(eta - 1)*(iota - 1))/ 8;
     N3 = ((chi - 1)*(eta + 1)*(iota - 1))/ 8;
     N4 = -((chi + 1)*(eta + 1)*(iota - 1))/ 8;
     N5 = ((chi - 1)*(eta - 1)*(iota + 1))/ 8;
     N6 = -((chi + 1)*(eta - 1)*(iota + 1))/ 8;
     N8 = -((chi - 1)*(eta + 1)*(iota + 1))/8;
     N7 = ((chi + 1)*(eta + 1)*(iota + 1))/8;
     NN = [N1, 0, 0, N2, 0, 0, N3, 0, 0, N4, 0, 0, N5, 0, 0, N6, 0, 0, N7, ...
         0, 0, N8, 0, 0;  0, N1, 0, 0, N2, 0, 0, N3, 0, 0, N4, 0, 0, N5, ...
        0, 0, N6, 0, 0, N7, 0, 0, N8, 0;  0, 0, N1, 0, 0, N2, 0, 0, N3, ...
        0, 0, N4, 0, 0, N5, 0, 0, N6, 0, 0, N7, 0, 0, N8];

    XX=NN*x;
    
    %Round machine zero results to actual zero
    for j=1:length(XX)
        if abs(XX(j)) < 1E-12
            XX(j)=0;
        end
    end
end