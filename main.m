%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                                                                         %
% The code is written for solving a finding the displacement, strains and % 
% stresses for a plate with hole problem subjected to biaxial traction    %
%                                                                         %
%                                                                         %
%                                                                         % 
%                                                                         %
%                                                                         %
% A plate with circular hole(radius a) of length 2L width 2H and thickness% 
% t subjected to Biaxial traction . Youngs modulus is E and Poissions     %
% ratio nu.For finite element simulation the code used 4-noded quadrilateral
% element.
%                                                                         %
%                                                                         %       
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear the screen
clc;

% Clear all the variables from the workspace.
clear all ;

fclose('all');

%  The below file contains the instructions to set the input parameters
%  required for running the codes.

preprocessor

% The below file finds the elemental stiffness matrix, elemental external 
% force vector. Then it assembles the element matrices to get the global
% stifffness matrix and external force vector. Finally it solves for the
% displacement dU. Then it adds the displacement to undeformed coordinates
% Xn and obtains the deformed cooridnates xn.

solver

% file to save initial coordinates, deformed coocridnates, displacement and
% other specific outputs so desired in the Output/ folder.

fesave 

% The below file contains the function which plots the deformed and
% undeformed mesh. Also, on the defomred mesh you can also plot the
% contours of one of the following: 6 components of stress, 2 principal
% stresses, 3 invariants of stress, von Mises equivalent stress. You can
% yourself code get the contour of displacement which I have left for you.

 postprocessor






