  %--------------------------------------------------------------------------
% Evaluates the constitutive tensor (in Voigt notation) for material type 1.
%--------------------------------------------------------------------------
function c = ctens1(kinematics,properties,cons)
% Shear and bulk modulus mu_1+mu_2 are materials properties to input
mu_1            = properties(2);
mu_2            = properties(3); 
k               = properties(4);

F               = Kinematics.F;
J               = kinematics.J;

% Modified right Cauchy-Green tensor C_bar
C               = F * F';
C_bar           = J^(-2/3)*C;

% Modified invariant I1_bar, I2_bar 
I1              = trace(C);
I1_bar          = J^(-2/3)*I1;
I2              = 0.5*(I1*I1-tr(C*C));
I2_bar          = J^(-4/3)*I2;

% Calculate dyadic and inverse derivate of inv(C_bar)
CInv_dyadic     = inv(C_bar)*(inv(C_bar))';
CInv_derivate   = -diff(inv(C_bar))./diff(inv(C_bar));

% Elasticity tensor c can be rewritten in the decoupled form: c_vol+c_iso
c_vol           = J^(-1/3)*(2*J-1)*k*CInv_dyadic - 2*J^(-1/3)*(J-1)*k*CInv_derivate;
c_iso           = 2*J^(-4/3)*mu_2*(cons.I*(cons.I)'-cons.IDENTITY_TENSORS.c1)...
                  -(2/3)*J^(-4/3)*(mu_1+2*mu_2*I1_bar)*(inv(C_bar)*(cons.I)'+cons.I*(inv(C_bar)))...
                  +(4/3)*J(-4/3)*mu_2*(inv(C_bar)*(C_bar)'+C_bar*(inv(C_bar))')...
                  +(2/9)*J(-4/3)*(mu_1*I1_bar+4*mu_2*I2_bar)*CInv_dyadic...
                  +(2/3)*J(-4/3)*(mu_1*I1_bar+4*mu_2*I2_bar)*CInv_derivate;

c               = c_vol + c_iso;
end


