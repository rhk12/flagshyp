%--------------------------------------------------------------------------
% Computes and assemble lumped mass matrix
%--------------------------------------------------------------------------
function [GLOBAL,updated_PLAST] = mass_assembly(xlamb,...
          GEOM,MAT,FEM,GLOBAL,CONSTANT,QUADRATURE,PLAST,KINEMATICS)   
      
%number of dimensions
ndims = GEOM.ndime; 
massSize = ndims*GEOM.npoin;
AssembledMass = zeros(massSize,massSize);
LumpedMass = zeros(massSize,massSize);   
    
for ielement=1:FEM.mesh.nelem
    %----------------------------------------------------------------------
    % Temporary variables associated with a particular element.
    %----------------------------------------------------------------------
    global_nodes    = FEM.mesh.connectivity(:,ielement);   
    material_number = MAT.matno(ielement);     
    matyp           = MAT.matyp(material_number);        
    properties      = MAT.props(:,material_number); % needs density included.
    xlocal          = GEOM.x(:,global_nodes);                     
    x0local         = GEOM.x0(:,global_nodes); 
    Ve              = GEOM.Ve(ielement);
    
    N=FEM.interpolation.element.N ;
    DN_chi=FEM.interpolation.element.DN_chi  ;
    
    % assign density
    rho = properties(1);
    
    % quadrature locations
    QUADRATURE.Chi;
    % quadrature weights
    QUADRATURE.W;
   
   % bColSize = 8*ndims; %nshp functions * ndims
    bColSize = QUADRATURE.ngauss * ndims;
    %nColSize = 8 * ndims ;%nshp functions * ndims
    nColSize = QUADRATURE.ngauss * ndims;
    Nsize = nColSize * ndims;
    mLocalSize = bColSize*bColSize;
    %
    % unsure on the offical size of this 
    %Nm= zeros(3,24);
    Nm = zeros(ndims,nColSize);
    
    %elemental mass matrix 
    Me= zeros(bColSize,bColSize);

    for igauss=1:QUADRATURE.ngauss

         for n=1:QUADRATURE.ngauss % nshp functions
             index = (n-1)*3;             
             Nm(1,index+1)=N(n,igauss);
             Nm(2,index+2)=N(n,igauss);
             Nm(3,index+3)=N(n,igauss);
         end
      
        
        % compute N^T * * N
        MeGQ= Nm' * Nm;
        %----------------------------------------------------------------------
        % Derivative of shape functions with respect to ...
        % - initial coordinates.
        %----------------------------------------------------------------------
        DX_chi = x0local*DN_chi(:,:,igauss)';
        DN_X   = DX_chi'\DN_chi(:,:,igauss);
        prefactor = QUADRATURE.W(igauss) * abs(det(DX_chi));
    
        Me = Me + prefactor*MeGQ*rho;
    end
    
    %Me
    
  %move mass matrix from element level to global level
     for n=1:QUADRATURE.ngauss  % nshp functions
         g1Index=global_nodes(n)-1;
         %disp([global_nodes]')
         for m=1:ndims
             for l=1:QUADRATURE.ngauss %nshp functions
                 g2Index=global_nodes(l)-1;
                 for k=1:ndims
                     %g1Index*ndims+m;
                     %g2Index*ndims+k;
                     %Me((n-1)*ndims+m,(l-1)*ndims+k)
                     %(n-1)*ndims+m;
                     %mass(g1Index*ndims+m, g2Index*ndims+k) 
                     %disp([g1Index*ndims+m g2Index*ndims+k   ] ) 
                     %disp([(n-1)*ndims+m (l-1)*ndims+k ] ) 
                 
                     %disp([Me((n-1)*ndims+m,(l-1)*ndims+k)])
                     AssembledMass(g1Index*ndims+m, g2Index*ndims+k)= AssembledMass(g1Index*ndims+m, g2Index*ndims+k) + Me((n-1)*ndims+m,(l-1)*ndims+k);
                 end % loop on k
             end % loop on l
         end % loop on m 
     end % loop on n
    
end % loop on elements

%
%
% create lumped mass matrix by summing up along a row
for i =1:massSize
    for j=1:massSize
        %disp([i j])
          LumpedMass(j,j) = LumpedMass(j,j) + AssembledMass(i,j) ;
    end
end

GLOBAL.M=LumpedMass;

      
end

 


 
