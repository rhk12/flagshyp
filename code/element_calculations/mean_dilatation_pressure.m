%--------------------------------------------------------------------------
% Computes element mean dilatation kinematics, pressure and bulk modulus.
%--------------------------------------------------------------------------
function [pressure,kappa_bar,DN_x_mean,ve] = mean_dilatation_pressure(FEM,...
          dim,matyp,properties,Ve,QUADRATURE,KINEMATICS)
DN_x_mean = zeros(dim,FEM.mesh.n_nodes_elem);
ve = 0;
for igauss=1:QUADRATURE.ngauss
    JW = KINEMATICS.Jx_chi(igauss)*QUADRATURE.W(igauss);
    %----------------------------------------------------------------------
    % Gauss contribution to the elemental deformed volume.
    %----------------------------------------------------------------------
    ve = ve + JW;
    %----------------------------------------------------------------------
    % Elemental averaged shape functions.
    %----------------------------------------------------------------------
    DN_x_mean = DN_x_mean + KINEMATICS.DN_x(:,:,igauss)*JW;
end
DN_x_mean = DN_x_mean/ve;
Jbar = ve/Ve;
%--------------------------------------------------------------------------
% Computes element mean dilatation pressure and bulk modulus.
%--------------------------------------------------------------------------
switch matyp
    case 5
        kappa     = properties(3);
        pressure  = kappa*(Jbar - 1);
        kappa_bar = kappa*Jbar;
    case 7
        kappa     = properties(3);
        pressure  = kappa*log(Jbar)/Jbar;
        kappa_bar = kappa/Jbar - pressure;
    case 17
        kappa     = properties(4);
        pressure  = kappa*log(Jbar)/Jbar;
        kappa_bar = kappa/(Jbar) - pressure;
end
