%==========================================================================
% >>>>>>>>>> FUNCTION PF-C.7: LINEAR TRAJECTORY W/ TIME INPUT <<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. A linear trajectory is generated using the
% Settings value linear increment distance.
% Refer to section 4 of documentation for details. 
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_StraightL_ti_Traj(pt, ti)
% pt: targe position and orientation(for uncoordinated traj: pt => 1x6)
% dqc = constant angular velocity;

%% Load structures and calculate necessary variables
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)
RP = evalin('base', 'RP');          %Load Robot Parameters

a = RP.a; d = RP.d; A = RP.alpha;   %D-H parameters

cn = S.value{'cn'};  %get the command number from Settings structure
% fps = S.value{'fps'};  %get the number of frames per second
liv = S.value{'lin_increm'}; %get linear increment value (mm)

if cn == 1
    q0 = S.value{'home_q'};           %get theta angles of home position
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

qt = PF_Inverse_Kinematics(pt, q0);

n = size(qt, 2);         %number of joints (scalar)

[p0, T] = PF_Forward_Kinematics(q0, d, a, A);
p0(4:6) = PF_Transform_to_Orient(T{n}); %get the current orientation

deltap = pt - p0;
nbp = ceil(norm(deltap(1:3)) / liv); %number of break points in the line
sp = nbp;
% Time vector from 0 to final time, with sp rows
tv = linspace(0, ti, nbp)';
%% Generating Trajectory
% break point positions (coordinates xyz)
pbp = zeros(nbp, 6);  %posit. & orient. of each break point(x,y,z,rx,ry,rz)
for i=1:6
    pbp(:,i) = linspace(p0(i),pt(i), nbp)';
end

qbp = PF_Inverse_Kinematics(pbp(2:end, :), q0);
q = [q0; qbp];  %joint displacement

%joint velocity and acceleration are computed by numerical differentiation
% dq = diff([zeros(1,n); q]);%/liv;
% ddq = diff([zeros(1,n); dq]);%/liv;
tm = [zeros(1,n); tv * ones(1, n)];
dq = diff([zeros(1,n); q])./diff(tm);
dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
ddq(1,:) = 0; %ddq(end,:) = 0;
end