%% ========================================================================
%**************************************************************************
%  >>>>>>>>>>>>>>>>>>>>>>>>>>>>> SMART GUI <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%**************************************************************************
%==========================================================================
%SOFTWARE FOR ARTICULATED ROBOTIC ARM SIMULATION
%AUTHOR: DIEGO VARALDA DE ALMEIDA.
%VERSION 2.0
%DATE: NOVEMBER 14nd OF 2015.
%==========================================================================
function varargout = SMART_GUI(varargin)
% clc; close all; clear variables;
% SMART_GUI MATLAB code for SMART_GUI.fig
%      SMART_GUI, by itself, creates a new SMART_GUI or raises the existing
%      singleton*.
%
%      H = SMART_GUI returns the handle to a new SMART_GUI or the handle to
%      the existing singleton*.
%
%      SMART_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMART_GUI.M with the given input arguments.
%
%      SMART_GUI('Property','Value',...) creates a new SMART_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SMART_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SMART_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SMART_GUI

% Last Modified by GUIDE v2.5 11-Jun-2016 01:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SMART_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SMART_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before SMART_GUI is made visible.
function SMART_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
%Add the directory where GUI is and all subfolders to the search path.
Dir = pwd;
addpath(genpath(Dir),'-frozen');
%'-frozen' disables Windows change notification

assignin('base', 'HD', handles);    %Save handles as HD in base workspace

%Configure Position of GUI form
MF_Init_Smart_GUI(hObject, eventdata, handles, varargin);

program_cmd_opts_Callback(handles);
% %Load Settings table
% MF_Load_Settings_table();

% Choose default command line output for SMART_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SMART_GUI wait for user response (see UIRESUME)
% uiwait(handles.smart_gui_fig);

% --- Outputs from this function are returned to the command line.
function varargout = SMART_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% MF_Update_UI_Controls();            %Update sliders and static texts
% % Create Robot Representation GUI (for displaying simulation)
% MF_Creating_RR_GUI();
% MF_Update_Message(10, 'notice');    %Show message about software status
%% ========================================================================
%**************************************************************************
%  >>>>>>>>>>>>>>>>>>> TERTIARY FUNCTIONS: CALLBACKS <<<<<<<<<<<<<<<<<<<<<<
%**************************************************************************
%========================================================================== 
%THE FUNCTIONS BELOW CONTROL THE ACTION OF EACH UI OBJECT.

%% ========================================================================
%  >>>>>>>>>>>>>>>>>>>>>>>>>>> TAB 1: SETTINGS <<<<<<<<<<<<<<<<<<<<<<<<<<<<
%========================================================================== 
%%  #ok
function settings_table_CellSelectionCallback(hObject, eventdata, handles)
indice = eventdata.Indices();
selec_row = double(indice(:,1)'); %Transpose of the indice matrix (Tranform 
                         %the first column of the indice matrix into a row)
if ~isempty(selec_row)
    MF_Update_Message(selec_row, 'settings');
end
%>>> END OF FUNCTION

function settings_table_CellEditCallback(hObject, eventdata, handles)

%%
function save_settings_bt_Callback(hObject, eventdata, handles)
settings_data = get(handles.settings_table, 'Data');
MF_Save_Settings(settings_data);
%>>> END OF FUNCTION

%%
function load_settings_bt_Callback(hObject, eventdata, handles)


%%
function reset_settings_bt_Callback(hObject, eventdata, handles)

%% #ok
function edit_robot_param_bt_Callback(hObject, eventdata, handles)
MF_Load_Robot_param_table();

%% #ok
function clear_history_bt_Callback(hObject, eventdata, handles)
MF_Clear_History();

%% ========================================================================
%  >>>>>>>>>>>>>>>>>>>>>>>>>>> TAB 2: COMMANDS <<<<<<<<<<<<<<<<<<<<<<<<<<<<
%========================================================================== 

function undock_bt_Callback(hObject, eventdata, handles)

%% #ok
function move_coord_Callback(hObject, eventdata, handles)
% Get the values from the edit box (X, Y and Z);
x_pos = round(str2num(get(handles.p_x, 'string')),3);
y_pos = round(str2num(get(handles.p_y, 'string')),3);
z_pos = round(str2num(get(handles.p_z, 'string')),3);
orient_angle = round(str2num(get(handles.orientation_angle, 'string')),3);
time = round(str2num(get(handles.time, 'String')), 3);
lv = round(str2num(get(handles.v_linear, 'String')), 3);
av = round(str2num(get(handles.v_angular, 'String')), 3);
% Check if the inputs are numbers
if (isempty(x_pos) || isempty(y_pos)||isempty(z_pos)||isempty(orient_angle))
                                                        
    MF_Update_Message(19, 'warnings');
    return
end

if isempty(time) && isempty(lv) && isempty(av)
    MF_Update_Message(23, 'warnings');
    return
end

% Check if the number of inputs are the same for x, y and z
if any(size(x_pos) ~= size(y_pos)) || any(size(x_pos) ~= size(z_pos)) || ...
                                           any(size(y_pos) ~= size(z_pos))
	MF_Update_Message(20, 'warnings');
    return
end

% Assembling pos matrix in case of more than 1 position
pos = [];
for i = 1:length(x_pos)
    pos = [pos; [x_pos(i), y_pos(i), z_pos(i), orient_angle(i, :)]];
end

% Asembling inputs structure (In)
In.trajopt = get(handles.traj_opt, 'Value');
In.time = time;
In.space = 'cart'; %cartesian space 
In.pos = pos;
In.lv = lv;
In.av = av;

% Call secondary function
SF_Move_EE_to_Pos(In);
%>>> END OF FUNCTION

function slider_jointn_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% #ok
function move_ee_neg_x_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [-1 0 0];  %increment only in X (negative).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));

if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function move_ee_pos_x_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [1 0 0];  %increment only in X (positive).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));
if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function move_ee_neg_y_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [0 -1 0];  %increment only in Y (negative).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));

if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function move_ee_pos_y_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [0 1 0];  %increment only in Y (positive).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));

if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function move_ee_neg_z_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [0 0 -1];  %increment only in Z (negative).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));

if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function move_ee_pos_z_Callback(hObject, eventdata, handles)
% Get the increment option (coarse, fine)
coarse = get(handles.coarse_rb,'Value');
fine = get(handles.fine_rb,'Value');
% Assemble the inputs (In)
if coarse ==1 && fine == 0
    In.inc_opt = 'coarse';
else
    In.inc_opt = 'fine';
end
In.space = 'cart';  %cartesian space
In.axes = [0 0 1];  %increment only in Z (positive).
In.trajopt = get(handles.traj_opt, 'Value');
In.lv = str2num(get(handles.v_linear, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.time = str2num(get(handles.time, 'String'));

if isempty(In.time) && isempty(In.av) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end

SF_Move_EE_by_Increment(In);
%>>> END OF FUNCTION

%% #ok
function slider_jointn_Callback(hObject, eventdata, handles)
In.trajopt = get(handles.traj_opt, 'Value');
In.joint = get(handles.jointn_menu, 'Value');
In.qt = get(handles.slider_jointn, 'Value');
In.time = str2num(get(handles.time, 'String'));
In.av = str2num(get(handles.v_angular, 'String'));
In.lv = str2num(get(handles.v_linear, 'String'));
SF_Move_Joints(In);

%% #ok
function move_joints_bt_Callback(hObject, eventdata, handles)
% Get the values from the edit box (Joints and A);
joints = round(str2num(get(handles.joints_move, 'String')),3);
qvalue = round(str2num(get(handles.angle_move_joints, 'string')),3);


% Check if the inputs are numbers
if isempty(joints) || isempty(qvalue)
    MF_Update_Message(19, 'warnings');
    return
end

% Check if the number of inputs are the same for joints and qvalue
if size(joints) ~= size(qvalue)
	MF_Update_Message(21, 'warnings');
    return
end


% Asembling inputs structure (In)
In.trajopt = get(handles.traj_opt, 'Value');
In.time = str2num(get(handles.time, 'String'));
In.joint = joints;
In.qt = qvalue;
In.av = str2num(get(handles.v_angular, 'String'));

% Call secondary function
SF_Move_Joints(In)
%>>> END OF FUNCTION

%% #ok
function go_param_joint_Callback(hObject, eventdata, handles)
% Get the values from the menu and text box (Joint and theta(t));
joint = get(handles.joint_param_eq_menu, 'Value');
pej = get(handles.param_joint_eq, 'string');

% Check if the inputs are numbers
if isempty(joint) || isempty(pej)
    MF_Update_Message(22, 'warnings');
    return
end

% Asembling inputs structure (In)
In.trajopt = get(handles.traj_opt, 'Value');
In.time = str2num(get(handles.time, 'String'));
In.joint = joint;
In.pej = pej;
In.space = 'joint';
In.av = str2num(get(handles.v_angular, 'String'));
In.lv = str2num(get(handles.v_linear, 'String'));
% Call secondary function
SF_Move_by_Parametric_Eq(In)
%>>> END OF FUNCTION

%% #ok
function go_param_traj_Callback(hObject, eventdata, handles)
% Get the values from the menu and text box (X(t), Y(t), Z(t))
pex = get(handles.x_param, 'string');
pey = get(handles.y_param, 'string');
pez = get(handles.z_param, 'string');

% Check if the fields are not blank
if isempty(pex) || isempty(pey) || isempty(pez)
    MF_Update_Message(22, 'warnings');
    return
end

% Asembling inputs structure (In)
In.trajopt = get(handles.traj_opt, 'Value');
In.time = str2num(get(handles.time, 'String'));
In.lv = str2num(get(handles.v_linear, 'String'));
In.pex = pex;
In.pey = pey;
In.pez = pez;
In.pos = zeros(1,6);    %for orientation
orient = str2num(get(handles.orientation_angle, 'String')); %get orientation
if ~isempty(orient)
    try
        In.pos(4:6) = orient;
    end
end
In.space = 'cart';

% Call secondary function
SF_Move_by_Parametric_Eq(In)
%>>> END OF FUNCTION

%% #ok
function load_path_Callback(hObject, eventdata, handles)
MF_Load_Table_Coord();

MF_Table_Coord_figure();

%>>> END OF FUNCTION

%% #ok
function start_path_Callback(hObject, eventdata, handles)
In.time = str2num(get(handles.time, 'String'));
In.lv = str2num(get(handles.v_linear, 'String'));
In.trajopt = get(handles.traj_opt, 'Value');
if isempty(In.time) && isempty(In.lv)
    MF_Update_Message(23, 'warnings');
    return
end
SF_Move_by_Table(In);

%%
function open_gripper_bt_Callback(hObject, eventdata, handles)
%FUNCTION DESCRIPTION:
        %1 - Get the default angle to close gripper;
        %2 - Get the speed for the gripper
        %2 - Call Function 4: Gripper Control

joint = 5;
handles.gripper_status = handles.gripper_status + 1;
%>>>1: Get the default angle to close gripper (Theta_World)
switch handles.gripper_status
    case 1 %Fully opened; set text for the next option
	set(hObject, 'String', 'Grab BB');
    joint_value = handles.gripper_fully_opened;
    case 2 %Grab Big Block; set text for the next option
        set(hObject, 'String', 'Grab SB');
        joint_value = handles.gripper_open_bb;
    case 3 %Grab Small Block; set text for the next option
        set(hObject, 'String', 'Open');
        joint_value = handles.gripper_open_sb;
        handles.gripper_status = 0; %Reset gripper button status
end

%>>>2: Get the speed_slider of the servo
joint_speed = handles.speed;

%>>>3: Call Function 4: Gripper Control;
function_variables = {joint_value, joint, joint_speed};
Gripper_Control(function_variables, eventdata, handles);

% Update handles structure
guidata(hObject, handles);
%>>> END OF FUNCTION

%%
function close_gripper_bt_Callback(hObject, eventdata, handles)
%FUNCTION DESCRIPTION:
        %1 - Get the default angle to close gripper;
        %2 - Get the speed for the gripper
        %2 - Call Function 4: Gripper Control

joint = 5;
%>>>1: Get the default angle to close gripper (Theta_World)
joint_value = handles.gripper_close;

%>>>2: Get the speed_slider of the servo
joint_speed = handles.speed;

%>>>3: Call Function 4: Gripper Control;
function_variables = {joint_value, joint, joint_speed};
Gripper_Control(function_variables, eventdata, handles);
%>>> END OF FUNCTION

%% #ok
function gripper_slider_Callback(hObject, eventdata, handles)
%>>>1: Get the joint angle;
gripper_value = round(get(hObject, 'Value'),1);

% Update the static text for angle;
set(handles.gripper_angle_value, 'String', gripper_value);

% Call Function Gripper Control;
In.qt = gripper_value;
SF_End_Effector_Control(In);
%>>> END OF FUNCTION

%% 
function gripper_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% #ok
function jointn_menu_Callback(hObject, eventdata, handles)
MF_Update_UI_Controls();    %update maximum and minimum values of slider

%% #ok
function transformation_options_Callback(hObject, eventdata, handles)
MF_Update_UI_Controls();    %update UI controls


%% #ok
function home_pos_Callback(hObject, eventdata, handles)
SF_Move_EE_to_Home();


%% #ok
function stop_robot_Callback(hObject, eventdata, handles)
MF_Update_Stop_status(true);

%%
function update_joints_Callback(hObject, eventdata, handles)
Update_Theta(eventdata, handles);

%% #ok
function cmd_random_bt_Callback(hObject, eventdata, handles)
SF_Random_Movement()

%% #ok
function clear_field_Callback(hObject, eventdata, handles)
set(handles.p_x, 'String', '');
set(handles.p_y, 'String', '');
set(handles.p_z, 'String', '');
set(handles.orientation_angle, 'String', '');
set(handles.time, 'String', '');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>>> END OF FUNCTION

%% ========================================================================
%  >>>>>>>>>>>>>>>>>>>>>>>>>>> TAB 3: PROGRAMS <<<<<<<<<<<<<<<<<<<<<<<<<<<<
%========================================================================== 
function program_cmd_opts_Callback(varargin)
if nargin == 3
    handles = varargin{3};
elseif nargin == 1
    handles = varargin{1};
end
%Get the selected command from the pop-up menu.
cmd_sel = get(handles.program_cmd_opts, 'Value');

handle_obj = {'inst_path_option_txt', 'program_traj_opts',...
'inst_save_grip_pos','inst_torque_cb','program_xpos_txt','program_pos_x',...
'program_ypos_txt','program_pos_y','program_zpos_txt','program_pos_z',...
'prg_orient_txt','prg_orient','inst_time_txt','inst_time','inst_joints_txt',...
'inst_joints','inst_A_txt','inst_A','prg_linvel_txt','prg_linvel',...
'prg_angvel_txt','prg_angvel','program_cn_txt','program_cn'};


cmd_enabled_field = {
    {};... %'Home Position'
    %'Move to Coordinate'
    {'inst_path_option_txt','program_traj_opts','program_xpos_txt',...
'program_pos_x', 'program_ypos_txt', 'program_pos_y','program_zpos_txt',...
'program_pos_z', 'prg_orient_txt', 'prg_orient','inst_time_txt',...
'inst_time', 'prg_linvel_txt', 'prg_linvel', 'prg_angvel_txt','prg_angvel'};... 
    
    %'Move by Increment'
    {'inst_path_option_txt','program_traj_opts','program_xpos_txt',...
'program_pos_x', 'program_ypos_txt', 'program_pos_y','program_zpos_txt',...
'program_pos_z', 'prg_orient_txt', 'prg_orient','inst_time_txt',...
'inst_time','prg_linvel_txt','prg_linvel','prg_angvel_txt','prg_angvel'};... 

    %'Move Joints'
    {'inst_path_option_txt','program_traj_opts', 'inst_time_txt',...
'inst_time','inst_joints_txt', 'inst_joints', 'inst_A_txt', 'inst_A',...
'prg_angvel_txt','prg_angvel'};...
    
    %'Parametric Cart. Traj.'
    {'inst_path_option_txt','program_traj_opts','program_xpos_txt',...
'program_pos_x', 'program_ypos_txt', 'program_pos_y','program_zpos_txt',...
'program_pos_z', 'prg_orient_txt', 'prg_orient','inst_time_txt',...
'inst_time', 'prg_linvel_txt', 'prg_linvel'};...

    %'Pametric Joint Traj.'
    {'inst_path_option_txt','program_traj_opts', 'inst_time_txt',...
'inst_time','inst_joints_txt', 'inst_joints', 'inst_A_txt', 'inst_A',...
'prg_angvel_txt','prg_angvel'};...

    %'Save actual Joints position'
    {'inst_path_option_txt','program_traj_opts', 'inst_time_txt',...
    'inst_time', 'prg_angvel_txt','prg_angvel'};...
    
    %'Load Table of Coordinates'
    {'inst_path_option_txt','program_traj_opts', 'inst_time_txt',...
    'inst_time', 'prg_linvel_txt', 'prg_linvel'};...
    
    %'Open Gripper'
    {'inst_path_option_txt','program_traj_opts', 'inst_A_txt', 'inst_A',...
    'inst_time_txt', 'inst_time', 'prg_angvel_txt','prg_angvel'};...
    
    %'Close Gripper'
    {'inst_path_option_txt','program_traj_opts', 'inst_time_txt',...
    'inst_time', 'prg_angvel_txt','prg_angvel'};...
    
    %'Add a Pause'
    {'inst_time_txt', 'inst_time'};...
    
    %'Repeat commands in History'
    {'program_cn_txt', 'program_cn'}};

cmd_trajopts = {
     %'Home Position'
     {''};
     %'Move to Coordinate'
    {'Interpolated',  'Interpolated w/ via pts', 'Uncoordinated',...
    'Sequential (CST angular vel.)', 'Sequential (time)',...
    'Straight line (CST linear vel.)', 'Straight line (time)'};...
    %'Move by Increment'
    {'Interpolated', 'Uncoordinated', 'Sequential (CST angular vel.)',...
'Sequential (time)','Straight line (CST linear vel.)','Straight line (time)'};...
    %'Move Joints'
    {'Interpolated',  'Interpolated w/ via pts', 'Uncoordinated',...
    'Sequential (CST angular vel.)', 'Sequential (time)'};...
    
    %'Parametric Cart. Traj.'
    {'Parametrised (CST linear vel.)','Parametrised (time)'};...
    
    %'Pametric Joint Traj.'
    {'Parametrised (CST angular vel.)', 'Parametrised (time)'};...
    
    %'Save actual Joints position'
    {'Interpolated', 'Uncoordinated','Sequential (CST angular vel.)',...
    'Sequential (time)'};...
    
    %'Load Table of Coordinates'
    {'Modelled - Table (CST linear vel.)', 'Modelled - Table (time)'};...
    
    %'Open Gripper'
    {'Interpolated', 'Uncoordinated'};...
    
    %'Close Gripper'
    {'Interpolated', 'Uncoordinated'};...
    
    %'Add a Pause'
    {''};...
    
    %'Repeat commands in History'
    {''};...
};

%Enable or disable each handle
for i = 1:1:length(handle_obj)
    if any(strcmp(cmd_enabled_field{cmd_sel}, handle_obj{i}))
        set(handles.(handle_obj{i}), 'Enable', 'on');
    else                                     %Enable: off   
        set(handles.(handle_obj{i}), 'Enable', 'off');
    end
end

% If Load Table of Coordinates, open window to choose table
if cmd_sel == 8
    MF_Load_Table_Coord();
end

% Adjusting trajectory options based on the command selected
set(handles.program_traj_opts, 'String', cmd_trajopts{cmd_sel});
%>>> END OF FUNCTION


%%
function add_inst_Callback(hObject, eventdata, handles)
HD = handles;   %create a copy of handles (just for shortening the name)
AS = evalin('base', 'AS');   % Load Additional Settings
ptvar = AS.program_table;   %Program table variables
%Get P table from base workspace
try
    P = evalin('base', 'P');   % Load Program table (P) from base workspace
    if isempty(P{1,1}{:})
        prow = 1;
    else
    prow = size(P,1) + 1;      % get the first empty rows.
    end
catch
    P = table();              % create an empty table
    P.Properties.Description='Valid Smart GUI program table';%for validation
    for i =1:length(ptvar)
        P.(ptvar{i}){1,1} = [];
    end
    prow = 1;                  % set number of row to 1;
end

% Get selected command and trajectory
cmd_list = AS.commands;
traj_list = get(handles.program_traj_opts, 'String');
cmd_sel = cmd_list{get(handles.program_cmd_opts, 'Value')};
if (size(traj_list, 1) > 1) || (size(traj_list{1}, 1) >= 1)
    traj_sel = traj_list{get(handles.program_traj_opts, 'Value')};
else
    traj_sel = '';
end

% All editable handle objects
edit_handles = {'program_pos_x','program_pos_y','program_pos_z',...
'prg_orient','inst_time','inst_joints','inst_A','prg_linvel', ...
'prg_angvel','program_cn'};

%Get handles values (stored in hv)
for i = 1:length(edit_handles)
    %try to convert to number
    value = str2num(get(HD.(edit_handles{i}), 'String'));
    if ~isempty(value)
        hv{i} = value;
    else
        hv{i} = get(HD.(edit_handles{i}), 'String');
    end
end

P.(ptvar{1}){prow,1} = cmd_sel;   %First column is always the 
P.(ptvar{2}){prow,1} = traj_sel;
if strcmp(get(HD.('program_pos_x'), 'Enable'), 'on') && ...
                    strcmp(get(HD.('inst_A'), 'Enable'), 'off')
	P.(ptvar{3}){prow,1} = hv(1:4);
else
    P.(ptvar{3}){prow,1} = hv{7};
end
P.(ptvar{4}){prow,1} = hv{6}; 
P.(ptvar{5}){prow,1} = hv{5}; 
P.(ptvar{6}){prow,1} = hv{8};
P.(ptvar{7}){prow,1} = hv{9};
P.(ptvar{8}){prow,1} = hv{10};

% Saving P in base workspace
assignin('base', 'P', P);

%Displaying P structure in uitable
MF_Load_Program_table(P);


% Cleaning all UI controls
for i=1:length(edit_handles)
    set(HD.(edit_handles{i}), 'String', '');
end
%>>> END OF FUNCTION

%%
function program_traj_opts_Callback(hObject, eventdata, handles)


function program_traj_opts_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function prg_clear_Callback(hObject, eventdata, handles)
% Create a new empty P table
AS = evalin('base', 'AS');   % Load Additional Settings
ptvar = AS.program_table;   %Program table variables

try
    P = evalin('base', 'P');   % Load P from base workspace
catch
    return
end

% Ask user if the table should be saved before cleaned
try
    if ~isempty(P) || size(P,1)>1
        answer = questdlg('Do you want to save the program?',...
                                                      'Save confirmation'); 
        if strcmp(answer,'Yes')
            uisave('P', 'Program_');
        end
    end
end

% Cleaning P
P = table();              % create an empty table
P.Properties.Description='Valid Smart GUI program table';%for validation
for i =1:length(ptvar)
    P.(ptvar{i}){1,1} = [];
end

%Saving in base workspace
assignin('base', 'P', P);

%Updating uiTable
MF_Load_Program_table(P);
%>>> END OF FUNCTION

%% #ok
function program_table_CellSelectionCallback(hObject, eventdata, handles)
pgr_ind = eventdata.Indices();
setappdata(0,'program_table_indice', pgr_ind);

%% #ok
function inst_moveup_Callback(hObject, eventdata, handles)
%Get the table content from base workspace
try
    P = evalin('base', 'P');
catch
    MF_Update_Message(29, 'warnings');
    return
end

try
    pgr_ind = getappdata(0, 'program_table_indice');
    pgr_row = pgr_ind(:, 1)';

catch
    return
end

if isempty(pgr_row)
    MF_Update_Message(30, 'warnings');
    return
end

if pgr_row(1) == 1
    return
elseif pgr_row(end) > size(P,1) + 2
    return
elseif pgr_row(1) > 2
    row_order = [1:pgr_row(1)-2, pgr_row, pgr_row(1)-1, ...
                                                pgr_row(end)+1:size(P,1)];
elseif pgr_row(1) == 2
    row_order = [pgr_row, pgr_row(1)-1, pgr_row(end)+1:size(P,1)];
end

%Reorganizing P
P = P(row_order,:);

%Saving in base workspace
assignin('base', 'P', P);

%Updating uiTable
MF_Load_Program_table(P);
%>>> END OF FUNCTION

%% #ok
function inst_movedown_Callback(hObject, eventdata, handles)
%Get the table content from base workspace
try
    P = evalin('base', 'P');
catch
    MF_Update_Message(29, 'warnings');
    return
end

try
    pgr_ind = getappdata(0, 'program_table_indice');
    pgr_row = pgr_ind(:, 1)';

catch
    return
end

if isempty(pgr_row)
    MF_Update_Message(30, 'warnings');
    return
end

if pgr_row(end) == size(P,1)
    return
elseif pgr_row(end) > size(P,1) + 2
    return
elseif pgr_row(1) ~= 1
    row_order = [1:pgr_row(1)-1, pgr_row(end)+1, ...
                                    pgr_row, pgr_row(end)+2:size(P,1)];
elseif pgr_row(1) == 1
    row_order = [pgr_row(end)+1, pgr_row, pgr_row(end)+2:size(P,1)];
end

%Reorganizing P
P = P(row_order,:);

%Saving in base workspace
assignin('base', 'P', P);

%Updating uiTable
MF_Load_Program_table(P);
%>>> END OF FUNCTION



%% #ok
function save_inst_Callback(hObject, eventdata, handles)
%>>>1: Open window to select folder for saving file
P = evalin('base', 'P');    %get Program table from base workspace
uisave('P', 'Program_');
%>>> END OF FUNCTION

%% #ok
function load_inst_Callback(hObject, eventdata, handles)
%Open dialog box for selecting file to load into workspace
%'load' will display only .mat files
uiopen('load')
%Validate the table loaded (using P.Properties.Description)
try
    valid_msg = P.Properties.Description;
    %compare both strings
    if strcmp(valid_msg, 'Valid Smart GUI program table'); 
        isvalidfile = true;
    else
        isvalidfile = false;
    end
catch
    isvalidfile = false;
end

% Save program table in workspace for future use
if isvalidfile
    assignin('base', 'P', P);   %save program table (P) in base workspace
else
    MF_Update_Message(3, 'warnings');   
    return
end

% Display the loaded file in the program table handle
MF_Load_Program_table(P);
%>>> END OF FUNCTION

%% #ok
function run_inst_Callback(hObject, eventdata, handles)
SF_Run_Program();
%>>> END OF FUNCTION

%% #ok
function delete_inst_Callback(hObject, eventdata, handles)
%Get the table content from base workspace
try
    P = evalin('base', 'P');
catch
    MF_Update_Message(29, 'warnings');
    return
end

try
    pgr_ind = getappdata(0, 'program_table_indice');
    pgr_row = pgr_ind(:, 1)';
catch
    return
end

P(pgr_row, :) = []; % Delete selected rows;

%Saving in base workspace
assignin('base', 'P', P);

%Updating uiTable
MF_Load_Program_table(P);
%>>> END OF FUNCTION

function program_cmd_opts_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inst_save_grip_pos_Callback(hObject, eventdata, handles)


function inst_torque_cb_Callback(hObject, eventdata, handles)
status = get(hObject, 'Value');
Torque_On_Off(handles.id, status, handles);
%>>> END OF FUNCTION















function pushbutton5_Callback(hObject, eventdata, handles)

function pushbutton4_Callback(hObject, eventdata, handles)

function checkbox1_Callback(hObject, eventdata, handles)

function popupmenu2_Callback(hObject, eventdata, handles)



function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu1_Callback(hObject, eventdata, handles)

function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider1_Callback(hObject, eventdata, handles)

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function pushbutton3_Callback(hObject, eventdata, handles)

function pushbutton2_Callback(hObject, eventdata, handles)

function pushbutton1_Callback(hObject, eventdata, handles)

function pushbutton8_Callback(hObject, eventdata, handles)


function pushbutton9_Callback(hObject, eventdata, handles)

function slider5_Callback(hObject, eventdata, handles)


function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider6_Callback(hObject, eventdata, handles)


function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider2_Callback(hObject, eventdata, handles)


function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider3_Callback(hObject, eventdata, handles)


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider4_Callback(hObject, eventdata, handles)

function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function pushbutton10_Callback(hObject, eventdata, handles)

function pushbutton11_Callback(hObject, eventdata, handles)

function pushbutton12_Callback(hObject, eventdata, handles)


function pushbutton13_Callback(hObject, eventdata, handles)

function pushbutton14_Callback(hObject, eventdata, handles)

function pushbutton15_Callback(hObject, eventdata, handles)

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)


function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)


function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton6_Callback(hObject, eventdata, handles)


function pushbutton7_Callback(hObject, eventdata, handles)


function popupmenu4_Callback(hObject, eventdata, handles)


function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu5_Callback(hObject, eventdata, handles)


function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu3_Callback(hObject, eventdata, handles)


function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)


function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton29_Callback(hObject, eventdata, handles)



function pushbutton28_Callback(hObject, eventdata, handles)


function pushbutton27_Callback(hObject, eventdata, handles)


function checkbox5_Callback(hObject, eventdata, handles)


function checkbox4_Callback(hObject, eventdata, handles)


function popupmenu6_Callback(hObject, eventdata, handles)


function popupmenu6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox2_Callback(hObject, eventdata, handles)


function checkbox3_Callback(hObject, eventdata, handles)


function pushbutton16_Callback(hObject, eventdata, handles)


function pushbutton17_Callback(hObject, eventdata, handles)


function pushbutton18_Callback(hObject, eventdata, handles)


function pushbutton19_Callback(hObject, eventdata, handles)


function pushbutton20_Callback(hObject, eventdata, handles)


function pushbutton21_Callback(hObject, eventdata, handles)


function edit5_Callback(hObject, eventdata, handles)


function edit5_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)



function edit6_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)


function edit7_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)


function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)


function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)


function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)



function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)




function popupmenu7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)


% --- Executes on button press in repeat_bt.
function repeat_bt_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)





% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)




function popupmenu8_CreateFcn(hObject, eventdata, handles)

%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)



function popupmenu9_CreateFcn(hObject, eventdata, handles)


%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slider7_Callback(hObject, eventdata, handles)



function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pushbutton34_Callback(hObject, eventdata, handles)



function pushbutton35_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function sg_tools_menu_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function sg_reopen_anim_win_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)








function program_pos_x_Callback(hObject, eventdata, handles)


function program_pos_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function inst_z_Callback(hObject, eventdata, handles)


function inst_z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inst_A_Callback(hObject, eventdata, handles)


function inst_A_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inst_joints_Callback(hObject, eventdata, handles)


function inst_joints_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function prg_linvel_Callback(hObject, eventdata, handles)


function prg_linvel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inst_time_Callback(hObject, eventdata, handles)


function inst_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inst_start_record_Callback(hObject, eventdata, handles)


function inst_stop_record_Callback(hObject, eventdata, handles)


function stop_inst_Callback(hObject, eventdata, handles)
global stop_state
%stop_state needs to be a global variable because Function 10: Run
%Instructions will update this value, and it cannot update handles

%0: Let the instructions Run; 1:Prevent from running.
stop_state = 1;
%>>> END OF FUNCTION










function p_x_Callback(hObject, eventdata, handles)


function p_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function p_y_Callback(hObject, eventdata, handles)


function p_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function p_z_Callback(hObject, eventdata, handles)


function p_z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function orientation_angle_Callback(hObject, eventdata, handles)


function orientation_angle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end












function jointn_menu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function inst_repeat_Callback(hObject, eventdata, handles)



function transformation_options_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








function joint_angles_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)



% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double



function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v_linear_Callback(hObject, eventdata, handles)
% hObject    handle to v_linear (see GCBO)



% Hints: get(hObject,'String') returns contents of v_linear as text
%        str2double(get(hObject,'String')) returns contents of v_linear as a double



function v_linear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_linear (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v_angular_Callback(hObject, eventdata, handles)
% hObject    handle to v_angular (see GCBO)



% Hints: get(hObject,'String') returns contents of v_angular as text
%        str2double(get(hObject,'String')) returns contents of v_angular as a double



function v_angular_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_angular (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% #ok
function traj_opt_Callback(hObject, eventdata, handles)
MF_Enable_Commands(hObject, handles);



function traj_opt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to traj_opt (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_param_Callback(hObject, eventdata, handles)
% hObject    handle to x_param (see GCBO)



% Hints: get(hObject,'String') returns contents of x_param as text
%        str2double(get(hObject,'String')) returns contents of x_param as a double



function x_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_param (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_param_Callback(hObject, eventdata, handles)
% hObject    handle to y_param (see GCBO)



% Hints: get(hObject,'String') returns contents of y_param as text
%        str2double(get(hObject,'String')) returns contents of y_param as a double



function y_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_param (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_param_Callback(hObject, eventdata, handles)
% hObject    handle to z_param (see GCBO)



% Hints: get(hObject,'String') returns contents of z_param as text
%        str2double(get(hObject,'String')) returns contents of z_param as a double



function z_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_param (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function joints_move_Callback(hObject, eventdata, handles)
% hObject    handle to joints_move (see GCBO)



% Hints: get(hObject,'String') returns contents of joints_move as text
%        str2double(get(hObject,'String')) returns contents of joints_move as a double



function joints_move_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joints_move (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_move_joints_Callback(hObject, eventdata, handles)
% hObject    handle to angle_move_joints (see GCBO)



% Hints: get(hObject,'String') returns contents of angle_move_joints as text
%        str2double(get(hObject,'String')) returns contents of angle_move_joints as a double



function angle_move_joints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_move_joints (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function param_joint_eq_Callback(hObject, eventdata, handles)
% hObject    handle to param_joint_eq (see GCBO)



% Hints: get(hObject,'String') returns contents of param_joint_eq as text
%        str2double(get(hObject,'String')) returns contents of param_joint_eq as a double



function param_joint_eq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_joint_eq (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)



% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double



function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)



% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double



function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in joint_param_eq_menu.
function joint_param_eq_menu_Callback(hObject, eventdata, handles)
% hObject    handle to joint_param_eq_menu (see GCBO)



% Hints: contents = cellstr(get(hObject,'String')) returns joint_param_eq_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from joint_param_eq_menu



function joint_param_eq_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_param_eq_menu (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function program_cn_Callback(hObject, eventdata, handles)
% hObject    handle to program_cn (see GCBO)



% Hints: get(hObject,'String') returns contents of program_cn as text
%        str2double(get(hObject,'String')) returns contents of program_cn as a double



function program_cn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to program_cn (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function program_pos_y_Callback(hObject, eventdata, handles)
% hObject    handle to program_pos_y (see GCBO)



% Hints: get(hObject,'String') returns contents of program_pos_y as text
%        str2double(get(hObject,'String')) returns contents of program_pos_y as a double



function program_pos_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to program_pos_y (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function program_pos_z_Callback(hObject, eventdata, handles)
% hObject    handle to program_pos_z (see GCBO)



% Hints: get(hObject,'String') returns contents of program_pos_z as text
%        str2double(get(hObject,'String')) returns contents of program_pos_z as a double



function program_pos_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to program_pos_z (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function prg_orient_Callback(hObject, eventdata, handles)
% hObject    handle to prg_orient (see GCBO)



% Hints: get(hObject,'String') returns contents of prg_orient as text
%        str2double(get(hObject,'String')) returns contents of prg_orient as a double



function prg_orient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prg_orient (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prg_angvel_Callback(hObject, eventdata, handles)
% hObject    handle to prg_angvel (see GCBO)



% Hints: get(hObject,'String') returns contents of prg_angvel as text
%        str2double(get(hObject,'String')) returns contents of prg_angvel as a double



function prg_angvel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prg_angvel (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ========================================================================
%  >>>>>>>>>>>>>>>>>>> TAB 4: DYNAMIC SIMULATION <<<<<<<<<<<<<<<<<<<<<<<<<
%========================================================================== 

% --- Executes on selection change in sim_joint.
function sim_joint_Callback(hObject, eventdata, handles)
% hObject    handle to sim_joint (see GCBO)



% Hints: contents = cellstr(get(hObject,'String')) returns sim_joint contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sim_joint



function sim_joint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_joint (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sim_function_Callback(hObject, eventdata, handles)
% hObject    handle to sim_function (see GCBO)



% Hints: get(hObject,'String') returns contents of sim_function as text
%        str2double(get(hObject,'String')) returns contents of sim_function as a double



function sim_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_function (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% #ok
function sim_add_bt_Callback(hObject, eventdata, handles)
HD = handles;   %create a copy of handles (just for shortening the name)

% All editable handle objects
edit_handles = {'sim_joint', 'sim_function', 'sim_time'};

expression = get(HD.(edit_handles{2}), 'String');
time = get(HD.(edit_handles{3}), 'String');

if isempty(expression) || isempty(time)
    return
end

ptvar = {'joint', 'expression', 'time'};   %Program table variables
%Get TT table from base workspace
try
    TT = evalin('base', 'TT'); % Load Torque table (TT) from base workspace
    if isempty(TT{1,1}{:})
        prow = 1;
    else
    prow = size(TT,1) + 1;      % get the first empty rows.
    end
catch
    TT = table();              % create an empty table
    TT.Properties.Description='Valid Smart GUI Torque table';%for validation
    for i =1:size(ptvar,2)
        TT.(ptvar{i}){1,1} = [];
    end
    prow = 1;                  % set number of row to 1;
end

TT.(ptvar{1}){prow,1} = get(HD.(edit_handles{1}), 'Value');
TT.(ptvar{2}){prow,1} = expression;
TT.(ptvar{3}){prow,1} = time;

% Saving P in base workspace
assignin('base', 'TT', TT);

%Displaying TT structure in uitable
set(HD.sim_functions_table,'Data',table2cell(TT));


% Cleaning all UI controls
set(HD.(edit_handles{2}), 'String', '');
set(HD.(edit_handles{3}), 'String', '');


%%
function sim_clear_table_bt_Callback(hObject, eventdata, handles)
TT = table();
assignin('base', 'TT', TT);
set(handles.sim_functions_table,'Data',[]);





function sim_cart_pos_Callback(hObject, eventdata, handles)
% hObject    handle to sim_cart_pos (see GCBO)



% Hints: get(hObject,'String') returns contents of sim_cart_pos as text
%        str2double(get(hObject,'String')) returns contents of sim_cart_pos as a double



function sim_cart_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_cart_pos (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sim_joint_pos_Callback(hObject, eventdata, handles)


function sim_joint_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_joint_pos (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% #ok
function sim_move_to_bt_Callback(hObject, eventdata, handles)
cart_pos = get(handles.sim_cart_pos, 'String');
joint_pos= get(handles.sim_joint_pos, 'String');

if ~isempty(joint_pos)
    In.space = 'joint'; %joint space
    In.pos = str2num(joint_pos);
elseif ~isempty(cart_pos) && isempty(joint_pos)
    In.space = 'cart'; %cartesian space
    In.pos = str2num(cart_pos);
else
    return
end
In.trajopt = 1; %coordinated trajectory
In.time = 10;
SF_Move_EE_to_Pos(In);

%% #ok
function sim_begin_bt_Callback(hObject, eventdata, handles)
SF_Dynamic_Simulation();


function sim_time_Callback(hObject, eventdata, handles)
% hObject    handle to sim_time (see GCBO)



% Hints: get(hObject,'String') returns contents of sim_time as text
%        str2double(get(hObject,'String')) returns contents of sim_time as a double



function sim_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_time (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function messages_txt_Callback(hObject, eventdata, handles)
% hObject    handle to messages_txt (see GCBO)



% Hints: get(hObject,'String') returns contents of messages_txt as text
%        str2double(get(hObject,'String')) returns contents of messages_txt as a double




%% ========================================================================
%  >>>>>>>>>>>>>>>>>>>>>>>>>>> CONTEXT MENU <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%========================================================================== 
% --------------------------------------------------------------------
function sg_repeat_cmd_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function repeat_last_cmd_Callback(hObject, eventdata, handles)
S = evalin('base', 'S');       %Load Settings (from base workspace)
cn = S.value{'cn'};
if cn ~= 1
    MF_Animate_Commands(cn - 1);
end

% --------------------------------------------------------------------
function sg_view_Callback(hObject, eventdata, handles)




% --------------------------------------------------------------------
function view_1_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(135,25);

% --------------------------------------------------------------------
function view_2_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(2);

% --------------------------------------------------------------------
function view_3_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(3);

% --------------------------------------------------------------------
function view_4_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(90,0);

% --------------------------------------------------------------------
function view_5_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(360,0);

% --------------------------------------------------------------------
function view_6_Callback(hObject, eventdata, handles)
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure
view(180, 90);

% --------------------------------------------------------------------
function clear_trail_Callback(hObject, eventdata, handles)
%Clear trail
AF = evalin('base', 'AF');
figure(AF);     %select the animation window figure

setappdata(0,'xtrail',[]);
setappdata(0,'ytrail', []);
setappdata(0,'ztrail',[]);

ax = gca;       %Get current axes

Tr = plot3(0,0,0,'r', 'LineWidth',2);
set(Tr,'xdata',[],'ydata',[],'zdata',[]);

% --------------------------------------------------------------------
function display_cg_Callback(hObject, eventdata, handles)
ischecked = get(hObject, 'Checked');
if strcmp(ischecked, 'on')
    set(hObject, 'Checked', 'off');
    
    MF_Plot_CG_frames(0, false);        % delete axes
else
    set(hObject, 'Checked', 'on');
    MF_Plot_CG_frames(0, true);         % display axes
end

% --------------------------------------------------------------------
function disp_ref_frames_Callback(hObject, eventdata, handles)
ischecked = get(hObject, 'Checked');
if strcmp(ischecked, 'on')
    set(hObject, 'Checked', 'off');
    MF_Plot_Base_frame(false);   % delete axes
else
    set(hObject, 'Checked', 'on');
    MF_Plot_Base_frame(true);   % display axes
end

% --------------------------------------------------------------------
function disp_link_frame_Callback(hObject, eventdata, handles)
ischecked = get(hObject, 'Checked');
if strcmp(ischecked, 'on')
    set(hObject, 'Checked', 'off');
    
    MF_Plot_Links_frame(0, false);   % delete axes
else
    set(hObject, 'Checked', 'on');
    MF_Plot_Links_frame(0, true);   % display axes
end

% --------------------------------------------------------------------
function plot_graphs_Callback(hObject, eventdata, handles)
S = evalin('base', 'S');       %Load Settings (from base workspace)
cn = S.value{'cn'} - 1;        %get the last command number
MF_Plot_Graphs(cn);

% --------------------------------------------------------------------
function plot_ctrl_graph_Callback(hObject, eventdata, handles)
S = evalin('base', 'S');       %Load Settings (from base workspace)
cn = S.value{'cn'} - 1;        %get the last command number
MF_Plot_Comparison_Graphs(cn);

% --------------------------------------------------------------------
function delete_history_Callback(hObject, eventdata, handles)
MF_Clear_History();

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function about_menu_Callback(hObject, eventdata, handles)
MF_About();
