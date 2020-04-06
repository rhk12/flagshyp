function [le] =calc_element_size(PRO,FEM,GEOM,CON,BC,GLOBAL,MAT,x,ielement)

global_nodes    = FEM.mesh.connectivity(:,ielement);
xlocal          = GEOM.x(:,global_nodes) ;


if (FEM.mesh.element_type == 'hexa8')
    % examine each each edge of hex 
    % there are 12 edges in a hex...
    % examine bottom face...
    %set large number
    bdist = 1e20;
    for (i = 1:4)
        if(i<4)
            n1 = i;
            n2 = i+1;
        elseif(i == 4)
            n1 = 4;
            n2 = 1;
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        bdist1=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 );
        if(bdist1<bdist)
            bdist = bdist1;
        end
    end
    bdist;
    
    % examine top face...
    %set large number
    tdist = 1e20;
    for (i = 5:8)
        if(i<8)
            n1 = i;
            n2 = i+1;
        elseif(i == 8)
            n1 = 4;
            n2 = 1;
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        tdist1=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 ) ; 
        if(tdist1<tdist)
            tdist = tdist1;
        end
    end 
    tdist;
    
    % need to add face lengths: face1, face2, face3, face4
    % 
    % face1 element connectivity nodes:  {2, 3, 7, 6} 
    distf1 = 1e20;
    for (i = 1:4)
        if (i == 1)     n1 = 2; n2 = 3; 
        elseif (i == 2) n1 = 3; n2 = 7; 
        elseif (i == 3) n1 = 7; n2 = 6;
        elseif (i == 4) n1 = 6; n2 = 2;  
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        distf1s=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 ) ; 
        if(distf1s<distf1)
            distf1 = distf1s;
        end
    end
    distf1;
    
    
    % face2 element connectivity nodes:  {3, 4, 8, 7} 
    distf2 = 1e20;
    for (i = 1:4)
        if (i == 1)     n1 = 3; n2 = 4; 
        elseif (i == 2) n1 = 4; n2 = 8; 
        elseif (i == 3) n1 = 8; n2 = 7;
        elseif (i == 4) n1 = 7; n2 = 3;  
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        distf2s=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 ) ; 
        if(distf2s<distf2)
            distf2 = distf2s;
        end
    end
    distf2   ; 
    
    % face3 element connectivity nodes:  {4, 1, 5, 8} 
    distf3 = 1e20;
    for (i = 1:4)
        if (i == 1)     n1 = 4; n2 = 1; 
        elseif (i == 2) n1 = 1; n2 = 5; 
        elseif (i == 3) n1 = 5; n2 = 8;
        elseif (i == 4) n1 = 8; n2 = 1;  
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        distf3s=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 ) ; 
        if(distf3s<distf3)
            distf3 = distf3s;
        end
    end
    distf3  ;   
    
    % face4 element connectivity nodes:  {1, 2, 6, 5} 
    distf4 = 1e20;
    for (i = 1:4)
        if (i == 1)     n1 = 1; n2 = 2; 
        elseif (i == 2) n1 = 2; n2 = 6; 
        elseif (i == 3) n1 = 6; n2 = 5;
        elseif (i == 4) n1 = 5; n2 = 1;  
        end
        %xlocal(:,1)
        x1l=xlocal(1,n1); y1l=xlocal(2,n1); z1l=xlocal(3,n1);
        %xlocal(:,2)
        x2l=xlocal(1,n2); y2l=xlocal(2,n2); z2l=xlocal(3,n2);
        distf4s=sqrt( (x2l-x1l)^2 + (y2l-y1l)^2 + (z2l-z1l)^2 ) ; 
        if(distf4s<distf4)
            distf4 = distf4s;
        end
    end
    distf4 ;
    
    numbers = [bdist,tdist,distf1,distf2,distf3,distf4];
    le = min(numbers);
    
else
   % error not yet programmed ....
   %disp ('From SolutionEquations/CalculateElementSize.m: ')
   %disp ('element type size calculation is not yet programmed... ')
   
end


end