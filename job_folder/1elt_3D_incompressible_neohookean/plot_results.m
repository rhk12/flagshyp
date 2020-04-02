
% Read Flagshyp file
file=fopen('1elt_3D_incompressible_neohookean-results.dat','r');
formatSpec = '%d %e %e';
sizeA = [3 inf ];
A = fscanf(file,formatSpec,sizeA);
fclose(file);

% Read abaqus file
file2=fopen('../abaqus3D/abaqus.rpt','r');
line_ex = fgetl(file2);
line_ex = fgetl(file2);
line_ex = fgetl(file2);
line_ex = fgetl(file2);
formatSpec = '%e %e %e';
sizeB = [3 inf ];
B = fscanf(file2,formatSpec,sizeB);
fclose(file2);

plot(A(2,:),A(3,:),'DisplayName','Flagshyp','LineWidth',4)
hold on

plot(B(2,:),B(3,:),'*','DisplayName','Abaqus','LineWidth',4)


legend('show')
xlabel('Nominal Strain (lnV)')
ylabel('Cauchy Stress (Pa)')