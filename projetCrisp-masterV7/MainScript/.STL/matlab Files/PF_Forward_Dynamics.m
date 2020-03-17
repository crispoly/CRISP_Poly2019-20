%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-D: FORWARD DYNAMICS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Peter I. Corke, 
% Modified by Diego Varalda de Almeida with permission under the terms of
% the GNU.
% Date: June 05th, 2016.
% version 1.0 - March 30th, 2016. 

% DESCRIPTION: This function will compute the compute the forwards dynamics
% given the torque inputted by the user in tab 4: Dynamics simulation. The
% solution is done by the use of the ode45 function and the inverse
% dynamics function using the Recursive Newton Euler method (also
% implemented by Peter I. Corke in his Robotics Matlab Toolbox). Refer to
% section 4 of documentation for details.
%==========================================================================
function [t, q, dq] = PF_Forward_Dynamics(t1, torq_matrix, q0, qd0, varargin)
S = evalin('base', 'S');      %Load Settings (from base workspace)
ctrl_rate = S.value{'ctrl_rate'};
    % check the Matlab version, since ode45 syntax has changed
    if verLessThan('matlab', '7')  
        error('fdyn now requires Matlab version >= 7');
    end

    n = S.value{'dof'};
    if nargin == 1
        torq_matrix = 0;
        q0 = zeros(1,n);
        qd0 = zeros(1,n);
    elseif nargin == 2
        q0 = zeros(1,n);
        qd0 = zeros(1,n);
    elseif nargin == 3
        qd0 = zeros(1,n);
    end

    % concatenate q and qd into the initial state vector
    q0 = [q0(:); qd0(:)];
   
    [t,y] = ode45(@fdyn2, [0 t1], q0, [], n, torq_matrix, ctrl_rate);
    q = y(:,1:n);
    dq = y(:,n+1:2*n);
end

%FDYN2  private function called by FDYN
%
%   XDD = FDYN2(T, X, FLAG, ROBOT, TORQUEFUN)
%
% Called by FDYN to evaluate the robot velocity and acceleration for
% forward dynamics.  T is the current time, X = [Q QD] is the state vector,
% ROBOT is the object being integrated, and TORQUEFUN is the string name of
% the function to compute joint torques and called as
%
%       TAU = TORQUEFUN(T, X)
%
% if not given zero joint torques are assumed.
%
% The result is XDD = [QD QDD].
function [xd,qdd] = fdyn2(t, x, n, torq_matrix, varargin)
    q = x(1:n)';
    qd = x(n+1:2*n)';
%     qdd = x(2*n+1:3*n)';
    
    ctrl_rate = varargin{1};
%     % evaluate the torque function if one is given
%     if isa(torqfun, 'function_handle')
%         tau = torqfun(t, q, qd, varargin{:});
%     else
%         tau = zeros(1,n);
%     end

    if t==0
        idx = 1;
    else
        idx = ceil(t*ctrl_rate);
    end
    tq_row = torq_matrix(idx, :);

    qdd = accel(n, x(1:n,1)', x(n+1:2*n,1)', tq_row);
    xd = [x(n+1:2*n,1); qdd];
end


function qdd = accel(n, Q, qd, torque)

if nargin == 2
        if length(Q) ~= (3*n)
            error('RTB:accel:badarg', 'Input vector X is length %d, should be %d (q, qd, tau)', length(Q), 3*robot.n);
        end
        % accel(X)
        Q = Q(:)';   % make it a row vector
	    q = Q(1:n);
		qd = Q(n+1:2*n);
		torque = Q(2*n+1:3*n);
    elseif nargin == 4
        % accel(Q, qd, torque)
        
        if size(Q, 1) > 1
            % handle trajectory by recursion
            if size(Q,1) ~= size(qd,1)
                error('for trajectory q and qd must have same number of rows');
            end
            if size(Q,1) ~= size(torque,1)
                error('for trajectory q and torque must have same number of rows');
            end
            qdd = [];
            for i=1:size(Q,1)
                qdd = cat(1, qdd, accel(Q(i,:), qd(i,:), torque(i,:))');
            end
            return
        else
            q = Q';
            if length(q) == n
                q = q(:)';
                qd = qd(:)';
            end
            if size(Q,2) ~= n
                error('q must have %d columns', n);
            end
            if size(qd,2) ~= n
                error('qd must have %d columns', n);
            end
            if size(torque,2) ~= n
                error('torque must have %d columns', n);
            end
        end
    else
        error('RTB:accel:badargs', 'insufficient arguments');
    end


	% compute current manipulator inertia
	%   torques resulting from unit acceleration of each joint with
	%   no gravity.
    M = PF_Inverse_Dynamics(rad2deg(ones(n,1)*q), rad2deg(zeros(n,n)), ...
                                                rad2deg(eye(n)), [0;0;0]);
    
	% compute gravity and coriolis torque
	%    torques resulting from zero acceleration at given velocity &
	%    with gravity acting.
    tau =PF_Inverse_Dynamics(rad2deg(q), rad2deg(qd), rad2deg(zeros(1,n)));	
	qdd = M \ (torque - tau)';
end

        
