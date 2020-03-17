%==========================================================================
% >>>>>>>>>> FUNCTION SF-1: MOVE END-EFFECTOR TO HOME POSITION <<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will load the home position from Settings
% structure and process this to move the end-effector to home position
% orientation in interpolated trajectory. This function works as a
% intermediate for the GUI (user inputs) and the primary function
% responsible for generating the trajectory. Refer to section 4 of
% documentation for details.
%==========================================================================
function SF_Move_EE_to_Home()
%% Load files and variables
S = evalin('base', 'S');       %Load Settings (from base workspace)
H = evalin('base', 'H');       %Load History (from base workspace)
RP = evalin('base', 'RP');     %Load Robot Parameters (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
home_q = S.value{'home_q'}; %get home joint variables
max_speed = RP.max_speed;
%%
%PS: No need to check if home position is reached or allowed (already done)

% Get current joint variables to compute time
if cn == 1  %End-effector already in home position
    MF_Update_Message(16, 'warnings');
    return
else
    q0 = H(cn - 1).q(end,:);
end

if abs(home_q - q0) == 0  %End-effector already in home position
    MF_Update_Message(16, 'warnings');
    return
else  
    %Compute time using half of the maximum joint speed
    time = max(abs(home_q - q0)) / (min(max_speed) / 4);
end

%Call the respective trajectory function
[q, dq, ddq, tv, sp] = PF_Interpolated_Traj(time, 'joint', home_q);

% If dynamics is enabled, compute torque
enable_dynamics = S.value{'enable_dynamics'};
if enable_dynamics
    tq = PF_Inverse_Dynamics(q, dq, ddq);   %get the computed torque
    
    % If control system is enabled, simulate the result of the control
    enable_control = S.value{'enable_control'};
    if enable_control
        tqc = PF_Robot_Control(q, dq, ddq, tq);   %get the control system torque
        [qc, dqc, ddqc] = PF_Forward_Dynamics(tqc);
    else
        qc = []; dqc = []; ddqc = [];
    end
else
    qc = []; dqc = []; ddqc = []; tq = []; tqc = [];
end
%% Save outputs into the History structure
MF_Save_Structures('H', 'q', q, 'dq', dq, 'ddq', ddq, 'qc', qc, ...
    'dqc', dqc, 'ddqc', ddqc, 'sp', sp, 'time',tv, 'tq', tq);
%%
% Animate command
%     Note: First the user will see the command animation on the screen and
%     then the motion is performed in the robot. For motion and animation
%     occuring at the same time, amend this code using Multithreading
MF_Animate_Commands(cn);


% Drive Servos (Send command to robot it connected)
simulation_only = S.value{'simul_only'};
if ~simulation_only
    id = S.value{'robotnum'};
    pauset = S.value{'servo_pause'};
    baudnum = S.value{'baudnum'};
    portnum = S.value{'portnum'};
    %Drive servos if NOT in simulate mode.
    PF_Driving_Actuators(id, q, dq, pauset, portnum, baudnum);
end

% Update Message box.
MF_Update_Message(4, 'notice');

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end