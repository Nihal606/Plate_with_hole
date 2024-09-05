%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                 INDIAN INSTITUTE OF TECHNOLOGY GUWAHATI                 %
%                  DEPARTMENT OF MECHANICAL ENGINEERING                   %
%                                                                         %
%                          2022-23 2ND SEMESTER                           %
%                                                                         %
%               ME 682 - NONLINEAR FINITE ELEMENT METHODS                 %
%                                                                         %
%                                                                         %
% Code initially developed by: Sachin Singh Gautam                        %
%                                                                         %
%                                                                         %
% Project 1: Due date 31.03.2023, Friday, 5 PM                            %
%                                                                         %
% The code is written for solving a finding the displacement, strains and % 
% stresses for a cantilever beam subjected to point load as shown below   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize
I2 = eye(2) ; 
ksp = zeros(nksz,1) ; ndoel = ndoelo ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                    Bulk Element Loop                                   %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kel_dummy = zeros(ndoel,ndoel,nel) ; rel_dummy = zeros(ndoel,nel) ;
jtermu = zeros(nel,1) ;
parfor i = 1:nel   % Run the loop over elements

   kel = zeros(ndoel,ndoel) ; rel = zeros(ndoel,1) ; 

   [kel, rel, ie, jtermue] = get_element_stiffness_right_side_vector(...
       2*CON(i,:),ndoel,Xn(CON(i,:),:),xn(CON(i,:),:),U,ngpv,xigv,I2,D) ; 

    kel_dummy(:,:,i) = kel ; 
    rel_dummy(:,i) = rel ; % This is external laod vector due to distributed load.
    jtermu(i,1) = jtermue ; % Store error flag
end

compute_distributed_load

for i = 1:nel   
   con = 2*CON(i,:) ;
   ie = [con(1)-1 con(1) con(2)-1 con(2) con(3)-1 con(3) con(4)-1 con(4)] ;
   F_ext(ie,1) = F_ext(ie,1) + rel_dummy(:,i) ;
end

for i = 1:nel
  for j = 1:ndoel
   ksp(cspa_global(j,i):csp_global(j,i))  = kel_dummy(:,j,i) ;
  end
end

clear kel_dummy ;
clear rel_dummy ;

% Check if there was any error in the element loop then kindly throw the
% error message
if jterm == 0
    if sum(jtermu(:,1)) > 0
        jterm = 1 ;
        fprintf('\n\n Error in computation in element loop ..... exiting the newton iteration loop ...') ;
%             fprintf(fipf,'\n\n Error in computation in element loop ..... exiting the newton iteration loop ...') ; 
%             break ;        
    end
end

% Sparse Stiffness Matrix
K = sparse(isp,jsp,ksp) ;

clear ksp ;

% Apply external point load 
%F_ext(dof_point_load,1) = -F_tip ;

% Eliminate Constraints in K and R due to BC and Condensation
Kr = K(ir,ir) ;
fr = F_ext(ir,1) ;

clear K ; clear f ;
   
% Get the sparse format K
Kr     = sparse(Kr) ;
  
% Solve for incremental displacement
DUr    =  Kr \ fr ;
   
clear Kr ;
   
DU     = zeros(ndof,1) ; % DU is the iterative displacement
DU(ir) = DUr ;  
U      = U + DU ; % Add incremental displacement to  previous displacement 
                  %to get the current total displacement
   
 % Current configuration
Ux = [ U(i1) U(i2) ] ; % Rearragne the displacement in the same form as coordinate array
xn = Xn + Ux(:,1:2) ;