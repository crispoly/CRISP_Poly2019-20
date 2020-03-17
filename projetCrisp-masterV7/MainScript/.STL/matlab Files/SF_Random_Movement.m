%==========================================================================
% >>>>>>>>>>>>>>>>>>> FUNCTION SF-8: RANDOM POSITION <<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will generate a set of random cartesian
% positions and call the interpolated trajectory function to generate the
% trajectory. The user is asked if the command should or not be sent to the
% robot (if connected)
% . Refer to section 4 of documentation for details.
%==========================================================================
function SF_Random_Movement()
% In structure should have the fields: 
% In.trajopt, In.pos, In.time, In.lv, In.av.
%% Load files and variables
S = evalin('base', 'S');    %Load Settings (from base workspace)
RP = evalin('base', 'RP');  %Load Robot Parameters

cn = S.value{'cn'};  %get the command number from Settings structure

%% Assembling random inputs
nvp = ceil(rand(1)*5); %number of via points
In.pos = ((rand(nvp, 3) - 0.5) * 1.5) * S.value{'max_reach_p'};
In.pos(:,3) = abs(In.pos(:,3)); %making Z values all positive
In.pos(:, 4:6) = rand(nvp, 3) * 90; %orientation

In.time = rand(1, nvp) * 20;
In.lv = rand(1, nvp) * (max(abs(RP.a))  / (max(RP.max_speed)/10));
In.av = rand(1, nvp) * (max(RP.max_speed)/10);

%% Check if coordinate is reachable and configuration mode used
    [is_allowed, is_reachable] = PF_Conf_Const_Reach('p', In.pos);
if ~is_reachable
    MF_Update_Message(1, 'warnings');
    return
elseif ~is_allowed
    MF_Update_Message(2, 'warnings');
    return
end

% Check if the coordinate is in a collision rote.
collision_detected = PF_Collision_Check (In.pos);
%Implement Collision_Check in future versions.
if collision_detected
    MF_Update_Message(6, 'warnings');
    return
end

%Call the respective trajectory function
[q, dq, ddq, tv, sp] = PF_Interpolated_wvp_Traj(In.pos, In.time, In.lv, In.av);

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
MF_Animate_Commands(cn)


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
msg_in = num2cell(In.pos(end,1:3)); %messages inputs
MF_Update_Message(1, 'notice', msg_in);

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end
