
% Read Flagshyp file
file=fopen('growthv1-results.txt','r');
%            step F11 F12 F21 F22 
formatSpec = '%d  %e %e %e %e';
sizeA = [5 inf ];
A = fscanf(file,formatSpec,sizeA);
fclose(file);


plot(A(1,:),A(2,:),'DisplayName','Flagshyp - F11','LineWidth',4)
hold on
plot(A(1,:),A(3,:),'DisplayName','Flagshyp - F12','LineWidth',4)
plot(A(1,:),A(4,:),'DisplayName','Flagshyp - F21','LineWidth',4)
plot(A(1,:),A(5,:),'DisplayName','Flagshyp - F22','LineWidth',4)

legend('show')
xlabel('Step')
ylabel('Deformation Gradient')

%plot(B(2,:),B(3,:),'*','DisplayName','Abaqus','LineWidth',4)

