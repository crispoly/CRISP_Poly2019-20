%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SPF-1: IMPORT CAD TO MAT <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will convert the cad robot file (saved in STL)
% in a MAT file called ROBOT_DATA that will be used to generate the
% graphical representation of the robotic arm and perform the simulations.
% Each link should be saved in a different stl file. For a 6dof robot with
% end effector, there should be 7 files: base.stl, link1.stl,
% link2.stl,..., link5.stl, end_effector.stl (user must enable end-effector
% in Settings. The files should be inserted in the directory OTHER_FILES).
% Refer to section 6.4 for details.
%==========================================================================
function SPF_Importing_CAD()
% n: robot degrees of freedom (number of joints)
% end_effector: 1 for robots with end_effector, 0 without end_effector
 Settings_path = which('SETTINGS.mat');
 Robots_data_path = which('ROBOT_DATA.mat');
 
 load(Settings_path);
 R_data = matfile(Robots_data_path,'Writable',true);  %load as matfile
 R_info = R_data.RP; %load the table that contains the D-H parameters
 
 n_links = S.value{'dof'} - 1; %number of links = number of dof - 1
 end_effector = true;%S.value{2}; %true for robot w/ end-effector, false otherwise
 d = R_info.d';     %get parameter d from L structure (ROBOT_DATA)
 a = R_info.a';     %get parameter a
 Alpha = R_info.alpha';  %get parameter alpha
 
 
%Generating the names for accessing the files
extension = '.stl';
file = {'base', 'link', 'end_effector'};

% Assembling the components names
for i=1:n_links 
        filenames(i) = strcat(file(2), num2str(i), extension);
end
filenames(n_links+1)  = strcat(file(1), extension); %adding the base name
if end_effector==1
    filenames(n_links+2)  = strcat(file(3), extension); %adding the end-effector name
end

% %prompt the user to select the stl files
% [filename, folder] = uigetfile('*', 'MultiSelect','on');
% fname = fullfile(folder, filename); 
%     %#release in future version: open window to select the stl files and
%     then create a figure with a table so then the user can inform the
%     program which of the file is base, link and end-effector


% Field names in L structure, Ve: Vertice, Fa: Faces, Co: Colors
% (Ve, Fa, Co) are used in patch command for drawing the robot 
structure_names = {'Ve', 'Fa', 'Co'};

for x = 1:1:length(filenames)
    file_name = char(filenames(x));
    LD(x) = rndread(file_name, structure_names);
end

% In order to simulate the movement each link must have its frame placed in
% the reference frame (global 0), so then the Forward Kinematics will
% transform to the position it needs to go. But for facilitate the
% conversion the user will load the robot as it is assembled, so an inverse
% transform must be applyed to each link (make each link frame go to 
% global 0)

theta = zeros(1, n_links+2);  %The robot is considered in zero configuration

%Only the vertices need to be transformed (the faces remain the same)
    for j = 1:n_links %number of links (dof-1)
        [~, T_m] = PF_Forward_Kinematics(theta(1:j), d(1:j), a(1:j),...
                                                              Alpha(1:j));
                                                          
        LD(j).Ve = (inv(T_m{j}) * LD(j).Ve')';
    end
    
    if end_effector==1
%         In LD the end-effector is the immediate file after the base (last
%         row in LD structure)
        ee_n = size(filenames,2);
        [~, T_m] = PF_Forward_Kinematics(theta(1:ee_n), d(1:ee_n),...
                                        a(1:ee_n), Alpha(1:ee_n));
                                    
        LD(ee_n).Ve = (inv(T_m{ee_n}) * LD(ee_n).Ve')';
    end 

    
% figure
% ax_size = 1350;
% axis([-ax_size/5 ax_size -ax_size/2 ax_size/2 -0 ax_size/3]);
% view(135,25) %Adjust the view orientation.
% hold on;
% grid('on');
% light 
% 
% for i=1:length(filenames)
% AAA{i} = patch('faces', LD(i).Fa, 'vertices', LD(i).Ve(:,1:3));
%     set(AAA{i}, 'facec', [.8,.8,.8]);% set base color and draw
%     set(AAA{i}, 'EdgeColor','none');% set edge color to none   
%     input('Press a key to continue');
%     try
%         children = get(gca, 'children');
%         delete(children);
%     end
%     
% end

    
    
    
save('ROBOT_DATA', 'LD', '-append');
disp('CAD files converted successfully');
end

function [STRUCTURE] = rndread(filename, struc_name)
% Reads CAD STL ASCII files, which most CAD programs can export.
% Used to create Matlab patches of CAD 3D data.
% Returns a vertex list and face list, for Matlab patch command.


fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1 
    filename
    error('File could not be opened, check name or path.')
    
end

% The first line is object name, then comes multiple facet and vertex lines.
% A color specifier is next, followed by those faces of that color, until
% next color line.
%
CAD_object_name = sscanf(fgetl(fid), '%*s %s');  %CAD object name, if needed.
%                                                %Some STLs have it, some don't.   
vnum=0;       %Vertex number counter.
report_num=0; %Report the status as we go.
VColor = 1;
%
while feof(fid) == 0                    % test for end of file, if not then do stuff
    tline = fgetl(fid);                 % reads a line of data from file.
    fword = sscanf(tline, '%s ');       % make the line a character string
% Check for color
    if strncmpi(fword, 'c',1) == 1;    % Checking if a "C"olor line, as "C" is 1st char.
       VColor = sscanf(tline, '%*s %f %f %f'); % & if a C, get the RGB color data of the face.
    end                                % Keep this color, until the next color is used.
    if strncmpi(fword, 'v',1) == 1;    % Checking if a "V"ertex line, as "V" is 1st char.
       vnum = vnum + 1;                % If a V we count the # of V's
       report_num = report_num + 1;    % Report a counter, so long files show status
       if report_num > 249;
           disp(sprintf('Reading vertix num: %d.',vnum));
           report_num = 0;
       end
       v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & if a V, get the XYZ data of it.    
       c(:,vnum) = VColor;              % A color for each vertex, which will color the faces.
    end                                 % we "*s" skip the name "color" and get the data.                                          
end
%   Build face list; The vertices are in order, so just number them.
%
fnum = vnum/3;      %Number of faces, vnum is number of vertices.  STL is triangles.
flist = 1:vnum;     %Face list of vertices, all in order.
F = reshape(flist, 3,fnum); %Make a "3 by fnum" matrix of face list data.

F = F';
V = v';
V(:,4) = 1;         %let the same number of columns for future 
C = c';                          %multiplication with the transform matrix

s = {V, F, C};
STRUCTURE = cell2struct(s, struc_name, 2);

fclose(fid);
end