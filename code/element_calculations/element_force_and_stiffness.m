%--------------------------------------------------------------------------
% Computes the element vector of global internal forces and the tangent
% stiffness matrix. 
%--------------------------------------------------------------------------
function [T_internal,indexi,indexj,global_stiffness,counter,PLAST_element] = ...
          element_force_and_stiffness(FEM,xlocal,x0local,...
          element_connectivity,Ve,QUADRATURE,properties,CONSTANT,dim,...
          matyp,PLAST,counter,KINEMATICS,indexi,indexj,global_stiffness)
T_internal = zeros(FEM.mesh.n_dofs_elem,1);
%--------------------------------------------------------------------------
% Computes initial and current gradients of shape functions and various 
% strain measures at all the Gauss points of the element.
%--------------------------------------------------------------------------
KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
             QUADRATURE,KINEMATICS);
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
    c = elasticity_modulus_selection(kinematics_gauss,properties,CONSTANT,...
                                     dim,matyp,PLAST,plast_gauss,igauss);
    %----------------------------------------------------------------------
    % Add pressure contribution to stresses and elasticity tensor.
    %----------------------------------------------------------------------    
    [Cauchy,c] = mean_dilatation_pressure_addition(Cauchy,c,CONSTANT,pressure,matyp);    
    %----------------------------------------------------------------------
    % Compute numerical integration multipliers.
    %----------------------------------------------------------------------
    JW = kinematics_gauss.Jx_chi*QUADRATURE.W(igauss)*...
         thickness_plane_stress(properties,kinematics_gauss.J,matyp);
    %----------------------------------------------------------------------
    % Compute equivalent (internal) force vector.
    %----------------------------------------------------------------------
    T = Cauchy*kinematics_gauss.DN_x;
    T_internal = T_internal + T(:)*JW;
    %----------------------------------------------------------------------
    % Compute conttribution (and extract relevant information for subsequent
    % assembly) of the constitutive term of the stiffness matrix.
    %----------------------------------------------------------------------
    [indexi,indexj,global_stiffness,...
     counter] = constitutive_matrix(FEM,dim,element_connectivity,...
     kinematics_gauss,c,JW,counter,indexi,indexj,global_stiffness);
    %----------------------------------------------------------------------
    % Compute conttribution (and extract relevant information for subsequent
    % assembly) of the geometric term of the stiffness matrix.
    %----------------------------------------------------------------------
    DN_sigma_DN = kinematics_gauss.DN_x'*(Cauchy*kinematics_gauss.DN_x);
    [indexi,indexj,global_stiffness,...
     counter] = geometric_matrix(FEM,dim,element_connectivity,...
     DN_sigma_DN,JW,counter,indexi,indexj,global_stiffness);
end
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
%--------------------------------------------------------------------------
% Store internal variables.
%--------------------------------------------------------------------------
PLAST_element = PLAST;
end

