%==========================================================================
% >>>>>>>>>>>>>> FUNCTION PF-C.3: UNCOORDINATED TRAJECTORY <<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. The trajectory generated in this function is
% uncoordinated and uses a constant joint velocity. The joints end their
% movement in different moments.
% Refer to section 4 of documentation for details. 
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Uncoodinated_Traj(varargin)
% pt: targe position and orientation(for uncoordinated traj: pt => 1x6)
% va = constant angular velocity;

%% Load structures and calculate necessary variables
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
fps = S.value{'fps'}; %get the number of frames per second

if cn == 1
    q0 = S.value{'home_q'};           %get theta angles of home position
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

va = varargin{1};

% Get joint variable target or cartesian target position from arguments in
if nargin ~= 3
    return
else
    if strcmp(varargin{2}, 'cart')
        pt = varargin{3};
    elseif strcmp(varargin{2}, 'joint')
        qt = varargin{3};
    end
    if exist('pt', 'var') && ~exist('qt', 'var')
        qt = PF_Inverse_Kinematics(pt, q0); %compute target q if not passed
    end
end

n = size(qt,2); %number of joints (scalar)
ti = abs(qt - q0)/va; %computing time ncessary for each joint reach its goal

% Computing step points (sp) 
sp = ceil(max(ti) * fps);

% Time vector from 0 to total time, with sp rows
tv = linspace(0,max(ti), sp)';
%% Generate the trajectory
q = zeros(sp,n);
dq = zeros(sp,n);
ddq = zeros(sp,n);
for i=1:n
    %Assembling joint position coefficients
    if qt(i) > q0(i)
        a1 = va;
    elseif qt(i) < q0(i)
        a1 = -va;
    elseif qt(i) == q0(i)
        a1 = 0;
    end
	q_cf = [a1, q0(i)]; 
    
    % Computing theta, d_theta, dd_theta (column vector)
    
    spi = round(ti(i) * fps);
    if spi < 1; spi = 1; end

    q(1:spi, i) = polyval(q_cf, tv(1:spi));
    q(spi, i) = polyval(q_cf, ti(i));
    if spi < sp
        q((spi+1: sp), i) = q(spi, i);
    end
    dq(:,i) = linspace(va, va, sp);
    ddq(:,i) = linspace(0, 0, sp);  %for a constant velocity the accel is 0
end
end
