%--------------------------------------------------------------------------
% Read input data.
%--------------------------------------------------------------------------
function [FEM,GEOM,QUADRATURE,BC,MAT,LOAD,CON,PRO,GLOBAL] = ...
          reading_input_file(PRO,fid)
%--------------------------------------------------------------------------
% Problem title.   
%--------------------------------------------------------------------------
PRO.title = strtrim(fgets(fid));
%--------------------------------------------------------------------------
% Element type.    
%--------------------------------------------------------------------------
[FEM,GEOM,QUADRATURE] = elinfo(fid);    
%--------------------------------------------------------------------------
% Obtain quadrature rules, isoparametric shape functions and their  
% derivatives for the internal and boundary elements.
%--------------------------------------------------------------------------
switch FEM.mesh.element_type
    case 'truss2'
      FEM.interpolation.element = [];
      FEM.interpolation.boundary = [];
    otherwise
      QUADRATURE.element = element_quadrature_rules(FEM.mesh.element_type);
      QUADRATURE.boundary = edge_quadrature_rules(FEM.mesh.element_type);
      FEM = shape_functions_iso_derivs(QUADRATURE,FEM,GEOM.ndime);
end
%--------------------------------------------------------------------------
% Read the number of mesh nodes, nodal coordinates and boundary conditions.  
%--------------------------------------------------------------------------
[GEOM,BC,FEM] = innodes(GEOM,fid,FEM);
%--------------------------------------------------------------------------
% Read the number of elements, element connectivity and material number.
%--------------------------------------------------------------------------
[FEM,MAT] = inelems(FEM,fid);
%--------------------------------------------------------------------------
% Obtain fixed and free degree of freedom numbers (dofs).
%--------------------------------------------------------------------------
BC = find_fixed_free_dofs(GEOM,FEM,BC);
%--------------------------------------------------------------------------
% Read the number of materials and material properties.  
%--------------------------------------------------------------------------
MAT = matprop(MAT,FEM,fid); 
%--------------------------------------------------------------------------
% Read nodal point loads, prescribed displacements, surface pressure loads
% and gravity (details in textbook).
%--------------------------------------------------------------------------
[LOAD,BC,FEM,GLOBAL] = inloads(GEOM,FEM,BC,fid);
%--------------------------------------------------------------------------
% Read control parameters.
%--------------------------------------------------------------------------
CON = incontr(BC,fid);
fclose('all'); 
end
