%==========================================================================
% >>>>>>>>>>>>>> FUNCTION SF-6: MOVE END-EFFECTOR BY TABLE <<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will receive the user inputs from GUI and
% process these to move manipulator through a series of via points. The
% table is loaded from a Microsoft Excel spreadsheet. The user have to
% specify the time for trajectory completion. Each coordinate is converted
% to joint position using the respective primary function. This function
% works as a intermediate for the GUI (user inputs) and the primary
% function responsible for generating the trajectory. Refer to section
% 6.4.1 for details.
%==========================================================================
function SF_Move_by_Table(In)
% In.time, In.lv
% In: {1}: 'command' or 'program' - the tab origin that called this
% function, if it was called in command tab, then load the table, otherwise
% it is not necessary to load the table.
%           {2}: either 'time' or 'clv' => constant linear velocity
%           {3}: value: time or clv (scalar)

%% Loading variables
S = evalin('base', 'S');          %Load Settings (from base workspace)
RP = evalin('base', 'RP');     %Load Robot Parameters (from base workspace)
H = evalin('base', 'H');       %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
n = S.value{'dof'};
try
    %Attempt to load Table of Points (from base workspace)
    TP = evalin('base', 'TP'); 
catch
    MF_Update_Message(17, 'warnings');
end
%%

% TO DO: the way it is programmed (loading the TP from base workspace, it
% is possible to have only 1 trajectory by table per Program. Change the
% way it is importing the TP so then the user can insert as many traj by
% table as necessary in Program tab

% Make sure all rows are number
if ~isnumeric(TP)
    MF_Update_Message(14, 'warnings');
    return
end

% Check if coordinate is reachable and configuration mode used
[is_allowed, is_reachable] = PF_Conf_Const_Reach('p', TP);
if ~is_reachable
    MF_Update_Message(1, 'warnings');
    return
elseif ~is_allowed
    MF_Update_Message(2, 'warnings');
    return
end

% Check if the coordinate is in a collision rote.
collision_detected = PF_Collision_Check (TP);
%Implement Collision_Check in future versions.
if collision_detected
    MF_Update_Message(6, 'warnings');
    return
end


%To do list: 
%     When the path is loaded, show all points of the path in the graphical
%     window (independet of trail option). 

% ==== EXPERIMENTAL CODE - NEED CHANGE =======
    %If the distance between points is too large then create a
    %intermediate smoth path.
    
dist = zeros(size(TP));
for i=1:size(TP, 1)-1
    dist(i) = norm(TP(i,:) - TP(i+1, :));
end

max_dist = (S.value{'max_reach_p'}/S.value{'dof'}) * ...
                                        deg2rad(min(RP.max_speed))/5;

dist_list = find(dist > max_dist);

if ~isempty(dist_list)
    newTP = [];
    for i = 1:size(dist_list)
        
        %*********************
        dist = zeros(size(TP));
        for l=1:size(TP, 1)-1
            dist(l) = norm(TP(l,:) - TP(l+1, :));
        end
        dist_list = find(dist > max_dist);
        %*********************
        
        if size(TP(dist_list(1), :), 2) == 6
            s = TP(dist_list(1), 4:6);
            p_0 = TP(dist_list(1),:);
            p_target = TP(dist_list(1)+1, :);
        else
            s = [0 0 0];
            p_0 = [TP(dist_list(1),:), 0 0 0];
            p_target = [TP(dist_list(1)+1, :), 0 0 0];
        end
        
        
        q0 = PF_Inverse_Kinematics(p_0, zeros(1,n), s);
        qt = PF_Inverse_Kinematics(p_target, q0, s);
        
        %Compute time using half of the maximum joint speed
        time = max(abs(qt - q0)) / (min(RP.max_speed) / 16);
        [q, ~, ~, ~, ~] = PF_Interpolated_Traj(time, 'joint', qt, q0);
        
        pos = zeros(size(q, 1), 3);
        for j = 1: size(q, 1)
            [pos(j,:), ~] = PF_Forward_Kinematics(q(j, :), RP.d, RP.a, RP.alpha);
        end

        if size(TP(dist_list(1), :), 2) == 6
            pos(:, 4:6) = ones(size(pos,1), 1) * TP(dist_list(1), 4:6);
        end
        
        TP = [TP(1:dist_list(1), :); pos; TP(dist_list(1)+1 : end, :)];
    end
end

% ============================================

if In.trajopt == 12 && ~isempty(In.time)
    ti = In.time;
    [q, dq, ddq, tv, sp] = PF_Table_ti_Traj(TP, ti);
elseif In.trajopt == 11  && ~isempty(In.lv)
    clv = In.lv;
    [q, dq, ddq, tv, sp] = PF_Table_clv_Traj(TP, clv);
else
    MF_Update_Message(23, 'warnings');
    return
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
MF_Update_Message(11, 'notice');

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end
