%--------------------------------------------------------------------------
%  Computes the shape functions and derivative of the shape
%  functions for the specific element types considered in the code and for
%  a given Gauss point at the edges (2D elements) or faces (3D elements) of
%  those elements. 
%--------------------------------------------------------------------------
function interpolation = shape_functions_library_boundary(Chi,element_type) 
switch element_type
    case {'tria3','quad4'}
         chi = Chi(1);
         interpolation.N = 0.5*[1-chi, 1+chi];
         interpolation.DN_chi = 0.5*[ -1, 1];
         
    case 'tria6'
         chi = Chi(1);
         N   = [ (chi + eta - 1/2)*(2*chi + 2*eta - 2), -4*chi*(chi + eta - 1), 2*chi*(chi - 1/2), -4*eta*(chi + eta - 1), 4*chi*eta, 2*eta*(eta - 1/2)];
         DN_chi = [[ 4*chi + 4*eta - 3, 4 - 4*eta - 8*chi, 4*chi - 1,            -4*eta, 4*eta,         0]
                   [ 4*chi + 4*eta - 3,            -4*chi,         0, 4 - 8*eta - 4*chi, 4*chi, 4*eta - 1]];                  
         interpolation.N = N([1 2 3 5 6 4]);        
         interpolation.DN_chi = DN_chi(:,[1 2 3 5 6 4]); 
         
    case 'tetr4'
         interpolation = shape_functions_library(Chi,'tria3');
         
    case 'tetr10'
         interpolation = shape_functions_library(Chi,'tria6');         

    case 'hexa8'
         interpolation = shape_functions_library(Chi,'quad4');         
end
