 %--------------------------------------------------------------------------
% Computes the element vector of global internal forces and the tangent
% stiffness matrix. 
%--------------------------------------------------------------------------
function [T_internal,counter,PLAST_element,geomJn_1] = ...
          InternalForce_explicit(ielement,FEM,xlocal,x0local,...
          element_connectivity,Ve,QUADRATURE,properties,CONSTANT,GEOM,...
          matyp,PLAST,counter,KINEMATICS,MAT, dt)
      
%define explicit as global variable in order to use it in function      
% it is assigned value in Flagsyp.m
global explicit
dim=GEOM.ndime;


% step 2.II       
T_internal = zeros(FEM.mesh.n_dofs_elem,1);
%--------------------------------------------------------------------------
% Computes initial and current gradients of shape functions and various 
% strain measures at all the Gauss points of the element.
%--------------------------------------------------------------------------
KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
             QUADRATURE,KINEMATICS);
%|-/
geomJn_1=GEOM.Jn_1;
Jn_1=GEOM.Jn_1(ielement);

% Ffid = fopen('DefGrad.txt','a+');
% formt = [repmat('%1.4d ',1,3) '\n'];
% fprintf(Ffid,"\nb:\n");
% for i=1:1
%     for j=1:3
%     fprintf(Ffid, formt, KINEMATICS.b(j,:,i));
%     end
%     fprintf(Ffid,"\n");
% end
% fprintf(Ffid,"\nF:\n");
% for i=1:1
%     for j=1:3
%     fprintf(Ffid, formt, KINEMATICS.F(j,:,i));
%     end
%     fprintf(Ffid,"\n");
% end
% fprintf(Ffid,'\n');
% fclose(Ffid);
%--------------------------------------------------------------------------
% Computes element mean dilatation kinematics, pressure and bulk modulus. 
%--------------------------------------------------------------------------
switch matyp
     case {5,7,17}
          [pressure,kappa_bar,DN_x_mean,ve] = ...
           mean_dilatation_pressure(FEM,dim,matyp,properties,Ve,...
                                    QUADRATURE,KINEMATICS);
     otherwise
          pressure = 0;
end
%--------------------------------------------------------------------------
% Gauss quadrature integration loop.
%--------------------------------------------------------------------------
for igauss=1:QUADRATURE.ngauss
    %----------------------------------------------------------------------
    % Extract kinematics at the particular Gauss point.
    %----------------------------------------------------------------------
    kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss);     
    %----------------------------------------------------------------------
    % Obtain stresses (for incompressible or nearly incompressible, 
    % only deviatoric component) and internal variables in plasticity.
    %----------------------------------------------------------------------    
    [Cauchy,PLAST,...
     plast_gauss] = Cauchy_type_selection(kinematics_gauss,properties,...
                                          CONSTANT,dim,matyp,PLAST,igauss);
    %----------------------------------------------------------------------
    % Obtain elasticity tensor (for incompressible or nearly incompressible, 
    % only deviatoric component).
    %----------------------------------------------------------------------   
    if(explicit==0)
        c = elasticity_modulus_selection(kinematics_gauss,properties,CONSTANT,...
                                      dim,matyp,PLAST,plast_gauss,igauss);
    else
        c = 0;
    end
    %----------------------------------------------------------------------
    % Add pressure contribution to stresses and elasticity tensor.
    %----------------------------------------------------------------------    
    [Cauchy,c] = mean_dilatation_pressure_addition(Cauchy,c,CONSTANT,pressure,matyp);    
    %----------------------------------------------------------------------
    %|-/ 
    % Calculate bulk viscosity damping
    b1=0.042; b2=1.2; 
    le=calc_element_size(FEM,GEOM,ielement);
    rho=properties(1); mu=properties(2); lambda=properties(3);
    J=KINEMATICS.J(igauss);
    eps_dot = (J-Jn_1)/dt;
    Cd=sqrt((lambda + 2*mu)/rho);
    
    p1 = rho*b1*le*Cd*eps_dot*CONSTANT.I;
    p2 = rho*(b2*le)^2*abs(eps_dot)*min(0,eps_dot)*CONSTANT.I;
   
    %
    %|-/
        
    %----------------------------------------------------------------------
    % Compute numerical integration multipliers.
    %----------------------------------------------------------------------
    JW = kinematics_gauss.Jx_chi*QUADRATURE.W(igauss)*...
         thickness_plane_stress(properties,kinematics_gauss.J,matyp);
    %----------------------------------------------------------------------
    % Compute equivalent (internal) force vector.
    %----------------------------------------------------------------------
%     T = Cauchy*kinematics_gauss.DN_x;
    T = (Cauchy+p1+p2)*kinematics_gauss.DN_x;
    T_internal = T_internal + T(:)*JW;

end

    %Update previous Jacobian
    geomJn_1(ielement)=J;
    
%--------------------------------------------------------------------------
% Compute conttribution (and extract relevant information for subsequent
% assembly) of the mean dilatation term (Kk) of the stiffness matrix.
%--------------------------------------------------------------------------
switch matyp
    case {5,7,17}         
         [indexi,indexj,global_stiffness,...
          counter] = mean_dilatation_volumetric_matrix(FEM,dim,...
          element_connectivity,DN_x_mean,counter,indexi,indexj,...
          global_stiffness,kappa_bar,ve);
end 

%|-/
% Embedded Elt, Internal force modification
% [T_internal,PLAST_element] = CorrectInternalForce_explicit(FEM,GEOM,ielement,...
%     element_connectivity,Ve,QUADRATURE,MAT,PLAST,plast_gauss,counter,KINEMATICS)
%--------------------------------------------------------------------------
% Store internal variables.
%--------------------------------------------------------------------------
PLAST_element = PLAST;
end

