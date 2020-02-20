%--------------------------------------------------------------------------
% Opens input, output and restart files.
%--------------------------------------------------------------------------
function PRO  = welcome(basedir_fem,ansmlv,inputfile)
%--------------------------------------------------------------------------
% Welcomes the user on screen.
%--------------------------------------------------------------------------
fprintf([' P R O G R A M    F L a g S H y P \n Finite element LArGe'...
         ' Strain HYperelasticity \n Program \n\n']);
%ansmlv   = input([' Is the problem starting from scratch (y/n) ?: ' ' \n'],'s');

%Kraft added. Read from file:
ansmlv;
inputfile;
%ansmlv = 'n';
%PRO.inputfile_name = 'text';
PRO.rest = true;
%fileid = fopen('run_params.txt','r');
%formatspec = '%s %s';
%A =textscan(fileid,formatspec);
%celldisp(A);
%A{1}{1};
%A{2}{1};
%ansmlv = A{1}{1}
%PRO.inputfile_name = A{2}{1}

PRO.inputfile_name = inputfile;

%fclose(fileid);

PRO.rest = true;
%--------------------------------------------------------------------------
% Reads in the input file name.
%--------------------------------------------------------------------------
if( strcmp(deblank(ansmlv),deblank('y')) || strcmp(deblank(ansmlv),deblank('Y')))
    %PRO.inputfile_name = input([' Enter the data file name   : ' ' \n'],'s');
    %PRO.inputfile_name = 'twisting_column.dat'
    PRO.inputfile_name;
    auxiliar = 0;
    for ichar=1:length(PRO.inputfile_name)
        if  (PRO.inputfile_name(ichar) == '.')
            auxiliar       = auxiliar + 1;
            character_dot  = ichar; 
        end
    end
    auxiliar               = auxiliar - 1;
    %----------------------------------------------------------------------
    % Check if the format is correct.
    %----------------------------------------------------------------------
    if auxiliar
        error(['Wrong format. Please check the format of your input file.'... 
              ' Do not please forget to specify the extension'])
    end
    %----------------------------------------------------------------------
    % Define the job folder location.
    %----------------------------------------------------------------------
    PRO.job_folder = fullfile(basedir_fem,['job_folder/'...
                              PRO.inputfile_name(1:character_dot-1)]);
    %----------------------------------------------------------------------
    % Check if this folder has been defined by the user or not.
    %----------------------------------------------------------------------
    if ~exist(PRO.job_folder,'dir')
        error(['The folder ' PRO.job_folder ' has not been ' ...
            'created. Please define the folder and the input file (not '...
            'including the extension) identical'])
    end
    cd(PRO.job_folder)
    %----------------------------------------------------------------------
    % Check that the input file is located within the job folder.
    %----------------------------------------------------------------------
    if ~exist(PRO.inputfile_name,'file')       
       error('Missing data file or job folder')
    end
    %----------------------------------------------------------------------
    % Open input file for reading.
    %----------------------------------------------------------------------
    PRO.fid_input = fopen( PRO.inputfile_name,'r+');
    PRO.rest      = false;
    %----------------------------------------------------------------------
    % Open the output and restart files.
    %----------------------------------------------------------------------
    PRO.outputfile_name           = [PRO.inputfile_name(1:character_dot-1)...
                                    '-OUTPUT.txt']; 
    PRO.resultsfile_name           = [PRO.inputfile_name(1:character_dot-1)...
                                    '-results.txt'];                            
    PRO.outputfile_name_flagout   = [PRO.inputfile_name(1:character_dot-1)...
                                    '-OUTPUT_FLAGOUT.txt'];
    PRO.restartfile_name          = [PRO.inputfile_name(1:character_dot-1)...
                                    '-increment_1' '-RESTART.MAT']; 
    PRO.internal_restartfile_name = [PRO.inputfile_name(1:character_dot-1)...
                                    '-RESTART.MAT'];                                                               
    if( ~ PRO.rest )
        PRO.fid_output  = fopen(PRO.outputfile_name,'w+');
        PRO.fid_restart = fopen(PRO.restartfile_name,'wb');
    else
        PRO.fid_output  = fopen(PRO.outputfile_name,'w+');
        PRO.fid_restart = fopen(PRO.restartfile_name,'rb');
    end
    PRO.res_character_incr = length(PRO.restartfile_name(1:end-13));
else
    jobfolder = input([' Enter the folder name   : ' ' \n'],'s');    
    incr      = input([' Enter the load increment number   : ' ' \n'],'s');    
    %----------------------------------------------------------------------
    % Define the job folder location.
    %----------------------------------------------------------------------
    PRO.job_folder = fullfile(basedir_fem,['job_folder\' jobfolder]);
    %----------------------------------------------------------------------
    % Check if this folder has been defined by the user or not.
    %----------------------------------------------------------------------
    if ~exist(PRO.job_folder,'dir')
        error_type
        error(['The folder ' PRO.job_folder ' has not been ' ...
            'created. Please define the folder and the input file (not '...
            'including the extension) identical'])
    end
    cd(PRO.job_folder)
    %----------------------------------------------------------------------
    % Restart file name.
    %----------------------------------------------------------------------
    PRO.restartfile_name = [jobfolder '-increment_' num2str(incr) '-RESTART.MAT'];
    PRO.internal_restartfile_name = [jobfolder '-RESTART.MAT']; 
    %----------------------------------------------------------------------
    % Check that the restart file is located within the job folder.
    %----------------------------------------------------------------------
    if ~exist(PRO.restartfile_name,'file')       
       error('The restart file does not exist')
    end

end
