%==========================================================================
% >>>>>>>>> FUNCTION PF-C.12: TRAJECTORY BY TABLE W/ TIME INPUT <<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. This function receives a matrix with cartesian
% coordinates and a time (in seconds) for completing the trajectory. The
% function converts each coordinate to joint position by inverse kinematics
% Refer to section 4 of documentation for details. 
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Table_ti_Traj(p, ti, s)
% p: position matrix (n x 6: x, y, z, rx, ry, rz)
% ti: time for completing the trajectory
% s: orientation specification (vector 1x3), if [1 1 1] the inverse
% kinematics will attempt to satisfy the orientation presented in the table
%PS: The inputs check is made in the Secondary function that calls this one
%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure


if cn == 1
    q0 = S.value{'home_q'};     %get current theta angles
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

n = size(q0, 2);

sp = size(p, 1);    % Computing step points (sp)

% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';
%% Generate the trajectory
if ~exist('s', 'var')
    if (size(p,2) < 6) || (n < 6)
        s = [0 0 0]; % no need to satisfy orientation in IK
        p(:, 4:6) = zeros(size(p, 1), 3);
    else
        s = [1 1 1];% satisfy orientation in IK
    end
end
q = PF_Inverse_Kinematics(p, q0, s);

tm = [zeros(1,n); tv * ones(1, n)];
dq = diff([zeros(1,n); q])./diff(tm);
dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
ddq(1,:) = 0; %ddq(end, :) = 0;
end
