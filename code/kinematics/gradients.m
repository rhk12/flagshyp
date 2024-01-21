%--------------------------------------------------------------------------
% Computes F, J, b, trace(b), the derivative of the shape functions with
% respect to the deformed coordinates and its determinant (Jacobian of the 
% mapping between deformed and isoparametric configurations) given the 
% current coordinates of an element and the isoparametric derivative of
% the shape functions. It also computes the principal stretches (lambda) 
% and their associated principal spatial principal directions (n).
%--------------------------------------------------------------------------
function KINEMATICS = gradients(xlocal,Xlocal,DN_chi,QUADRATURE,KINEMATICS) 
for igauss=1:QUADRATURE.ngauss
    %----------------------------------------------------------------------
    % Derivative of shape functions with respect to ...
    % - initial coordinates.
    %----------------------------------------------------------------------
    DX_chi = Xlocal*DN_chi(:,:,igauss)';
    DN_X   = DX_chi'\DN_chi(:,:,igauss);
    %----------------------------------------------------------------------   
    % - current coordinates.
    %----------------------------------------------------------------------
    Dx_chi = xlocal*DN_chi(:,:,igauss)';
    DN_x   = (Dx_chi)'\DN_chi(:,:,igauss);  
    Jx_chi = abs(det(Dx_chi));      
    %----------------------------------------------------------------------
    % Compute various strain measures.
    %--------------------------------------------------------------------
    F     = xlocal*DN_X';                
    J     = det(F);  
    C     = F'*F;
    b     = F*F';  
    Ib    = trace(b);     
    [V,D] = eig(b) ;      
    %----------------------------------------------------------------------
    % Storage of variables.
    %----------------------------------------------------------------------
    KINEMATICS.DN_x(:,:,igauss) = DN_x;  
    KINEMATICS.Jx_chi(igauss)   = Jx_chi;
    KINEMATICS.F(:,:,igauss)    = F;     
    KINEMATICS.J(igauss)        = J;     
    KINEMATICS.b(:,:,igauss)    = b;   
    KINEMATICS.Ib(igauss)       = Ib;  
    KINEMATICS.lambda(:,igauss) = sqrt(diag(D));   
    KINEMATICS.n(:,:,igauss)    = V  ;             
end
end
