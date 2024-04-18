function c_tensor = ctens9(kinematics,dim)
    % Values of mu and kappa come from Cheng Zhang 2017 paper
    mu1      = 0.595522; %units MPa
    mu2      = 0.050381; %units MPa
    k        = 1*10^5;   %units MPa
    J               = kinematics.J;
    F               = kinematics.F;
    % Calc C
    C = F'*F;
    % Calc Modified C
    C_bar = J^(-2/3)*(F'*F);
    % Calc Modified B
    B = C_bar';
    % Calc I bar
    Ibar1 = J^(-2/3)*trace(C);
    Ibar2 = J^(-4/3)*(.5*(trace(C)^2-trace(C^2)));
    % Define Kronecker delta as Identity
    KDel = eye(dim);
    % Create fourth order elasticity tensor
    c_tensor = [];
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    c_tensor(i,j,k,l) = (2*mu2*(B(i,j)*B(k,l))-.5*(B(i,k)*B(j,l)+B(i,l)*B(j,k))) - ((2/3)*(mu1+2*mu2*Ibar1)*(B(i,j)*KDel(k,l)+B(k,l)*KDel(i,j))) + ((4/3)*mu2*(B(i,j)^2*KDel(k,l)+B(k,l)^2*KDel(i,j))+((2/9)*(mu1*Ibar1+4*mu2*Ibar2)*(KDel(i,j)*KDel(k,l))) + ((1/3)*(mu1*Ibar1 + 2*mu2*Ibar2)*(KDel(i,k)*KDel(j,l) + KDel(i,l)*KDel(j,k))));
                end
            end
        end
    end
    
end