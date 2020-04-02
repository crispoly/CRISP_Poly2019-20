%==========================================================================
% >>>>>>>>> FUNCTION SF-7: MOVE ARM BY PARAMETRIC TRAJECTORY <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will receive the user inputs from GUI and
% process these to move manipulator through a parametric curve in cartesian
% space or a curve in joint space. This function works as a intermediate
% for the GUI (user inputs) and the primary function responsible for
% generating the trajectory. Refer to section 6.4.1 for details.
%==========================================================================
function SF_Move_by_Parametric_Eq(In)
% In.trajopt, In.pex, In.pey, In.pez, In.pej, In.joint, In.av, In.lv,
% In.pos, In.time, In.space
%% Load files and In.avriables
S = evalin('base', 'S');    %Load Settings (from base workspace)
RP = evalin('base', 'RP');     %Load Robot Parameters (from base workspace)
H = evalin('base', 'H');       %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure

if any(size(In.time) > 1)
    delt = abs(In.time(2) - In.time(1));
else
    delt = In.time(1);
end

%% Call the respective trajectory function
if strcmp(In.space, 'cart')    %get the input space (cartesian space)
    if size(In.pos, 2) > 3
        if isnumeric(In.pos(4:6))
            orient = In.pos(4:6);
        else
            orient = [0 0 0];
        end
    end
    
    if ~ischar(In.pex) || ~ischar(In.pey) || ~ischar(In.pez)
        MF_Update_Message(11, 'warnings');
        return
        
    elseif In.trajopt == 10
        [q, dq, ddq, tv, sp] = PF_Parametrised_ti_Traj(In.pex, In.pey, ...
                                                    In.pez, delt, orient);
        
    elseif In.trajopt == 8
        [q, dq, ddq, tv, sp] = PF_Parametrised_clv_Traj(In.pex, In.pey,...
                                            In.pez, In.lv, delt, orient);
    else
        MF_Update_Message(12, 'warning');
        return
    end
        
elseif strcmp(In.space, 'joint')    %get the input space (joint space)
    if ~ischar(In.pej)
        MF_Update_Message(11, 'warnings');
        return

   elseif In.trajopt == 9
        [q, dq, ddq, tv, sp] = PF_Parametrised_cav_Traj(In.pej, In.joint, In.av, delt);
        
    elseif In.trajopt == 10
        [q, dq, ddq, tv, sp] = PF_Parametrised_J_ti_Traj(In.pej, In.joint, delt);
        
    else
        MF_Update_Message(12, 'warning');
        return
    end
end

%%
%PS: The parametric equation given by the user may result in a start
%position very far away from the current position, so it is necessary to
%first move the end-effector to the first point given by the parametric
%equation and then start the trajectory itself, it is done by a coordinated
%trajectory using the medium speed of the joints (such as in MOVE_HOME fcn)

%   Create a smooth trajectory between first point of parametric trajectory
%   and current position.
max_speed = RP.max_speed;

% Get current joint variables to compute time
if cn == 1  %End-effector already in home position
    q0 = S.value{'home_q'};
else
    q0 = H(cn - 1).q(end,:);
end

if any(abs(q(1,:) - q0) ~= 0)  % joints not in starting point
    %Compute time using half of the maximum joint speed
    time = max(abs(q(1,:) - q0)) / (min(max_speed) / 4);

    %Call interpolated trajectory and get pre-trajectory values
    [qp, dqp, ddqp, tvp, spp] = PF_Interpolated_Traj(time,'joint', q(1,:));

    % Update variables (q, dq, ddq, tv, sp): merge both trajectories
    q = [qp; q]; dq = [dqp; dq]; ddq = [ddqp; ddq]; 
    sp = spp + sp;
    tv = linspace(0, (tvp(end,1) + tv(end, 1)), sp)';
end
%% 
% Check if coordinate is reachable and configuration mode used
[is_allowed, is_reachable] = PF_Conf_Const_Reach('q', q);
if ~is_reachable
    MF_Update_Message(1, 'warnings');
    return
elseif ~is_allowed
    MF_Update_Message(2, 'warnings');
    return
end

% Check if the coordinate is in a collision rote.
collision_detected = PF_Collision_Check ('q', q);
%Implement Collision_Check in future versions.
if collision_detected
    MF_Update_Message(6, 'warnings');
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
MF_Update_Message(6, 'notice');

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end
