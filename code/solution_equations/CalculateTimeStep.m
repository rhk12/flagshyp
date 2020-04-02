%--------------------------------------------------------------------------
% Check for equilibrium convergence.
%--------------------------------------------------------------------------
function [dt] = CalculateTimeStep(PRO,FEM,CON,BC,GLOBAL,MAT)


dtMax = 1e20;
% Main element loop.
%--------------------------------------------------------------------------
for ielement=1:FEM.mesh.nelem

    mu =MAT.props(2);
    lambda = MAT.props(3);
    rho = MAT.props(1);
    nu = 0.5*lambda/(lambda + mu);
 
   

    % ce calculated using dilational wave speed
    ce = sqrt(lambda/rho);
    % le = elementsize(ielement); % still need to write this funton ...
    le = 1.0;
    dt_ielt = le/ce;
    if(dt_ielt < dtMax)
        dt = dt_ielt;
        dtMax = dt;
    end
    
end
dt = .1;


