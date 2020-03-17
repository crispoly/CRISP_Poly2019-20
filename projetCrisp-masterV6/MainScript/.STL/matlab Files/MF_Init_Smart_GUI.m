%==========================================================================
% >>>>>>>>>>>>>>>>> FUNCTION MF-1: INITIALISE SMART GUI <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will load the joints trajectory from History
% and animate it in the Animation window by rotating the LD matrices that
% contain the vertices and patches got from SF_Importing_CAD. The rotation
% is made using the Transform matrix; the animation will have fps frames
% per second (From Settings). Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Init_Smart_GUI(hObject, eventdata, handles, varargin)

clc                     %Clear Command Window    
% close all;              %Close all opened figures

%% Loading and defining variables
MF_Load_Structures();   %Load structures to base workspace
S = evalin('base', 'S');   %Load Settings from base workspace
AS = evalin('base', 'AS');   %Load Additional Settings from base workspace

%% %Atributing values to pop-up menus
% >>>> Tab 2: Commands
joints_list = {}; T_list = {};
n = S.value{'dof'};
for i = 1:n
    joints_list = [joints_list, num2str(i)]; 
    T_list = [T_list, ['T_0_', num2str(i)]];
end
set(handles.jointn_menu, 'String', joints_list);
set(handles.joint_param_eq_menu, 'String', joints_list);
set(handles.transformation_options, 'String', T_list);
set(handles.transformation_options, 'Value', n);

% >>>> Tab 3: Programs
cmd_list = AS.commands;
traj_opts = AS.traj_opts;


set(handles.program_cmd_opts, 'String', cmd_list);
set(handles.program_traj_opts, 'String', traj_opts);


% >>>> Tab 4: Dynamics Simulation
set(handles.sim_joint, 'String', joints_list);

% >>>> Context Menu: Tools
set(handles.display_cg, 'Checked', 'off');
set(handles.disp_ref_frames, 'Checked', 'off');
set(handles.disp_link_frame, 'Checked', 'off');
   


%%
screen_size = get( groot, 'Screensize' );
FIG = handles.smart_gui_fig;
FIG_SIZE = screen_size(4)/864.*[0 0 155 58];
% FIG_SIZE = screen_size(4)/864.*[0 0 330 55];
set(FIG, 'Units', 'characters', 'Position', FIG_SIZE);
movegui('northwest');   %Move GUI to northwest of the screen on opening.

%TAB FUNCTION
%Create tab group
painel_dim = get(handles.P1,'position');
fig_pos = get(FIG, 'position');
menu_comp = 1;  %Height compensation for menus
painel_pos = ceil([5,fig_pos(4)-painel_dim(4)-menu_comp, painel_dim(3), painel_dim(4)+menu_comp]);
painel_unit = get(handles.P1, 'Units');
handles.tgroup = uitabgroup('Parent', handles.smart_gui_fig, 'Units', painel_unit, ...
    'TabLocation', 'top','Position',painel_pos);

handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'SETTINGS');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'COMMANDS');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'PROGRAMS');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'DYNAMIC SIMULATION');

%Place panels into each tab
set(handles.P1,'Parent',handles.tab1);
set(handles.P2,'Parent',handles.tab2);
set(handles.P3,'Parent',handles.tab3);
set(handles.P4,'Parent',handles.tab4);

%Reposition each panel to same location of panel 1
P_pos = [0, 0, painel_dim(3), painel_dim(4)];

PF_pos = get(handles.PF, 'position');
PF_pos(1:3) = [painel_pos(1), fig_pos(4)-painel_pos(4)-PF_pos(4)-1, painel_dim(3)];
set(handles.P1, 'Units', painel_unit, 'position', P_pos);
set(handles.P2, 'Units', painel_unit, 'position', P_pos);
set(handles.P3, 'Units', painel_unit, 'position', P_pos);
set(handles.P4, 'Units', painel_unit, 'position', P_pos);
set(handles.PF, 'Units', painel_unit, 'position', PF_pos);

%Placing Logo
logo_pos = get(handles.logo, 'position');
% logo_pos(1:2) = [fig_pos(3)-logo_pos(3)-5, 0];
set(handles.logo, 'Units', painel_unit, 'position', logo_pos);
%Insert the figure UoD_Crest as the logo 
axes(handles.logo);
imshow('Logo.png');

% Enable handles items in Commands tab depending on the Trajectory Option
MF_Enable_Commands(hObject, handles);

%Load Settings table
MF_Load_Settings_table();

% Create Robot Representation GUI (for displaying simulation)
MF_Creating_RR_GUI();
MF_Update_UI_Controls();            %Update sliders and static texts
MF_Update_Message(10, 'notice');    %Show message about software status

end
