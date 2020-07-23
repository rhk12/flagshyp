%Calculate linear elastic stress based on given strain field 

G=76.92e9; lam=115.4e9;
EE=G*(3*lam+2*G)/(lam+G);
nu=lam/(2*(lam+G));
K=lam+2*G/3;
rho=7800;

C10=G/2;
D1=2/K;


%Abaqus Strain
LE = [-0.018 0 0; 0 0.0392 0; 0 0 -0.018];
Ea = [-0.01169 0 0; 0  0.04 0; 0 0 -0.01169];
Fa=[1-1.175E-2 0 0; 0 1.04 0; 0 0  1-1.175E-2];

Ja=det(Fa);
ba=Fa*Fa';

Cauchy_a = (G/Ja)*(ba - eye(3)) + (lam/Ja)*log(Ja)*eye(3); 


%Flagshyp Strain (change in length / orriginal length)
E=[-0.018 0 0; 0 0.04 0; 0 0 -0.018];
LE=[0.012 -2E-16 -7E-16; -2E-16 0.039 -4E-16; -7E-16 -4E-16 -0.012];

% LE=log(E+eye(3));
% E=exp(LE)-eye(3)


F=[9.8825e-01 6.9389e-16 3.3662e-16; 0 1.0400 -3.9902e-17; 7.2164e-16 -6.1062e-16 9.8825e-01];
J=det(F);
b=F*F';

Cauchy_f = (G/J)*(b - eye(3)) + (lam/J)*log(J)*eye(3); 

%Elastic Material calculation
E6=[E(1,1) E(2,2) E(3,3) 2*E(2,3) 2*E(1,3) 2*E(1,2)]';
C=[lam+2*G lam lam 0 0 0; lam lam+2*G lam 0 0 0; lam lam lam+2*G 0 0 0; 0 0 0 G 0 0; 0 0 0 0 G 0; 0 0 0 0 0 G];
S6=C*E6;
Cauchy = [S6(1) S6(6) S6(5); S6(6) S6(2) S6(4); S6(5) S6(4) S6(3)]



%Wave speed check
c=sqrt(EE/rho);
cc=sqrt((lam+2*G)/rho);