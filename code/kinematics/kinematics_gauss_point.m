%--------------------------------------------------------------------------
% Extract kinematics at the particular element Gauss point.
%--------------------------------------------------------------------------
function kinematics_gauss = kinematics_gauss_point(KINEMATICS,igauss) 
kinematics_gauss.DN_x   = KINEMATICS.DN_x(:,:,igauss);
kinematics_gauss.Jx_chi = KINEMATICS.Jx_chi(igauss);
kinematics_gauss.F      = KINEMATICS.F(:,:,igauss);
kinematics_gauss.J      = KINEMATICS.J(igauss);
kinematics_gauss.b      = KINEMATICS.b(:,:,igauss);
kinematics_gauss.Ib     = KINEMATICS.Ib(igauss);
kinematics_gauss.lambda = KINEMATICS.lambda(:,igauss);
kinematics_gauss.n      = KINEMATICS.n(:,:,igauss);
end
