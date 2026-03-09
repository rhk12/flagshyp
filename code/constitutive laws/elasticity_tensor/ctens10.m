%--------------------------------------------------------------------------
% Evaluates the stiffness tensor for Mooney Rilvin model
%--------------------------------------------------------------------------
function c = ctens10(kinematics,properties,cons)
%Extract material properties
   mu1 = properties(1);
   mu2 = properties(2);
%Extract Kinematic Variables
   B = kinematics.B;
   C = kinematics.C;
   J = kinematics.J;
   F = kinematics.F;
  
%Compute invariants 
I1 = trace(B);
I2 = 0.5*(I1^2-trace(B^2));
I1_bar = J^(-2/3)*I1;
I2_bar = J^(-4/3)*I2;
% Identity matrix
IM = cons.I;
c = 2 * mu2 * (B * B' - 0.5*(B*B' + B'*B))...
   -(2/3) * (mu1 + 2 * mu2 * I1_bar) * (B.*(IM.' * IM) + IM.*(B.'*B))...
   +(4/3) * mu2 * (B.^2.*(IM.'*IM) + (B.'*B).^2)...
   +(2/9) * (mu1 * I1_bar + 4 * mu2 * I2_bar) * (IM.' * IM.* IM.'* IM)...
   +(1/3) * (mu1 * I1_bar + 2 * mu2 * I2_bar) * (IM.' * IM.*(IM.'*IM)+(IM.'*IM).*IM.'*IM);
end
