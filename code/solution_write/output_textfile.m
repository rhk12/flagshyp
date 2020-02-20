%--------------------------------------------------------------------------
function output_(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------

%output nodes according to job name. 
if ( PRO.resultsfile_name == "nonlinear_solid_truss-results.txt" )
    n1=2; % this is top node where we extract information on disp
    n1dof = 3;   
    %node 4 is reacton force node depending on if it is zero or 1. 
    n2 = 4;
    n2dof = 3;
else
    n1=1;
    n1dof =1;
    n2 = 1;
    n2dof = 1;
end

string='a';

if (~PRO.rest && CON.incrm==1)
    string='w';
    system('rm results.dat');
end

%string2=sprintf('results.dat');
string2=PRO.resultsfile_name;
fid4= fopen(string2,string);


% %--------------------------------------------------------------------------
% % Print boundary codes, coordinates, reactions and external loads.
% %--------------------------------------------------------------------------
% % extract undeformed coordinates
 info2                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
 info2(:,1)                 =  (1:GEOM.npoin)';
 info2(:,2)                 =  BC.icode;
 aux2                       =  zeros(FEM.mesh.n_dofs,1);
 aux2                       =  reshape(aux2,GEOM.ndime,[]);
 info2(:,3:end)             =  [GEOM.x0'  aux2'];
% 
% % extract deformed coordinates
 info3                      =  zeros(GEOM.npoin,2 + 2*GEOM.ndime);
 info3(:,1)                 =  (1:GEOM.npoin)';
 info3(:,2)                 =  BC.icode;
 aux                       =  zeros(FEM.mesh.n_dofs,1);
% % aux(BC.fixdof)            =  GLOBAL.Reactions;
% % aux(BC.freedof)           =  GLOBAL.external_load(BC.freedof);
 aux                       =  reshape(aux,GEOM.ndime,[]);
 info3(:,3:end)             =  [GEOM.x'  aux'];

aux(BC.fixdof)            =  GLOBAL.Reactions;
%format long
%aux

outdisp = info3(n1,n1dof);
%-info2(n1,n1dof);
xl = info2(n1,1)-info2(1,1);
zl = info2(n1,3)-info2(1,3);
len0 = sqrt(xl^2 + zl^2);
len = sqrt((info3(n1,1)-info2(1,1))^2 + (info3(n1,3)-info2(1,3))^2);


if (~PRO.rest && CON.incrm==1)
    %fprintf(fid4,'%d %.10e %.10e\n',0,1,0);
else
    fprintf(fid4,'%d %.10e %.10e\n',CON.incrm,(info3(n1,n1dof)-info2(n1,n1dof))/len0,aux(n2dof,n2));
end


fclose(fid4);






