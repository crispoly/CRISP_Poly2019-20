%==========================================================================
% >>>>>>>>>>>>>> FUNCTION PF-C.1: INTERPOLATED TRAJECTORY <<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. The trajectory will be interpolated by the use
% of a 5th order polynom.
% Refer to section 4 of documentation for details. 
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Interpolated_Traj(varargin)
% varargin: {1}time, {2}either 'cart' or 'joint', {3}either p or q vetors
%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
fps = S.value{'fps'}; %get the number of frames per second

if nargin < 4
    if cn == 1
        q0 = S.value{'home_q'};           %get current theta angles
    else
        q0 = H(cn - 1).q(end,:);          %get current theta angles
    end
else
    q0 = varargin{4};   %set q0 to value given
end

ti = varargin{1};
%% Generate the trajectory
% Get joint variable target or cartesian target position from arguments in
if nargin < 3
    return
else %check the space of the input
    if strcmp(varargin{2}, 'cart')  %cartesian space - so the next variable
        pt = varargin{3};                         %will be pos vector (xyz)
    elseif strcmp(varargin{2}, 'joint')%joint space
        qt = varargin{3};
    end
    if exist('pt', 'var') && ~exist('qt', 'var')
        qt = PF_Inverse_Kinematics(pt, q0); %compute target q if not passed
    end
end

n = size(qt, 2);         %number of joints (scalar)
% Computing step points (sp) 
sp = ceil(ti * fps);

% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';

    %Preallocating matrices for the output
q = zeros(sp, n);
dq = zeros(sp, n);
ddq = zeros(sp, n);

% Fifth order polynomial function
for i=1:n
    a0 = q0(i);
    a1 = 0;
    a2 = 0;
    a3 = (10*(qt(i) - q0(i))) / ti^3;
    a4 = -(15*(qt(i) - q0(i))) / ti^4;
    a5 = (6*(qt(i) - q0(i))) / ti^5;

    %Assembling joint position coefficients
    q_cf = [a5 a4 a3 a2 a1 a0]; 

    %Assembling joint velocity coefficients
    dq_cf = [5*a5, 4*a4, 3*a3, 2*a2, a1];

    %Assembling joint acceleration coefficients
    ddq_cf = [20*a5, 12*a4, 6*a3, 2*a2]; 

    % Computing theta, d_theta, dd_theta (column vector)
    q(:,i) = polyval(q_cf,tv);
    dq(:,i) = polyval(dq_cf,tv);
    ddq(:,i) = polyval(ddq_cf,tv);
end
end
