%External Force Vector - this has to be computed for point load and
% distributed load
bc_node_lx = [] ;
bc_node_ly = [] ;

number_of_nodes_with_xtraction =  0 ;
number_of_nodes_with_ytraction =  0 ;
F_ext = zeros(ndof,1) ;

for i = 1:nno
    if abs(Xn(i,1)-Lx) <= eps % if x coordinate is zero
        bc_node_lx = [bc_node_lx ; i];
        number_of_nodes_with_xtraction = number_of_nodes_with_xtraction + 1 ;
    end
end
t_x=20e6;
t_y=40e6;

for i=1:number_of_nodes_with_xtraction
    F_ext(2*bc_node_lx(i)-1)=t_x*Ly/(number_of_nodes_with_xtraction-1);
    F_ext(2*bc_node_lx(i))=0;
end
F_ext(2*bc_node_lx(1)-1)=t_x*Ly/(number_of_nodes_with_xtraction-1)/2;
F_ext(2*bc_node_lx(end)-1)=t_x*Ly/(number_of_nodes_with_xtraction-1)/2;

for i = 1:nno
    if abs(Xn(i,2)-Ly) <= eps  % if y coordinate is zero
        bc_node_ly = [bc_node_ly ; i];
        number_of_nodes_with_ytraction = number_of_nodes_with_ytraction + 1 ;
    end
end
for i=1:number_of_nodes_with_ytraction
    F_ext(2*bc_node_ly(i))=t_y*Lx/(number_of_nodes_with_ytraction-1);
    if  ~ismember(bc_node_ly(i),bc_node_lx)
         F_ext(2*bc_node_ly(i)-1)=0; 
    end
end
F_ext(2*bc_node_ly(1))=t_y*Lx/(number_of_nodes_with_ytraction-1)/2;
F_ext(2*bc_node_lx(end))=t_y*Lx/(number_of_nodes_with_ytraction-1)/2;
