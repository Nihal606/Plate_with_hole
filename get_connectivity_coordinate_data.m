

% Number of elements in y direction
%ny = 1  ;

% Number of elements in x direction
%nx = 10*ny ; % <--- change this for your own problem
%ny = 30 ;
% 
% % Number of elements in x direction
%nx = 20; % <--- change this for your own problem
% 
% % Number of Elements
%nel = nx*ny ;
% 
% % Number of Nodes
%nno = (nx+1)*(ny+1) ;
% Number of Elements
%nel = 89 ;
filename = 'Platewithholeconnectivity.txt'; % Replace with your file name
fid = fopen(filename, 'r'); % Open the file in read mode
data = textscan(fid, '%s', 'Delimiter', '\n'); % Read the file into a cell array
fclose(fid); % Close the file

nel = numel(data{1}); % Count the number of lines

disp(['Number of elements: ', num2str(nel)]);

filename = 'Platewithholenodescordinate.txt'; % Replace with your file name
fid = fopen(filename, 'r'); % Open the file in read mode
data = textscan(fid, '%s', 'Delimiter', '\n'); % Read the file into a cell array
fclose(fid); % Close the file

nno = numel(data{1}); % Count the number of lines

disp(['Number of nodes: ', num2str(nno)]);
% Number of Nodes
%nno = (nx+1)*(ny+1) ;
%nno=110;

% Number of dofs per element 
ndoel = 8 ;
 
% Number of dofs in the FE mesh, Number of dofs per element
ndof = 2*nno ; ndoelo = 8 ;

% Note that the below code works only for rectangular bodies. You can
% either write your own code or take input from comemrcial FE packages like
% ANSYS. In that case change the below code accordingly.

% Initial Node Coordinates
Xn = zeros(nno,2) ; % 2 dof per node i.e. x coordinate and y coordinate
filename='Platewithholenodescordinate.txt';
fid=fopen(filename,'r');
for i=1:nno
    Xn(i,:)=fscanf(fid,"%f\t%f\n",[1 2]);
end

fclose(fid);

CON = zeros(nel,4) ;
filename='Platewithholeconnectivity.txt';
fid=fopen(filename,'r');
for i=1:nel
    CON(i,:)=fscanf(fid,'%d\t%d\t%d\t%d\n',[1 4]);
end
fclose(fid);

% Current node coordinates initialized as initial coordinates to start
% with.
xn = Xn ; % Xn contains the coordinates of the reference configuration all the time
          % xn contains the coordinates of the current configuration all
          % the time
