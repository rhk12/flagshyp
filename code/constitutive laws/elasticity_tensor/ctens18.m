% Evaluate the deviatoric Mooney-Rivlin elasticty tensor: Material typ 18
function c=ctens18(kinematics,properties,cons,dimension)
mu1= properties (2);
mu2=properties(3);
% ATTENTION: KINEMATICS ARE IN TERMS OF THE FULL TENSORS NOT ONLY THE
% DEVIATORIC PARS
% This tensor is (delta(i,j)*delta(kl))
c1=cons.IDENTITY_TENSORS.c1;
% This tensor is (delta(i,k)*delta(j,l)+delta(i,l)*delta(k,j))
c2=cons.IDENTITY_TENSORS.c2;

J=kinematics.J;
b=kinematics.b;
b2=b*b; % This is the matrix product b*b, not the term-wise square

% Trace of b
Ib=kinematics.Ib;

I2_b=1./2.*(Ib*Ib-kinematics.trb2);




% Initialize variables
c_part1=zeros(dimension,dimension,dimension,dimension);
c_part2=zeros(dimension,dimension,dimension,dimension);
c_part3=zeros(dimension,dimension,dimension,dimension);

for i=1:dimension
    for j=1:dimension
        for k=1:dimension
            for l=1:dimension
                
                % Term in  Bxb - (i:B)xB
                c_part1(i,j,k,l)= 2.*mu2*J^(-2./3.)*(b(i,j)*b(k,l)-1./2.*(b(i,k)*b(j,l)+b(i,l)*b(j,k)));
                
                
                
                %Term in  B xI + I x B
                c_part2(i,j,k,l)=  -2./3. *(mu1+2*mu2*J^(-2./3.)*Ib) *(b(i,j)*cons.I(k,l)+b(k,l)*cons.I(i,j));
                
                %Term in B2 x I + I x B
                c_part3(i,j,k,l)= +4./3.*mu2*J^(-2./3.)*(b2(i,j) * cons.I(k,l) + b2(k,l) * cons.I(i,j));
                
                
            end
            
        end
    end
    
end

% Term which is proportional to delta(i,j)*delta(kl)
c_part4= 2./9.*(mu1*Ib+4*mu2*J^(-2./3.)*I2_b)*c1;

c_part5= 1./3.*(mu1*Ib+2*mu2*J^(-2./3.)*I2_b)*c2;
% Final isochoric tensor

c=J^(-5./3.)*(c_part1+c_part2+c_part3+c_part4+ c_part5);
return; 

