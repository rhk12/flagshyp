
% Read Flagshyp file
file=fopen('nonlinear_solid_truss_elastic_2D-results.txt','r');
formatSpec = '%e %e %e';
sizeA = [3 inf ];
A = fscanf(file,formatSpec,sizeA);
fclose(file);

% Read abaqus file
% file2=fopen('../abaqus3D/abaqus.rpt','r');
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% line_ex = fgetl(file2);
% formatSpec = '%e %e %e';
% sizeB = [3 inf ];
% B = fscanf(file2,formatSpec,sizeB);
% fclose(file2);

plot(A(2,:),A(3,:),'DisplayName','Flagshyp2','LineWidth',4)
hold on

%plot(A(1,:),B(2,:),'*','DisplayName','Flagshyp3','LineWidth',4)


legend('show')
%xlabel('Nominal Strain (lnV)')
%ylabel('Cauchy Stress (Pa)')