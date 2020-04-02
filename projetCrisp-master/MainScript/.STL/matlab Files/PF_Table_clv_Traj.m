%==========================================================================
% >>>>>>>>> FUNCTION PF-C.13: TRAJECTORY BY TABLE W/ CST LIN VEL <<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint
% based on the user's input. This function receives a matrix with cartesian
% coordinates and a constant linear velocity for the end-effector in
% cartesian space. The function computs the length of the path and them
% computes the time using the velocity. After that it converts each
% coordinate to joint position by inverse kinematics. 
% Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Table_clv_Traj(p, vl, s)
% p: position matrix (n x 6: x, y, z, rx, ry, rz)
% vl: linear velocity (constant)

%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{15};  %get the command number from Settings structure

if cn == 1
    q0 = S.value{16};           %get current theta angles
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

n = size(q0, 2);

sp = size(p, 1);    % Computing step points (sp)

%Computing S (approximation by linear distance between points)
S = 0;
for i = 1:sp-1
    S = S + norm(p(i, 1:3) - p(i+1, 1:3));
end
ti = S/vl;

% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';
%% Generate the trajectory
if ~exist('s', 'var')
    if (size(p,2) < 6) || (n < 6)
        p(:, 4:6) = zeros(size(p, 1), 3);
        s = [0 0 0]; % no need to satisfy orientation in IK
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
