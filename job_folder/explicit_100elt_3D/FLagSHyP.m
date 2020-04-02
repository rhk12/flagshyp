%--------------------------------------------------------------------------
% Nonlinear Finite Element Solid Mechanics program "FLagSHyP"
% Version MATLAB1 January 2016y
%--------------------------------------------------------------------------
% Full details are contained in the textbook 
% "Nonlinear Solid Mechanics for Finite Element Analysis --Statics"
% by J. Bonet, A. J. Gil and R. D. Wood
% Cambridge University Press 2016
% ISBN:
%--------------------------------------------------------------------------
% The authors would like to acknowledge the assistance given by 
% Dr. Rogelio Ortigosa in the development of this computer program.
%--------------------------------------------------------------------------
% Master m-File
%--------------------------------------------------------------------------
function FLagSHyP(ansmlv,inputfile)

if nargin ~= 2
    error("requires two input arguments; e.g.: FLagSHyP('y','1elt_3d.dat')");
end

%clear all;close all;clc   
%--------------------------------------------------------------------------
% SECTION 1
%--------------------------------------------------------------------------
% Set up the directory path. 
%--------------------------------------------------------------------------
ansmlv;
inputfile;
if isunix()
    dirsep =  '/';   
else 
    dirsep =  '\';
end
%basedir_fem = mfilename('fullpath')
basedir_fem = '../../';
basedir_fem = fileparts(basedir_fem);
basedir_fem = strrep(basedir_fem,['code' dirsep 'support'],'');
addpath(fullfile(basedir_fem));    
addpath(genpath(fullfile(basedir_fem,'code')));       
addpath((fullfile(basedir_fem,'job_folder')));        
%--------------------------------------------------------------------------
% SECTION 2
%--------------------------------------------------------------------------
% -Welcomes the user and determines whether the problem is being
%  restarted or a data file is to be read. 
% -Reads all necessary input data.
% -Initialises kinematic variables and internal variables.
% -Compute initial tangent matrix and equivalent force vector, excluding
%  pressure component.
global explicit ;
explicit = 1;


%-------------------------------------------------------------------------- 
[PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,CONSTANT,...
 GLOBAL,PLAST,KINEMATICS] = input_data_and_initialisation(basedir_fem,ansmlv,inputfile);
%--------------------------------------------------------------------------
% SECTION 3
%--------------------------------------------------------------------------
% Choose incremental algorithm.  
%--------------------------------------------------------------------------
if (abs(CON.ARCLEN.arcln)==0 && explicit == 0)  
    if ~CON.searc 
       Newton_Raphson_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,...
                                CONSTANT,GLOBAL,PLAST,KINEMATICS);
     else
        Line_Search_Newton_Raphson_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,...
                                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS); 
    end
elseif(explicit == 0)
    Arc_Length_Newton_Raphson_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,...
                                MAT,LOAD,CON,CONSTANT,GLOBAL,PLAST,KINEMATICS);
else
    ExplicitDynamics_algorithm(PRO,FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,...
                                CONSTANT,GLOBAL,PLAST,KINEMATICS);
end

end
%--------------------------------------------------------------------------
% End of Master m-File.
%--------------------------------------------------------------------------
