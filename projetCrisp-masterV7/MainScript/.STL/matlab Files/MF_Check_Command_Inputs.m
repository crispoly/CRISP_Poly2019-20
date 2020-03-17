%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-M: CHECK COMMAND INPUTS <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.
% DESCRIPTION: This function will .... 
% Refer to section 6.4.1 for details. 
%==========================================================================
function status = MF_Check_Command_Inputs (Command, inputs)
%Command: Number of the Instruction option (see list below)
%Variables: Because each Command has a different number of variables, this
%   function will not receive each variable indiviadually, instead will
%   receive a cell array {} with all variables for that specific command.

%This function will return True for a permitted inputs and False for not
%permitted inputs. For not permitted inputs, Function 10 (Run Instructions),
% should save the Instruction row in a handle variable to show the user
% which rows of instruction have problem.

%List of Commands:
    % 1 - Move to Coordinate
    % 2 - Move by Increment
    % 3 - Save Joints Angles
    % 4 - Move Joint
    % 5 - Open Grpiper      
    % 6 - Close Gripper     
    % 7 - Load Path         
    % 8 - Add a Pause       
    % 9 - Avoid object
    %10 - Save Joints Automatically
    %11 - Record Change

    %Call the respective function.
    switch Command
        case 1
            status = Check_Command_1(inputs);
        case 2
            status = Check_Command_2(inputs);
        case 3
            status = Check_Command_3(inputs);
        case 4
            status = Check_Command_4(inputs);
        case 5
            status = Check_Command_5(inputs);
        case 6
            status = Check_Command_6(inputs);
        case 7
            status = Check_Command_7(inputs);
        case 8
            status = Check_Command_8(inputs);
        case 9
            status = true;
        case 10
            status = true;
        case 11
            status = true;
        case 12
            status = true;
    end
end

%%
function Status = Check_Command_1(inputs)
%Command_1: Move to Coordinate

% variables = Variables;
% for i = 1:1:length(variables)
%     try
%         variables{i} = str2num(variables{i});
%         if isempty(variables{i})
%             variables{i} = function_variables{i};
%         end
%     end
% end

% [x_pos, y_pos, z_pos, orient_angle, path_option, speed] = deal(variables{:});
% %orient_angle is provided in World Set.

%Consider the code below in this function
% user_entry = str2double(get(h,'string'));
% if isnan(user_entry)
%     errordlg(['You must enter a numeric value, defaulting to ',num2str(default),'.'],'Bad Input','modal')
%     set(h_edit,'string',default);
%     user_entry = default;
% end
% %
% if user_entry < min_v
%     errordlg(['Minimum limit is ',num2str(min_v),' degrees, using ',num2str(min_v),'.'],'Bad Input','modal')
%     user_entry = min_v;
%     set(h_edit,'string',user_entry);
% end
% if user_entry > max_v
%     errordlg(['Maximum limit is ',num2str(max_v),' degrees, using ',num2str(max_v),'.'],'Bad Input','modal')
%     user_entry = max_v;
%     set(h_edit,'string',user_entry);
% end

%[configuration, is_allowed, is_reachable] = Conf_Const_Reach(P_XYZ);

Status = true;
%Call function C
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_2(inputs)
Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_3(inputs)
%Command_3: Save Joints Angles

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_4(inputs)
%Command_4: Move Joint

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_5(inputs)
%Command_5: Open Grpiper 

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_6(inputs)
%Command_6: Close Gripper

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_7(inputs)
%Command_7: Load Path 

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_8(inputs)
%Command_8: Add a Pause

Status = true;
%>>> END OF FUNCTION
end

%%
function Status = Check_Command_9(inputs)
%Command_9: Avoid object

Status = true;
%>>> END OF FUNCTION
end