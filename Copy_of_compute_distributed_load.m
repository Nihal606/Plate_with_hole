%External Force Vector - this has to be computed for point load and
% distributed load

filename = 'Boundary_elements.txt'; % Replace with your file name
fid = fopen(filename, 'r'); % Open the file in read mode
data = textscan(fid, '%s', 'Delimiter', '\n'); % Read the file into a cell array
fclose(fid); % Close the file

nele_surface_load = numel(data{1}); % Count the number of lines

%nele_surface_load  = nx; % no. of elements subjected to traction

%{
for i=1:nele_surface_load
    ele_load_face(i,:) = [i*nx 2] ; %storing the element no. and their corresponding
    %faces subected to traction
end
%}
con_mat_surface=zeros(nele_surface_load,5);
filename='Boundary_elements.txt';
fid=fopen(filename,'r');
for i=1:nele_surface_load
    con_mat_surface(i,:)=fscanf(fid,"%d\t%d\t%d\t%d\t%d\n",[1 5]);
end
fclose(fid);
for i=1:nele_surface_load
    for j=2:5
        if abs(Xn(j,1)-Lx) <= eps || abs(Xn(j,2)-Ly) <= eps
            
ele_load_face = zeros(nele_surface_load ,2) ;
face_con = [1 2 ; 2 3 ; 3 4 ; 4 1]; % face connectivity (fixed for every element)
%ele_load_face % first column = element no. ; second column = face no.

F_ext = zeros(ndof,1) ;
%% loop over the no. of elements subjected to traction
for i = 1:nele_surface_load
    element_no = ele_load_face(i,1) ;
    eleface = ele_load_face(i,2);
    local_con_face = face_con(eleface,:);
    global_con_face = CON(element_no,local_con_face);
    ig_1 = 2*global_con_face ;
    ie_global = [ig_1(1)-1 ig_1(1) ig_1(2)-1 ig_1(2)]; %global dofs of edges subjected to traction
    ele_force_vector = zeros(4,1); % elemental force vecotr
    if i <= nx/2
        t = [1 ; 0] ; %traction in x direction
    elseif i > nx/2
        t = [0 ; 0] ; %traction in y direction
    end
    % gauss points loop to calculate elemental load vector
    for gp = 1:ngps
        xi = xigs(gp,1) ; wg = xigs(gp,2) ;
        N1 = (1-xi)/2 ; N2 = (1+xi)/2 ;
        N = [N1*I2 N2*I2] ;
        Jac = 0.5*((Xn(global_con_face(1),2)-Xn(global_con_face(2),2))^2 + (Xn(global_con_face(1),1)-Xn(global_con_face(2),1))^2)^0.5 ;
        ele_force_vector = ele_force_vector + N'*t*Jac*wg ;
    end
    F_ext(ie_global) = F_ext(ie_global) + ele_force_vector ;

end
