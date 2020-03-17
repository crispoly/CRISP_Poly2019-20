%==========================================================================
% >>>>>>>>>> FUNCTION PF-G.2: ROBOT ACCELERATION FOR CONTROL SYSTEM <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Peter I. Corke
% Date: March 30th, 2016.

% Description: This function will implement the control system for
% controlling the manipulator. Refer to section 4 for details.
%==========================================================================


%SLACCEL	S-function for robot acceleration
%
% This is the S-function for computing robot acceleration. It assumes input
% data u to be the vector [q qd tau].
%
% Implemented as an S-function to get around vector sizing problem with
% Simulink 4.

function [sys, x0, str, ts] = PF_Robot_Acceleration(t, x, u, flag, robot)
S = evalin('base', 'S');   %Load Settings from base workspace
n = S.value{'dof'};


	switch flag,

	case 0
		% initialize the robot graphics
		[sys,x0,str,ts] = mdlInitializeSizes(n);	% Init

	case {3}
		% come here to calculate derivitives
        
        % first check that the torque vector is sensible
        if numel(u) ~= (3*n)
            error('RTB:slaccel:badarg', 'Input vector is length %d, should be %d', numel(u), 3*robot.n);
        end
        if ~isreal(u)
            error('RTB:slaccel:badarg', 'Input vector is complex, should be real'); 
        end
        
		sys = robot.accel(u(:)');
	case {1, 2, 4, 9}
		sys = [];
	end
%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(n)
 
%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;
 
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = n;
sizes.NumInputs      = 3*n;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
 
sys = simsizes(sizes);
 
%
% initialize the initial conditions
%
x0  = [];
 
%
% str is always an empty matrix
%
str = [];
 
%
% initialize the array of sample times
%
ts  = [0 0];
 
% end mdlInitializeSizes
