%--------------------------------------------------------------------------
% Compute stresses at Gauss point level.
%--------------------------------------------------------------------------
function Stress = stress_output(dim,PLAST_element,matyp,Ve,xlocal,x0local,...
                  properties,QUADRATURE,CONSTANT,FEM,KINEMATICS,GEOM)
switch matyp
    %----------------------------------------------------------------------
    % Obtain stress for trusses.
    %----------------------------------------------------------------------
    case 2        
        [T_internal,indexi,indexj,global_stiffness,counter,PLAST,Stress] = ...
         element_force_and_stiffness_truss(properties,xlocal,x0local,[1 2],...
         FEM,PLAST_element,1,randi(1,36,1),randi(1,36,1),randi(1,36,1),GEOM);        
    otherwise
        %------------------------------------------------------------------
        % Initialisation for continuum elements.
        %------------------------------------------------------------------
         Stress = zeros((dim-1)*3+1,QUADRATURE.ngauss);             
         switch dim
             case 2
                  components = [1;2;4];
             case 3
                  components = [1;2;3;5;6;9];
         end                 
end
%--------------------------------------------------------------------------
% Obtain stress for continuum elements.
%--------------------------------------------------------------------------
if matyp~=2
   %--------------------------------------------------------------------------
   % Kinematics at the Gauss points of the element.
   %--------------------------------------------------------------------------
   KINEMATICS = gradients(xlocal,x0local,FEM.interpolation.element.DN_chi,...
                          QUADRATURE,KINEMATICS);
   %-----------------------------------------------------------------------
   % Compute pressure from mean dilatation algorithm.
   %-----------------------------------------------------------------------
   switch matyp
     case {5,7,17}
          pressure = mean_dilatation_pressure(FEM,dim,matyp,properties,...
                                              Ve,QUADRATURE,KINEMATICS);
     otherwise
          pressure = 0;
   end
   for igauss=1:QUADRATURE.ngauss 
       kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss);
       Cauchy = Cauchy_type_selection(kinematics_gauss,properties,...
                                      CONSTANT,dim,matyp,PLAST_element,igauss);
       Cauchy  = mean_dilatation_pressure_addition(Cauchy,zeros(dim,dim,dim,dim),...
                                   CONSTANT,pressure,matyp);           
       thickness = thickness_plane_stress(properties,kinematics_gauss.J,matyp);
       Stress(1:end,igauss) = [Cauchy(components);thickness]    ; 
   end
   %-----------------------------------------------------------------------
   % Remove thickness from non-plane stress elements.
   %-----------------------------------------------------------------------
   switch matyp
       case {1,3,5,7,17}
            Stress(end,:) = [];
   end
end

        
        
