clear; clc;
mu=76.92e9 
lam=115.4e9
E=mu*(3*lam+2*mu)/(lam+mu)
nu=lam/(2*(lam+mu))
K=lam+(2*mu/3)
rho=7800

c=sqrt((lam+2*mu)/rho)

F=[0.9883 0 0; 0 1.04 0; 0 0 0.9883]
b=F*F'
J=det(F)
I1=trace(b)
LE=logm(F)
sigma = J^(-5/3)*mu*(b-(1/3)*I1*eye(3)) + K*(J-1)*eye(3)

(J^(-5/3)*mu*(b-(1/3)*I1*eye(3)))
(K*(J-1)*eye(3))