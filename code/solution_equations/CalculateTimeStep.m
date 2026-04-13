function [dt] = CalculateTimeStep(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT)
dtMax = 1e20;

for ielement = 1:FEM.mesh.nelem
    % Get the material ID for THIS specific element
    matID = MAT.matno(ielement); 
    
    % Access the properties column for that material ID
    rho    = MAT.props(1, matID);
    mu     = MAT.props(2, matID);
    lambda = MAT.props(3, matID);
    
    % Dilational Wave Speed: cdil = sqrt((lambda + 2*mu) / rho)
    ce = sqrt((lambda + 2*mu) / rho);
    
    % Get characteristic element size
    le = calc_element_size(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT,2,ielement);
    
    dt_ielt = le/ce;
    if(dt_ielt < dtMax)
        dt = dt_ielt;
        dtMax = dt;
    end
end
end
