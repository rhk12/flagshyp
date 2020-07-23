%Calculate linear elastic stress based on given strain field 

G=76.92e9; lam=115.4e9;
EE=G*(3*lam+2*G)/(lam+G);
nu=lam/(2*(lam+G));
K=lam+2*G/3;
rho=7800;

C10=G/2
D1=2/K


%Abaqus Strain
Ea = [-0.01176 0 0; 0  0.0392 0; 0 0 -0.01176];
Fa=eye(3)+Ea;

(1/2)*(Fa'*Fa-eye(3))


%Flagshyp Strain (change in length / orriginal length)
E=Ea;
F=Fa;
% LE=log(E+eye(3));

%Elastic Material calculation
E6=[E(1,1) E(2,2) E(3,3) E(2,3) E(1,3) E(1,2)]';
C=[lam+2*G lam lam 0 0 0; lam lam+2*G lam 0 0 0; lam lam lam+2*G 0 0 0; 0 0 0 G 0 0; 0 0 0 0 G 0; 0 0 0 0 0 G];
S6=C*E6;
Cauchy = [S6(1) S6(6) S6(5); S6(6) S6(2) S6(4); S6(5) S6(4) S6(3)]


S=(1/EE)*[1 -nu -nu 0 0 0; -nu 1 -nu 0 0 0; -nu -nu 1 0 0 0; 0 0 0 2+2*nu 0 0; 0 0 0 0 2+2*nu 0; 0 0 0 0 0 2+2*nu];
eps=S*[-2.04E-4 7.84E9 -2.04E-4 0 0 0]'

sigma = C*eps