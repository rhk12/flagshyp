%--------------------------------------------------------------------------
% Computes the contraction of the Levi civita tensor with a vector.
%--------------------------------------------------------------------------
function matrix = Levi_civita_contraction_vector(vector,dim)
switch dim
    case 2
        matrix = [[0  vector(3)];[-vector(3)  0]];
    case 3
        matrix = [[0  vector(3)  -vector(2)];...
                  [-vector(3)  0  vector(1)];...
                  [vector(2)  -vector(1)  0]];
end
