%--------------------------------------------------------------------------
% Obtain quadrature (numerical integration) rules for edge/surface elements. 
%--------------------------------------------------------------------------
function QUADRATURE = edge_quadrature_rules(element_type)
switch element_type
    case {'quad4','tria3'}
        QUADRATURE.Chi  = [-0.577350269189626; 0.577350269189626];
        QUADRATURE.W    = [1;1];
    case 'tria6'        
        QUADRATURE.Chi  = [0.774596669241483;0;-0.774596669241483];
        QUADRATURE.W    = [0.555555555555554;0.888888888888889;0.555555555555554];
    case 'tetr4'
         QUADRATURE.Chi = [1/3 1/3];
         QUADRATURE.W   = 0.5;
    case 'tetr10'
         QUADRATURE.Chi = [[0.5 0];[0.5 0.5];[0 0.5]];
         QUADRATURE.W   = [1/6;1/6;1/6];
    case 'hexa8'
         QUADRATURE.Chi = [[-0.577350269189626  -0.577350269189626];
                           [ 0.577350269189626  -0.577350269189626];
                           [ 0.577350269189626   0.577350269189626];
                           [-0.577350269189626   0.577350269189626]];
         QUADRATURE.W   = [1;1;1;1];
end        
%--------------------------------------------------------------------------
% Set the number of integration points.
%--------------------------------------------------------------------------
QUADRATURE.ngauss = size(QUADRATURE.W,1);
end

