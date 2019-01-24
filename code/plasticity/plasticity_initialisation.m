%--------------------------------------------------------------------------
%  Initialisation of plastic variables.
%--------------------------------------------------------------------------
function    PLASTICITY    = plasticity_initialisation(element_type,nelem,ngauss,dim)
switch element_type
    case 'truss2'
         PLASTICITY.ep    = zeros(nelem,1); 
         PLASTICITY.epbar = zeros(nelem,1); 
    otherwise
         PLASTICITY.epbar = zeros(ngauss,nelem,1);
         PLASTICITY.invCp = reshape(repmat(eye(3),1,ngauss*nelem),3,3,ngauss,nelem); 
end
