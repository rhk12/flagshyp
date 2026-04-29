
% Read Flagshyp file
file=fopen('Ex4-2-results.txt','r');
%            step F11 F12 F21   F22 
formatSpec = '%d  %e  %e   %e   %e';
sizeA = [5 inf ];
A = fscanf(file,formatSpec,sizeA);
fclose(file);

% % Read abaqus file
% file2=fopen('../abaqus3D/abaqus.rpt','r');
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% formatSpec = '%e %e %e';
% sizeB = [3 inf ];
% B = fscanf(file2,formatSpec,sizeB);
% fclose(file2);

plot(A(1,:),A(2,:),'-o','DisplayName','Flagshyp - F11','LineWidth',4)
hold on
plot(A(1,:),A(3,:),'-o','DisplayName','Flagshyp - F12','LineWidth',4)

plot(A(1,:),A(4,:),'-s','MarkerSize',10,'MarkerEdgeColor','black','DisplayName','Flagshyp - F21','LineWidth',1)

plot(A(1,:),A(5,:),'-o','DisplayName','Flagshyp - F22','LineWidth',4)

legend('show')
xlabel('Step')
ylabel('Deformation Gradient')

%plot(B(2,:),B(3,:),'*','DisplayName','Abaqus','LineWidth',4)

