%--------------------------------------------------------------------------
function output_textfile(PRO,CON,GEOM,FEM,BC,GLOBAL,MAT,PLAST,QUADRATURE,CONSTANT,KINEMATICS)
%--------------------------------------------------------------------------
% Restart or write from sratch.
%--------------------------------------------------------------------------
string='a';

if (~PRO.rest && CON.incrm==0)
    string='w';
    system('rm *-results.txt');
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
if CON.incrm==0
    GLOBAL.Reactions(BC.fixdof) = 0.0;
else
    aux(BC.fixdof)            =  GLOBAL.Reactions;
end
%%format long
%aux


%output nodes according to job name. 
if ( PRO.resultsfile_name == "nonlinear_solid_truss_elastic_2D-results.txt" )
    n1=3; % %2D  this is top node where we extract information on disp
    n1dof = 2;  %2D   
    %node which has reacton force is extracted . 
    n2 = 1; %2D   
    n2dof = 2;%2D   
    % bottom node we will use for computing length.
    n3 = 4;%2D   
    outdisp = info3(n1,n1dof);
    %-info2(n1,n1dof);
    xl = info2(n1,1+2)-info2(n3,1+2);
    yl = info2(n1,2+2)-info2(n3,2+2);
    len0 = sqrt(xl^2 + yl^2);
    fprintf(fid4,'%d %.10e %.10e\n',CON.incrm,-(info3(n1,n1dof+2))/len0,aux(n2dof,n2)/(1*0.7071));
    
elseif ( PRO.resultsfile_name == "nonlinear_solid_truss_plastic_3D-results.txt" )
    n1=2; % this is top node where we extract information on disp
    n1dof = 3;   
    %node which has reacton force is extracted . 
    n2 =4;
    n2dof = 3;
    % bottom node we will use for computing length.
    n3 = 1;
    outdisp = info3(n1,n1dof);
    %-info2(n1,n1dof);
    xl = info2(n1,1+2)-info2(n3,1+2);
    zl = info2(n1,3+2)-info2(n3,3+2);
    len0 = sqrt(xl^2 + zl^2);
    youngs = 210000;
    area = 0.7071;
    fprintf(fid4,'%d %.10e %.10e\n',CON.incrm,-(info3(n1,n1dof+2))/len0,aux(n2dof,n2)/(youngs*area));
elseif ( PRO.resultsfile_name == "Ex4-2-results.txt" )
    n1=2; % this is top node where we extract information on disp
    n1dof = 3;   
    %node which has reacton force is extracted . 
    n2 =4;
    n2dof = 3;
    % bottom node we will use for computing length.
    n3 = 1;
    %outdisp = info3(n1,n1dof);

    for ielement=1:FEM.mesh.nelem
        %----------------------------------------------------------------------
        % Temporary variables associated with a particular element
        % ready for stress or strain output calculation.
        %----------------------------------------------------------------------
        global_nodes    = FEM.mesh.connectivity(:,ielement); 
        material_number = MAT.matno(ielement);               
        matyp           = MAT.matyp(material_number);        
        properties      = MAT.props(:,material_number);      
        xlocal          = GEOM.x(:,global_nodes);            
        x0local         = GEOM.x0(:,global_nodes);               
        Ve              = GEOM.Ve(ielement); 
        % extract kinematics structure 
        format short
        KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                              QUADRATURE,KINEMATICS)  ;

        % Let's just look at guass point #1
        F=KINEMATICS.F(:,:,1);
        %F(:,:,1);
        b = F * F';
        [b_e_vectors,b_e_values] = eig(b);

        % compute V and lnV
        % take care of ln(0) = -Inf 
        if FEM.mesh.element_type == 'quad4'
            if QUADRATURE.ngauss == 4 % the 2 is b/c it is the largest e-value from matlab 
                V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
                    sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
                lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
                    log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)';
                
            end
        end

        if (ielement == 1) 
            fprintf(fid4,'%d %.10e %.10e %.10e %.10e  \n',CON.incrm,F(1,1),F(1,2),F(2,1),F(2,2));
        end
    end % end for loop on ielement.
elseif ( PRO.resultsfile_name == "2D_1Elt_PolarDecompExample-results.txt" )
    n1=2; % this is top node where we extract information on disp
    n1dof = 3;   
    %node which has reacton force is extracted . 
    n2 =4;
    n2dof = 3;
    % bottom node we will use for computing length.
    n3 = 1;
    %outdisp = info3(n1,n1dof);

    for ielement=1:FEM.mesh.nelem
        %----------------------------------------------------------------------
        % Temporary variables associated with a particular element
        % ready for stress or strain output calculation.
        %----------------------------------------------------------------------
        global_nodes    = FEM.mesh.connectivity(:,ielement); 
        material_number = MAT.matno(ielement);               
        matyp           = MAT.matyp(material_number);        
        properties      = MAT.props(:,material_number);      
        xlocal          = GEOM.x(:,global_nodes);            
        x0local         = GEOM.x0(:,global_nodes);               
        Ve              = GEOM.Ve(ielement); 
        % extract kinematics structure 
        format short
        KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                              QUADRATURE,KINEMATICS)  ;

        % Let's just look at guass point #1
        F=KINEMATICS.F(:,:,1);
        %F(:,:,1);
        b = F * F';
        [b_e_vectors,b_e_values] = eig(b);

        % compute V and lnV
        % take care of ln(0) = -Inf 
        if FEM.mesh.element_type == 'quad4'
            if QUADRATURE.ngauss == 4 % the 2 is b/c it is the largest e-value from matlab 
                V=  sqrt(b_e_values(1,1))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
                    sqrt(b_e_values(2,2))*b_e_vectors(:,2)*b_e_vectors(:,2)';
           
                lnV=log(sqrt(b_e_values(1,1)))*b_e_vectors(:,1)*b_e_vectors(:,1)'+ ...
                    log(sqrt(b_e_values(2,2)))*b_e_vectors(:,2)*b_e_vectors(:,2)';
                
            end
       
        end

        if (ielement == 1) 
            fprintf(fid4,'%d %.10e %.10e %.10e %.10e  \n',CON.incrm,lnV(1,1),lnV(1,2),lnV(2,1), lnV(2,2));
        end
    end % end for loop on ielement.
    
elseif(PRO.resultsfile_name == "growthv1-results.txt" )
    for ielement=1:FEM.mesh.nelem
        %----------------------------------------------------------------------
        % Temporary variables associated with a particular element
        % ready for stress or strain output calculation.
        %----------------------------------------------------------------------
        global_nodes    = FEM.mesh.connectivity(:,ielement); 
        material_number = MAT.matno(ielement);               
        matyp           = MAT.matyp(material_number);        
        properties      = MAT.props(:,material_number);      
        xlocal          = GEOM.x(:,global_nodes);            
        x0local         = GEOM.x0(:,global_nodes);               
        Ve              = GEOM.Ve(ielement); 
        % extract kinematics structure 
        format short
        KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                              QUADRATURE,KINEMATICS)  ;
        F=KINEMATICS.F;
        F(1,1,1);
        if (ielement == 4) 
            fprintf(fid4,'%d %.10e %.10e %.10e %.10e\n',CON.incrm,F(1,1,1),F(1,2,1),F(2,1,1),F(2,2,1));
        end
    end % end for loop on ielement.
      
else

end



fclose(fid4);






