%----------------------------------------------------------------------
% Obtain entities which will be constant and only computed once.
%----------------------------------------------------------------------
function CONSTANT = constant_entities(dimension)
CONSTANT.I = eye(dimension);                                                                                                      
%--------------------------------------------------------------------------                                                             
% Indicial components of fourth order isotropic tensors 
% c1 = delta(i,j)*delta(k,l)
% c2 = delta(i,k)*delta(j,l) + delta(i,l)*delta(j,k) 
% (see textbook example 2.8)
%--------------------------------------------------------------------------                                                             
c1 =  zeros(dimension,dimension,dimension,dimension);
c2 =  zeros(dimension,dimension,dimension,dimension);
for l=1:dimension
    for k=1:dimension
        for j=1:dimension
            for i=1:dimension
                c1(i,j,k,l) = c1(i,j,k,l) + CONSTANT.I(i,j)*CONSTANT.I(k,l);
                c2(i,j,k,l) = c2(i,j,k,l) + CONSTANT.I(i,k)*CONSTANT.I(j,l) + ...
                                            CONSTANT.I(i,l)*CONSTANT.I(j,k);
            end
        end
    end
end
CONSTANT.IDENTITY_TENSORS.c1 = c1;
CONSTANT.IDENTITY_TENSORS.c2 = c2;
end

