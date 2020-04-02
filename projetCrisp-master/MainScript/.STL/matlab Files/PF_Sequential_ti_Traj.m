%==========================================================================
% >>>>>>>> FUNCTION PF-C.5: SEQUENTIAL TRAJECTORY WITH TIME INPUT <<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint
% based on the user's input. The trajectory generated is sequential (one
% joint move at a time) and is interpolated by the use of a 5th order
% polynom considering initial and final velocity and acceleration equals to
% 0. Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Sequential_ti_Traj(varargin)
% pt: targe position and orientation(for uncoordinated traj: pt => 1x6)

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

ti = varargin{1};

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

n = size(qt, 2);         %number of joints (scalar)


%% Check inputs
if size(ti, 2) == 1
    ti = ones(1, n) * ti;
end

%%
% Computing step points (sp) 
sp = sum(ceil(ti * fps));
    
% Time vector from 0 to final ti, with sp rows
tv = linspace(0, sum(ti), sp)';

tvj = zeros(sp, n);
for i=1:n
    spi = ceil(ti(i) * fps);

    if i==1
        spp = 0;
        tvj(1:spi, i) = linspace(0, ti(i), spi)';
        tvj(spi:sp, i) = ti(i);
        
    else
        tvj(1:spp, i) = 0;
        tvj((spp : spp+spi-1), i) = linspace(0, ti(i), spi)';
        tvj(spp+spi-1:sp, i) = ti(i);
        
    end
    spp = spp+spi;
end

%% Generate the trajectory
q = zeros(sp,n);
dq = zeros(sp,n);
ddq = zeros(sp,n);

% Fifth order polynomial function
for i=1:n
    a0 = q0(i);
    a1 = 0;
    a2 = 0;
    a3 = (10*(qt(i) - q0(i))) / ti(i)^3;
    a4 = -(15*(qt(i) - q0(i))) / ti(i)^4;
    a5 = (6*(qt(i) - q0(i))) / ti(i)^5;

    %Assembling joint position coefficients
    q_cf = [a5 a4 a3 a2 a1 a0]; 

    %Assembling joint velocity coefficients
    dq_cf = [5*a5, 4*a4, 3*a3, 2*a2, a1];

    %Assembling joint acceleration coefficients
    ddq_cf = [20*a5, 12*a4, 6*a3, 2*a2]; 

    % Computing theta, d_theta, dd_theta (column vector)
    q(:,i) = polyval(q_cf,tvj(:, i));
    dq(:,i) = polyval(dq_cf,tvj(:, i));
    ddq(:,i) = polyval(ddq_cf,tvj(:, i));
end
end