%--------------------------------------------------------------------------
% Check for equilibrium convergence.
%--------------------------------------------------------------------------
function [dt] = CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT)


dtMax = 1e20;
% Main element loop.
%--------------------------------------------------------------------------
for ielement=1:FEM.mesh.nelem
    mu =MAT.props(2);
    lambda = MAT.props(3);
    rho = MAT.props(1);

    % ce calculated using dilational wave speed
%     nu = 0.5*lambda/(lambda + mu);
%     bulkmod = lambda + 2*mu/3;
%     Eprop = (mu * (3*lambda +2 * mu)) / (lambda + mu);
%     ce = sqrt(Eprop/rho);
    
    %Longitudinal Bulk wave speed
    ce = sqrt((lambda + 2*mu)/rho);
    
    [le, max_le] = calc_element_size(FEM,GEOM,ielement);
    dt_ielt = le/ce;
    if(dt_ielt < dtMax)
        dt = dt_ielt;
        dtMax = dt;
    end
    
end


end



