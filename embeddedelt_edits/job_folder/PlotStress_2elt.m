%Plot Stress
% close all; clear; clc;
G=76.92e9; lam=115.4e9;
basedir='C:/Users/Valerie/Documents/GitHub/flagshyp/embeddedelt_edits/job_folder/explicit_embedded3D/';
set(0,'defaultfigurecolor',[1 1 1]);
file = ['explicit_embeddedShear-OUTPUT.txt'];

fid = fopen(file, 'r');

numsteps = 3669;
% numsteps= 738;
stress_elt1=zeros(numsteps, 6);
stress_elt2=zeros(numsteps, 6);
formspec = [repmat('%f ',1,6)];

for j=1:numsteps
    for i = 1:24
        tline=fgetl(fid);
    end 
    tline=fgetl(fid);
    stress_elt1(j,:)=fscanf(fid, formspec, [1,6]);
    stress_elt1(j,:);
    for i=1:7
        tline=fgetl(fid);
    end
    stress_elt2(j,:)=fscanf(fid, formspec, [1,6]);
    stress_elt2(j,:);
    for i = 1:9
        tline=fgetl(fid);
    end
end
fclose(fid);

graphsize=[100 100 800 400];


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,1));
xlim([1 740]);
ylim([-1E7 1E7]);
% xlabel("Step Number");
% ylabel("Stress (Pa)");
title("Host S11 Output: Flagshyp");

figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:4:numsteps], stress_elt1(1:4:numsteps,1));
% xlim([1 740]);
% ylim([-1E7 1E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Host S11 Output: Flagshyp");

figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,4));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Host S22 Output: Flagshyp");


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,6));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Host S33 Output: Flagshyp");


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,5));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Host S23 Output: Flagshyp");


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,1));
xlim([1 740]);
ylim([-1E7 1E7]);
% xlabel("Step Number");
% ylabel("Stress (Pa)");
title("Embedded S11 Output: Flagshyp");

figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:4:numsteps], stress_elt1(1:4:numsteps,1));
% xlim([1 740]);
% ylim([-1E7 1E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Embedded S11 Output: Flagshyp");

figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,4));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Embedded S22 Output: Flagshyp");


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,6));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Embedded S33 Output: Flagshyp");


figure();
hold on; grid on;
fig=gcf; fig.Position=graphsize;
plot([1:numsteps], stress_elt1(:,5));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("Embedded S23 Output: Flagshyp");
