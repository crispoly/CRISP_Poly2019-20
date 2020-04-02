%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-10: RUN PROGRAM <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will read the programs table, generated in
% Programs tab and for each row in this table call the respective command
% function (secondary functions).
% Refer to section 6.4.1 for details. 
%==========================================================================
function SF_Run_Program()

%% Loading and defining variables
P = evalin('base', 'P');   %Load Program table (P) from base workspace
S = evalin('base', 'S');   %Load Settings from base workspace
AS = evalin('base', 'AS');   %Load Additional Settings from base workspace

cmd_list = AS.commands; %Get commands list in Additional Settings structure
traj_list = AS.traj_opts;%Get trajectory list
% Get the number of columns in P from AS structure
nc = size(AS.program_table, 2);


%Commands list:
%     'Home Position'
%     'Move to Coordinate'
%     'Move by Increment'
%     'Move Joints'
%     'Parametric Cart. Traj.'
%     'Parametric Joint Traj.'
%     'Save actual Joints position'
%     'Load Table of Coordinates'
%     'Open Gripper'
%     'Close Gripper'
%     'Add a Pause'
%     'Copy commands from History'

%pgm_var allow the attribution of value from the program Table
%to the cell array that holds all variables values for that specific command
%for example: the Move to Coordinate will have the variables:
%x, y, z, A, speed and path options enabled (the 1's in the first row below) 
% the cell array with all variables used for that specific function will be
% passed to the Function that run that command, for command Move to
% Coordinate, the function is Function 1:  MOVE ARM TO THE INPUTTED
% COORDINATE.
%1: The inst_variables (cell array) will get the value from the table
%0: The inst_variables will not get the value of that column from the table

% 'Command','Position', 'Joint', 'Trajectory Option', 'time', 'Lin vel', 'Ang vel'


%%
% Check if the program file is not empty;
if isempty(P(:,1)) || size(P, 2) ~= nc
     MF_Update_Message(4, 'warnings');
    return
end

% Check if the command is valid (all commands);
cmd_r = []; %Will store the rows with problems.
for i = 1:1:size(P,1)  %For each row in the program Table.
    %Get the command number
    cmd = find(strcmp(char(P{i,1}{:}), cmd_list));
    if isempty(cmd)
        continue
    end
%     In = [];    %reset the inputs variables
    
    % Assembling the Input structure
    In(i).trajopt = find(strcmp(P{i, 2}{:}, traj_list));
    In(i).time = P{i, 5}{:}; 
    In(i).pos = P{i, 3}{:}; 
    In(i).qt = P{i, 3}{:}; 
    In(i).lv = P{i, 6}{:}; 
    In(i).av = P{i, 7}{:}; 
    
    
    if size(P{i, 3}{:},2) > 1
        try
            In(i).pos = [];     In(i).increm = [];
            for j=1:size(P{i, 3}{:},2)
                if ~isempty(P{i, 3}{:}{j})
                    In(i).pos = [In(i).pos, P{i, 3}{:}{j}];
                    In(i).increm = [In(i).increm, P{i, 3}{:}{j}];
                end
            end
            In(i).space = 'cart';
        end
    else
        In(i).pej = P{i, 3}{:}; 
        In(i).space = 'joint';
    end

    In(i).joint = P{i, 4}{:}; 
    In(i).cn = P{i, 8}{:}; 
    
    %Call function Check command Inputs to check if values inputted 
    % in that row of the program table are OK.
    try %Used here for eventual errors not caught in the Function (below)
        status = MF_Check_Command_Inputs(cmd, In(i));
    %If the function that checks the inputs return false (found a problem),
    %then the handle below will take note of the row to display to the user.
        if ~status
            cmd_r = [cmd_r, i];
        end
    catch
        cmd_r = [cmd_r, i];
    end
end

% If there is a list with the problematic rows then stop this function
%      (Do not run the program until the user corrects the rows).
if ~isempty(cmd_r)
    %Display the rows with problems in the message box
    MF_Update_Message(5,'warnings', num2str(cmd_r));
    return  %Exit (Return) function
else
    MF_Update_Message(2,'notice');
end

% Call the respective function for each command
for i = 1:1:size(P,1)  %For each row in the program Table.
    stop = S.value{'stop'}; %check if uesr pressed STOP button
    if stop
        MF_Update_Message(8, 'warnings');
        MF_Update_Stop_status(false); %reseting stop status
        return
    end     %Continue with function otherwise.
    
    %Get the command number
    cmd = find(strcmp(char(P{i,1}{:}), cmd_list));

    switch cmd
        case 1 %Home Position
            SF_Move_EE_to_Home();
            
        case 2 %Move to Coordinate
            SF_Move_EE_to_Pos(In(i));
            
        case 3 %Move by Increment
            In(i).space = 'cart';
            SF_Move_EE_by_Increment(In(i));
            
        case 4 %Move Joints
            SF_Move_Joints(In(i));
            
        case 5 %Parametric Cart. Traj.
            In(i).pex = P{i, 3}{:}{1};
            In(i).pey = P{i, 3}{:}{2};
            In(i).pez = P{i, 3}{:}{3};
            SF_Move_by_Parametric_Eq(In(i));
            
        case 6 %Parametric Joint Traj.
            SF_Move_by_Parametric_Eq(In(i));
            
        case 7 %Save actual Joints position
            SF_Move_Joints(In(i))
            %Note about this command:
            %When added to the table, the program will save the joints
            %angles, but when the program RUN, the command Save Joints
            %Angles will be transformed to: Move joints to that saved
            %angle (in this manner, this function will be similar to a
            %teach pendant). That is why it is calling Function 3 here.            
            
        case 8 %Load Table of Coordinates
            SF_Move_by_Table(In(i));
            
        case 9 %Open Gripper
            SF_End_Effector_Control(In(i));
            
        case 10 %Close Gripper
            SF_End_Effector_Control(In(i));
            
        case 11 %Add a Pause
            SF_Pause_Program(In(i));
            
        case 12 %Copy commands from History
            SF_Repeat_Commands(In(i));
    end
end