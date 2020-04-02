%==========================================================================
% >>> FUNCTION PF-H: CONFIGURATION, CONSTRAINTS & REACHEABLE COORDINATE <<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will check if the position input (can be a
% joint position or a end-effector cartesian position) is reachable, and if
% it is permitted in the sense that thhe position will not make the robot
% collide with something. For robots that works with 2 different
% configuration (arm backwards like a scorpion) this function will tell if
% the configuration changes.
% Refer to section 4 of documentation for details. 
%==========================================================================
function [is_insidelim, is_allowed, is_reachable] = PF_Conf_Const_Reach(varargin)
% p: a vector or a matrix with all the target cartesian position (xyz)
% q: a vector or a matrix with all target joint variable

%% Loading and defining variables
S = evalin('base', 'S');   %Load Settings from base workspace
RP = evalin('base', 'RP');   %Load Robot Parameters

d = RP.d'; a = RP.a'; alpha = RP.alpha'; %DH parameters
n = S.value{'dof'};

max_reach = S.value{'max_reach_p'}; %get max reach distance from Settings

q_lim = RP.j_range; %limit of each joint

%start variables as true
is_reachable = true; is_allowed = true; is_insidelim = true;

for i=1:nargin
    if strcmp(varargin{i}, 'p')
        p = varargin{i+1};
    elseif strcmp(varargin{i}, 'q')
        q = varargin{i+1};
    end
end

%% Check if the coordinate is reachable
r_prob = [];    %rows with reach problem
a_prob = [];    %rows with allowability problem
l_prob = [];    %rows with limit problem
if exist('p', 'var')
    for i = 1:size(p, 1)
        p_rad = norm(p(i, 1:3)); %compute the radius formed by p vector
        
        % Check if position is reachable
        if p_rad > max_reach
            r_prob = [r_prob, i];
            is_reachable = false;
        end
        % Check if end-effector will hit table
        if p(i, 3) < 0
            a_prob = [a_prob, i];
            is_allowed = false;
        end
    end
end

if exist('q', 'var')
    for i = 1:size(q, 1)
        [p_vec, ~] = PF_Forward_Kinematics(q(i,:), d, a, alpha);
        p_rad = norm(p_vec);
        % Check if position is reachable
        if p_rad > max_reach
            r_prob = [r_prob, i]; 
            is_reachable = false;
        end
        
        % Check if end-effector will hit table
        if p_vec(3) < 0
            a_prob = [a_prob, i];
            is_allowed = false;
        end
        
        % Check if joint position is inside bounds
        for j = 1:n
            if q(j) < q_lim{j}(1) || q(j) > q_lim{j}(2)
                l_prob = [l_probl, j];
                is_insidelim = false;
            end
        end
    end
end

%% Display messages
if ~is_reachable
    MF_Update_Message(25, 'warnings', num2str(r_prob));
elseif ~is_allowed
    MF_Update_Message(26, 'warnings', num2str(a_prob));
elseif ~is_insidelim
    MF_Update_Message(27, 'warnings', num2str(l_prob));
end
end