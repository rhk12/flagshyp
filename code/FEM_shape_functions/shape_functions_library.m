%--------------------------------------------------------------------------
% This function computes the shape functions and derivative of the shape
% functions for the specific element types considered in the code and for
% a given Gauss point.
%--------------------------------------------------------------------------
function interpolation = shape_functions_library(Chi,element_type) 
switch element_type
    case 'tria3'
         chi      = Chi(1);
         eta      = Chi(2);
         interpolation.N = [1 - eta - chi, chi, eta];
         interpolation.DN_chi = [[ -1, 1, 0]
                                 [ -1, 0, 1]];
                             
    case 'tria6'
         chi    = Chi(1);
         eta    = Chi(2);
         N      = [ (chi + eta - 1/2)*(2*chi + 2*eta - 2), -4*chi*(chi + eta - 1), 2*chi*(chi - 1/2), -4*eta*(chi + eta - 1), 4*chi*eta, 2*eta*(eta - 1/2)];
         DN_chi = [[ 4*chi + 4*eta - 3, 4 - 4*eta - 8*chi, 4*chi - 1,            -4*eta, 4*eta,         0]
                  [ 4*chi + 4*eta - 3,            -4*chi,         0, 4 - 8*eta - 4*chi, 4*chi, 4*eta - 1]];                  
         interpolation.N = N([1 2 3 5 6 4]);        
         interpolation.DN_chi = DN_chi(:,[1 2 3 5 6 4]); 

    case 'quad4'
         chi = Chi(1);
         eta = Chi(2);
         N   = [ ((chi - 1)*(eta - 1))/4, -((chi + 1)*(eta - 1))/4, -((chi - 1)*(eta + 1))/4, ((chi + 1)*(eta + 1))/4];
         DN_chi = [[ eta/4 - 1/4,   1/4 - eta/4, - eta/4 - 1/4, eta/4 + 1/4]
                   [ chi/4 - 1/4, - chi/4 - 1/4,   1/4 - chi/4, chi/4 + 1/4]];
         interpolation.N = N([1 2 4 3]);        
         interpolation.DN_chi = DN_chi(:,[1 2 4 3]); 
                  
    case 'tetr4'
         chi  = Chi(1);
         eta  = Chi(2);
         iota = Chi(3);
         interpolation.N = [ 1 - eta - iota - chi, chi, eta, iota]; 
         interpolation.DN_chi = [[ -1, 1, 0, 0]
                                 [ -1, 0, 1, 0]
                                 [ -1, 0, 0, 1]];
                             
    case 'tetr10'
         chi  = Chi(1);
         eta  = Chi(2);
         iota =  Chi(3);
         N    = [ (chi + eta + iota - 1/2)*(2*chi + 2*eta + 2*iota - 2), -4*chi*(chi + eta + iota - 1), 2*chi*(chi - 1/2), -4*eta*(chi + eta + iota - 1), 4*chi*eta, 2*eta*(eta - 1/2), -4*iota*(chi + eta + iota - 1), 4*chi*iota, 4*eta*iota, 2*iota*(iota - 1/2)];         
         DN_chi =  [[ 4*chi + 4*eta + 4*iota - 3, 4 - 4*eta - 4*iota - 8*chi, 4*chi - 1,                     -4*eta, 4*eta,         0,                    -4*iota, 4*iota,      0,          0]
                   [ 4*chi + 4*eta + 4*iota - 3,                     -4*chi,         0, 4 - 8*eta - 4*iota - 4*chi, 4*chi, 4*eta - 1,                    -4*iota,      0, 4*iota,          0]
                   [ 4*chi + 4*eta + 4*iota - 3,                     -4*chi,         0,                     -4*eta,     0,         0, 4 - 4*eta - 8*iota - 4*chi,  4*chi,  4*eta, 4*iota - 1]];
         interpolation.N = N([1 3 6 10 2 5 4 7 8 9]);        
         interpolation.DN_chi = DN_chi(:,[1 3 6 10 2 5 4 7 8 9]); 
         
    case 'hexa8'
         chi  = Chi(1);
         eta  = Chi(2);
         iota = Chi(3);
         N    = [ -((chi - 1)*(eta - 1)*(iota - 1))/8,((chi + 1)*(eta - 1)*(iota - 1))/8,((chi - 1)*(eta + 1)*(iota - 1))/8, -((chi + 1)*(eta + 1)*(iota - 1))/8, ((chi - 1)*(eta - 1)*(iota + 1))/8,  -((chi + 1)*(eta - 1)*(iota + 1))/8,  -((chi - 1)*(eta + 1)*(iota + 1))/8, ((chi + 1)*(eta + 1)*(iota + 1))/8];
         DN_chi = [[ -((eta - 1)*(iota - 1))/8, ((eta - 1)*(iota - 1))/8, ((eta + 1)*(iota - 1))/8, -((eta + 1)*(iota - 1))/8, ((eta - 1)*(iota + 1))/8, -((eta - 1)*(iota + 1))/8, -((eta + 1)*(iota + 1))/8, ((eta + 1)*(iota + 1))/8]
                   [ -((chi - 1)*(iota - 1))/8, ((chi + 1)*(iota - 1))/8, ((chi - 1)*(iota - 1))/8, -((chi + 1)*(iota - 1))/8, ((chi - 1)*(iota + 1))/8, -((chi + 1)*(iota + 1))/8, -((chi - 1)*(iota + 1))/8, ((chi + 1)*(iota + 1))/8]
                   [  -((chi - 1)*(eta - 1))/8,  ((chi + 1)*(eta - 1))/8,  ((chi - 1)*(eta + 1))/8,  -((chi + 1)*(eta + 1))/8,  ((chi - 1)*(eta - 1))/8,  -((chi + 1)*(eta - 1))/8,  -((chi - 1)*(eta + 1))/8,  ((chi + 1)*(eta + 1))/8]];
         interpolation.N = N([1 2 4 3 5 6 8 7]);
         %interpolation.N = N;
         interpolation.DN_chi = DN_chi(:,[1 2 4 3 5 6 8 7]);
         %interpolation.DN_chi = DN_chi;
end
