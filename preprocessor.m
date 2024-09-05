

% Normalization Parameters
Lo = 1 ;  % Length
Eo = 1 ; % Youngs Modulous
To = 1 ;  % Time

filename = 'Input/normalization_parameters.txt' ;
fidNP = fopen(filename,'w') ;
fprintf(fidNP,'%25.15f \t %25.15f  \t %25.15f ',Lo,Eo,To);
fclose(fidNP);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Fix the origin of the problem

Xo = 0   ; 
Yo = 0   ;

filename = 'Input/origin.txt' ;
fid = fopen(filename,'w') ;
fprintf(fid,'%20.15f \t %20.15f',Xo,Yo);
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Dimension of the geometry; Here it is a plate
% 
% Lx = Length of the plate in the x direction
% Ly = Length of the plate in y direction
% thickness_of_beam = this is thickness of the plate in the z direction.
% Note that this has to be changed for plane stress cases 

Lx = 1.5 ;
Ly = 1.25 ;

thickness_of_plate =  1 ; % for plane strain thickness is set to 1.

filename = 'Input/geometric_data.txt' ;
fid = fopen(filename,'w') ;
fprintf(fid,'%20.15f \t %20.15f  \t %20.15f',Lx,Ly,thickness_of_plate);
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Material properties of the plate
%
% E = Young's modulus of the plate
% nu = Poissions ratio of the plate

Eo = 210e09 ;
nu = 0.3 ;

%
% option_type_2D --> plane strain
%
% option_type_2D --> plane strain

option_type_2D = 1 ;

get_material_data

filename = 'Input/material_data.txt' ;
fid = fopen(filename,'w') ;
fprintf(fid,'%20.15f \t %20.15f \t %g',Eo,nu,option_type_2D);
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Finite element data

get_connectivity_coordinate_data

% Displacement rearragement arrays - this is needed at the end when the
% displacement is added to the current coordinates to get the deformed
% coordinates
i1 = zeros(nno,1) ; i2 = zeros(nno,1) ;
for i = 1:nno
    i1(i) = 2*i-1 ; % x dof of all the nodes
    i2(i) = 2*i ; % y dofs of all the nodes
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get the essential boundary condition array
%

get_boundary_conditon_data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%

% Homework: Code yourself for distributed load


% Body Forces - these take care of gravity load.
ldv = 1 ; % Flag to enable gravity load
g = [0 ; 0] ; % specify acc due to gravity value with direction here.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial displacements. U is total displacement whereas DU is incremental
% displacement
U = zeros(ndof,1) ; DU = zeros(ndof,1) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quadature parameters for volume intergation
jgaus = 2 ; fequad ; xigv = xig2 ; ngpv = jgaus^2 ; 

% Quadature parameters for surface intergation. This is needed when the
% surface integrals in cases like UDL are required.
jgaus = 5 ; fequad ; xigs = xig1 ; ngps = jgaus ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Call the function to find the size of arrays needed for parallel
% computing so that code can be used for meshes with extremely large number of
% elements.

parallel_computing_array


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Factor by which the displacement must be multiplied to get a visible
% deformed geometry at the end of the deformation process
factor = 1e6 ;

filename = 'Input/factor.txt' ;
fid = fopen(filename,'w') ;
fprintf(fid,'%g',factor);
fclose(fid);

% Initialize the total time of the analysis (only for dynamic problems)
ttime = 0 ;

 % FLag for error catching. 0 means no error. It will be set to nonzero 
 % value in case an error is detected
jterm = 0 ;


% Computation Options
jinfo = 2 ;
jcomp = 1 ;
