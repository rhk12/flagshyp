%--------------------------------------------------------------------------
% Check for equilibrium convergence.
%--------------------------------------------------------------------------
function [rnorm,GLOBAL] = check_energy_explicit(PRO,FEM,CON,BC,GLOBAL,...
       disp_n, disp_prev,fi_n,fi_prev,time)

global Wint_n;

string='a';
%PRO.rest
%CON.incrm

if (~PRO.rest && CON.incrm==1)
    string='w';
    system('rm energy.dat');
    Wint_n = 0.0;
end

string3=sprintf('energy.dat');

fid5= fopen(string3,string);

%internal work
sum = (disp_n - disp_prev)' * (fi_n + fi_prev);
Wint_n = Wint_n + 0.5 * sum;

% kinetic energy
WKE = 0;
for i=1:FEM.mesh.n_dofs
    WKE = WKE + GLOBAL.M(i,i) *( GLOBAL.velocities(i) * GLOBAL.velocities(i));
end
WKE = WKE * 0.5;


%--------------------------------------------------------------------------
% Print energy information.
%--------------------------------------------------------------------------
fprintf(fid5,'%5.5e %5.5e  %5.5e \n',time, WKE, Wint_n);

fclose(fid5);

