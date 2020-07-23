clear; clc;
xembed=[0 0 0;1 0 0 ;0 1 0;1 1 0;0 0 1;1 0 1 ;0 1 1;1 1 1;0 0 0.4; 1 0 0.4; 0 1 0.4; 1 1 0.4; 0 0 0.6; 1 0 0.6; 0 1 0.6; 1 1 0.6];
xnodes=[0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 1 1]';
for i=1:16
   Z=find_natural_coords(xembed(i,:),xnodes,'hex');
   XX=CheckShapeFunctions(Z,xnodes);
   
   fprintf("node %i\n XX=[%d %d %d]  Z = [%d %d %d] XXcalc = [%d %d %d]\n", ...
        i, xembed(i,1), xembed(i,2), xembed(i,3), Z(1), Z(2), Z(3), XX(1), XX(2), XX(3));  
end