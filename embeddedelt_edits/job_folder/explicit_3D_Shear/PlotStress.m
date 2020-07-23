%Plot Stress
close all;
G=76.92e9; lam=115.4e9;


fid =fopen('explicit_3D-OUTPUT.txt', 'r');

stress=zeros(205, 6);
formspec = [repmat('%f ',1,6)];

for j=1:205    
    for i = 1:13
        tline=fgetl(fid);
    end
    tline=fgetl(fid);
    stress(j,:)=fscanf(fid, formspec, [1,6]);
    for i = 1:11
        tline=fgetl(fid);
    end
end
fclose(fid);%time(j)=


fid=fopen('AVD_Check.txt','r');

time=zeros(739,1);
for j=1:739
    tline=fgetl(fid);
    fscanf(fid, '%f');
    timeline=fgetl(fid);
    t=str2double(timeline(23:30));
    time(j)=t;
    for i = 1:35
        tline=fgetl(fid);
    end
end
fclose(fid);

stress=stress(2:end,:);

figure();
hold on; grid on;
plot([1:204], stress(:,1));
xlim([1 205]);
ylim([-4.5E7 4.5E7]);
xlabel("Step Number");
ylabel("Stress (Pa)");
title("S11 Output: Flagshyp");

fid=fopen('DefGrad.txt','r');
formspec = [repmat('%f ',1,3)];
F=zeros(3,3,739);
for i=1:739
    F(:,:,i)=fscanf(fid,formspec,[3,3]);
end

%Calculate Stress based on exact F
Cauchy_exact=zeros(3,3,739);
for i=1:739
    J=det(F(:,:,i));
    b=F(:,:,i)*F(:,:,i)';

    Cauchy_exact(:,:,i) = (G/J)*(b - eye(3)) + (lam/J)*log(J)*eye(3);
end
S11_e=permute(Cauchy_exact(1,1,:), [3 2 1]);

%Round machine zero F values to zero
F_round=F;
for i=1:739
    for j=1:3
        for k=1:3
            if abs(F(j,k,i))<1E-16
                F_round(j,k,i)=0;
            end
        end
    end
end

%Calculate Stress based on rounded F
Cauchy_round=zeros(3,3,739);
for i=1:739
    J=det(F_round(:,:,i));
    b=F_round(:,:,i)*F_round(:,:,i)';

    Cauchy_round(:,:,i) = (G/J)*(b - eye(3)) + (lam/J)*log(J)*eye(3);
end
S11_r=permute(Cauchy_round(1,1,:), [3 2 1]);

figure;
hold on;
plot(time, S11_e);
plot(time, S11_r);
xlabel("Time");
hold off;
ylabel("Stress");