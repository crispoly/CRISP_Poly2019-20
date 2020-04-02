%==========================================================================
% >>>>>>>>> FUNCTION SF-2: MOVE ARM TO THE INPUTTED COORDINATE <<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will receive the user inputs from GUI and
% process this to move the end-effector to a cartesian position and
% orientation. This function works as a intermediate for the GUI (user
% inputs) and the primary function responsible for generating the
% trajectory.Refer to section 4 of documentation for details.
%==========================================================================
function SF_Move_EE_to_Pos(In)
% In structure should have the fields: 
% In.trajopt, In.pos, In.time, In.lv, In.av.
%% Load files and variables
S = evalin('base', 'S');    %Load Settings (from base workspace)
cn = S.value{'cn'};  %get the command number from Settings structure

%%

% Check if coordinate is reachable and configuration mode used
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
switch In.trajopt
    case 1
    [q, dq, ddq, tv, sp] = PF_Interpolated_Traj(In.time, In.space, In.pos);
    
    case 2
    [q, dq, ddq, tv, sp] = PF_Interpolated_wvp_Traj(In.pos, In.time, In.lv, In.av);
    
    case 3
    [q, dq, ddq, tv, sp] = PF_Uncoodinated_Traj(In.av, In.space, In.pos);
    
    case 4
    [q, dq, ddq, tv, sp] = PF_Sequential_cav_Traj(In.av, In.space, In.pos);
    
    case 5
    [q, dq, ddq, tv, sp] = PF_Sequential_ti_Traj(In.time, In.space, In.pos);
    
    case 6
    [q, dq, ddq, tv, sp] = PF_StraightL_clv_Traj(In.pos, In.lv);
    
    case 7
    [q, dq, ddq, tv, sp] = PF_StraightL_ti_Traj(In.pos, In.time);
    otherwise
        MF_Update_Message(7, 'warnings');
        return
end

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