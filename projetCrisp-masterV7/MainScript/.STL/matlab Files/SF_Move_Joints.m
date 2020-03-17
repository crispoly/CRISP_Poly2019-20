%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-4: MOVE JOINTS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will receive the user inputs from GUI and
% process these to move the joint specified. The function accept values for
% moving one single joint or a vector for moving several joints at once.
% This function works as a intermediate for the GUI (user inputs) and the
% primary function responsible for generating the trajectory. Refer to
% section 4 of documentation for details.
%==========================================================================
function SF_Move_Joints(In)
% In.av, In.time, In.qt, In.joint, In.trajopt
% In.qt: target joint variable
% In.joint = joint number that the movement will be made (scalar or a vector)
%% Load files and variables
S = evalin('base', 'S');    %Load Settings (from base workspace)
RP = evalin('base', 'RP');      %Load Robot Parameters
H = evalin('base', 'H');    %Load History (from base workspace)
cn = S.value{'cn'};  %get the command number from Settings structure

a = RP.a; d = RP.d; alpha = RP.alpha;   %D-H parameters
%%
if cn == 1
    qc = S.value{'home_q'};
else
    qc = H(cn-1).q(end,:);
end

qt = qc;    %set target joint variable to current q
qt(In.joint) = In.qt;%update target q with the inputs (only in the In.joint col)

% Compute target cartesian position (given the target theta)
[pos, ~] = PF_Forward_Kinematics(qt, d, a, alpha);

%Note: The variables: is_allowed, is_reachable are not used here because the
%user is using the joints sliders with the limits imposed in Settings

% Check if the coordinate is in a collision rote.
collision_detected = PF_Collision_Check (pos);
%Implement Collision_Check in future versions.
if collision_detected
    MF_Update_Message(6, 'warnings');
    MF_Update_Message(9, 'warnings');
    return
end

%Call the respective trajectory function
switch In.trajopt
    case 1
    [q, dq, ddq, tv, sp] = PF_Interpolated_Traj(In.time, 'joint', qt);
    
    case 3
    [q, dq, ddq, tv, sp] = PF_Uncoodinated_Traj(In.av, 'joint', qt);
    
    case 4
    [q, dq, ddq, tv, sp] = PF_Sequential_cav_Traj(In.av, 'joint', qt);
    
    case 5
    [q, dq, ddq, tv, sp] = PF_Sequential_ti_Traj(In.time, 'joint', qt);

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
m_inputs = {num2str(In.joint), num2str(In.qt)}; %messages inputs
MF_Update_Message(5, 'notice', m_inputs);

% Update Transformation Matrix, sliders and other ui components
MF_Update_UI_Controls();

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end