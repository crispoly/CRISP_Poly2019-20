%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-21: SAVE SETTINGS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will save settings to S structure
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Save_Settings(settings_data)
S = evalin('base', 'S');       %Load Settings (from base workspace)
RP = evalin('base', 'RP');     %Load Robot Parameters (from base workspace)
settings_path = which('SETTINGS.mat');


for i=1:length(settings_data)
    try
        if ischar(settings_data{i,2})
             valueConv = str2num(settings_data{i,2});
             if ~isempty(valueConv)
                 S.value{i} = valueConv;
             else
                 S.value{i} = settings_data{i,2};
             end
        else
            
            S.value{i} = settings_data{i,2};
        end
    catch
            S.value{i} = settings_data{i,2};
    end
end

%% Check entries for inconsistencies
% 
% Settings((2:length(settings_data)+1),2) = settings_data(:,2);

% % %>>Check each row for inconsistent numbers;
% % if ~(isboolean(Settings{2, 2}))        %ROW 2: ENABLE GRIPPER
% %     msgbox('the number you entered is not boolean');
% % elseif ~(isnumeric(Settings{3, 2}))    %ROW 3: RANGE OF ROTATION OF GRIPPER
% %     msgbox('the number you entered is not numeric');
% % 
% % elseif ~(isnumeric(Settings{4, 2}))     %ROW 4: PORT NUMBER (COM)
% %     msgbox('the number you entered is not numeric');
% % 
% % elseif ~(isnumeric(Settings{5, 2}))     %ROW 5: ROBOT NUMBER
% %     msgbox('the number you entered is not numeric');
% % 
% % elseif ~(isboolean(Settings{6, 2}))     %ROW 6: SIMULATION MODE
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isnumeric(Settings{7, 2}))     %ROW 7: TRAJECTORY OPTION****
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{8, 2}))     %ROW 8: SHOW TRAIL
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{9, 2}))     %ROW 9: SHOW AXES
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{10, 2}))    %ROW 10: ENABLE DYNAMIC SIMULATION
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{11, 2}))    %ROW 11: LINEAR SPEED
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{12, 2}))    %ROW 12: MOVE BY INCREMENT: COARSE
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{13, 2}))    %ROW 13: MOVE BY INCREMENT: FINE
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{14, 2}))    %ROW 14: ANGLES SET
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{15, 2}))    %ROW 15: NUMBER OF JOINTS
% %     msgbox('the number you entered is not boolean');
% % 
% % elseif ~(isboolean(Settings{16, 2}))    %ROW 16: HOME POSITION
% %     msgbox('the number you entered is not boolean');
% % end

%% Compute either home_q or home_p given one of them
q = S.value{'home_q'};

if ~isempty(q)
    [home_pos, ~] = PF_Forward_Kinematics(q, RP.d, RP.a, RP.alpha);
    
    % overwrite the home_p value in S structure if not equal to FK result
    if size(S.value{'home_p'}, 2) == 0
        S.value{'home_p'} = [home_pos, zeros(1,3)];
        MF_Update_Message(17, 'notice');
        pause(4);
    else
        home_p_S = round(S.value{'home_p'}(1:3), 5);
        if any((home_p_S == round(home_pos, 5)) == false)
            S.value{'home_p'}(1:3) = round(home_pos, 5);
            MF_Update_Message(15, 'notice');
            pause(4);
        end
        
        if size(S.value{'home_p'}, 2) == 3
            S.value{'home_p'}(4:6) = zeros(1,3);
        end
    end
    
elseif isempty(q) && ~isempty(S.value{'home_p'})
    % determine the q values by inverse kinematics
    home_p_S = S.value{'home_p'}(1:3);
    qm = PF_Inverse_Kinematics(home_p_S, zeros(1,S.value{'dof'}));
    S.value{'home_q'} = qm;
    MF_Update_Message(16, 'notice');
    pause(4);
    
elseif isempty(q) && isempty(S.value{'home_p'})
    MF_Update_Message(32, 'warnings');
    return
end


%% Compute max_reach if not given

d = RP.d'; a = RP.a'; alpha = RP.alpha'; %DH parameters
n = S.value{'dof'};

max_reach = S.value{'max_reach_p'}; %get max reach distance from Settings

if isempty(max_reach) || max_reach == 0 || isnan(max_reach)
    a_sum = sum(a);
    d_sum = sum(d);
    
    DH_reach = norm([a_sum, d_sum]);    %max reach by DH parameters
    
    % Compute forward kinematics settings joint position to 0 (q1...qn = 0)
    [~, Tm] = PF_Forward_Kinematics(zeros(1,n), d, a, alpha);
    pos_q0 = Tm{n}(1:3, 4)';   % get end-effector position from FK when q=0
    FK_reach = norm(pos_q0);
    
    max_reach = max(DH_reach, FK_reach);    %get the highest value
    S.value{'max_reach_p'} = max_reach;
end


%%
%Update the SETTINGS.MAT file
save(settings_path, 'S', '-append');
%Load structures files to workspace again
MF_Load_Structures();
MF_Load_Settings_table();
MF_Update_Message(9, 'notice');
end
