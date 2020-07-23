%Plot Stress
% close all; clear; clc;
G=76.92e9; lam=115.4e9;


fid =fopen('explicit_embedded3D-OUTPUT.txt', 'r');

numsteps = 3696;
% numsteps= 738;
stress=zeros(numsteps, 6);
formspec = [repmat('%f ',1,6)];

for j=1:numsteps    
    for i = 1:13
        tline=fgetl(fid);
    end 
    tline=fgetl(fid);
    stress(j,:)=fscanf(fid, formspec, [1,6]);
    for i = 1:11
        tline=fgetl(fid);
    end
end
fclose(fid);


% fid=fopen('AVD_Check.txt','r');
% 
% time=zeros(739,1);
% for j=1:739
%     tline=fgetl(fid);
%     fscanf(fid, '%f');
%     timeline=fgetl(fid);
%     time(j)=t;
%     for i = 1:35
%         tline=fgetl(fid);
%     end
% end
% fclose(fid);

% fid=fopen('AVD_Check.txt','r');
% 
% node2x = zeros(numsteps,1);
% node3y = zeros(numsteps,1);
% disp=zeros(numsteps,24);
% GEOMx=zeros(numsteps,24);
% tline=fgetl(fid);
% for j=1:numsteps
%     
%     tline=fgetl(fid);
%     tline=fgetl(fid);
%     dat=fscanf(fid, '%f');
%     disp(j,:)=dat';
%     node2x(j)=disp(j,4);
%     node3y(j)=disp(j,8);
%     
%     tline=fgetl(fid);
%     dat2=fscanf(fid, '%f');
%     GEOMx(j,:)=dat2';
% 
% end
% fclose(fid);


figure();
hold on; grid on;
plot([1:numsteps], stress(:,1));
xlim([1 740]);
ylim([-1E7 1E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S11 Output: Flagshyp");

figure();
hold on; grid on;
plot([1:4:numsteps], stress(1:4:numsteps,1));
xlim([1 740]);
ylim([-1E7 1E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S11 Output: Flagshyp");

figure();
hold on; grid on;
plot([1:numsteps], stress(:,4));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S22 Output: Flagshyp");


figure();
hold on; grid on;
plot([1:numsteps], stress(:,6));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S33 Output: Flagshyp");


figure();
hold on; grid on;
plot([1:numsteps], stress(:,5));
% xlim([1 740]);
% ylim([-8E5 8E5]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S23 Output: Flagshyp");


% figure();
% hold on; grid on;
% plot([1:numsteps], node2x);
% % xlim([1 740]);
% xlabel("Step Number");
% ylabel("Displacment");
% title("X dispalcement of Node 2: Flagshyp");
% 
% figure();
% hold on; grid on;
% plot(GEOMx(:,8)-1, node2x);
% % xlim([1 740]);
% xlabel("Applied Y Displacment");
% ylabel("X Displacment");
% title("X Dispalcement of Node 2 vs Applied Displacment: Flagshyp");


%% Stress calculated at half step

clear; clc; close all;
fid=fopen('Stress1.txt','r');

numsteps= 737;
F = zeros(3,3,numsteps);
b = zeros(3,3,numsteps);
Cauchy = zeros(3,3,numsteps);
tline=fgetl(fid);
tline=fgetl(fid);
j=1;
while tline ~= -1
    
    F(:,:,j) = fscanf(fid,'%f ',[3,3]);
    tline=fgetl(fid);
    b(:,:,j) = fscanf(fid,'%f ',[3,3]);
    tline=fgetl(fid);
    tline=fgetl(fid);
    tline=fgetl(fid);
    Cauchy(:,:,j) = fscanf(fid,'%f ',[3,3]);
    tline=fgetl(fid);
    j=j+1;
end
fclose(fid);

Cauchy11=zeros(size(Cauchy,3), 1);
for i=1:size(Cauchy,3)
   Cauchy11(i)=Cauchy(1,1,i); 
    
end

figure();
hold on; grid on;
plot([1:size(Cauchy,3)], Cauchy11);
% xlim([1 740]);
% ylim([-4.5E7 4.5E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S11 Output: Flagshyp");
aveC11=mean(Cauchy11)

s=size(Cauchy,3);
correctF=false(s,3);
signC=false(s,3);

for i=1:s
       if F(1,1,i)<=1
          correctF(i,1)=true; 
       else
           fprintf("F %u \n",i);
       end
        if F(2,2,i)>=1
        correctF(i,2)=true; 
           else
           fprintf("F %u \n",i);
        end
        if F(3,3,i)<=1
        correctF(i,3)=true;
           else
           fprintf("F %u \n",i);
        end

       if Cauchy(1,1,i)<=0
          signC(i,1)=true; 
             else
           fprintf("C %u \n",i);
       end
        if Cauchy(2,2,i)>=0
        signC(i,2)=true; 
           else
           fprintf("C %u \n",i);
        end
        if Cauchy(3,3,i)<=0
        signC(i,3)=true; 
           else
           fprintf("C %u \n",i);
       end
       
end

G=76.92e9; lam=115.4e9;
EE=G*(3*lam+2*G)/(lam+G);
nu=lam/(2*(lam+G));
K=lam+2*G/3;
rho=7800;
J^(-5/3)*mu*(b-(1/3)*I1*cons.I) + K*(J-1)*cons.I
%% idk this is like gradient calculations and stuff
% fid=fopen('DefGrad.txt','r');
% formspec = [repmat('%f ',1,3)];
% F=zeros(3,3,739);
% for i=1:739
%     F(:,:,i)=fscanf(fid,formspec,[3,3]);
% end
% 
% %Calculate Stress based on exact F
% Cauchy_exact=zeros(3,3,739);
% for i=1:739
%     J=det(F(:,:,i));
%     b=F(:,:,i)*F(:,:,i)';
% 
%     Cauchy_exact(:,:,i) = (G/J)*(b - eye(3)) + (lam/J)*log(J)*eye(3);
% end
% S11_e=permute(Cauchy_exact(1,1,:), [3 2 1]);
% 
% %Round machine zero F values to zero
% F_round=F;
% for i=1:739
%     for j=1:3
%         for k=1:3
%             if abs(F(j,k,i))<1E-16
%                 F_round(j,k,i)=0;
%             end
%         end
%     end
% end
% 
% %Calculate Stress based on rounded F
% Cauchy_round=zeros(3,3,739);
% for i=1:739
%     J=det(F_round(:,:,i));
%     b=F_round(:,:,i)*F_round(:,:,i)';
% 
%     Cauchy_round(:,:,i) = (G/J)*(b - eye(3)) + (lam/J)*log(J)*eye(3);
% end
% S11_r=permute(Cauchy_round(1,1,:), [3 2 1]);
% 
% figure;
% hold on;
% plot(time, S11_e);
% plot(time, S11_r);
% xlabel("Time");
% hold off;
% ylabel("Stress");