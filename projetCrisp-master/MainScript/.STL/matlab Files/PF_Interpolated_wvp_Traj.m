%==========================================================================
% >>>>>>> FUNCTION PF-C.2: INTERPOLATED TRAJECTORY WITH VIA POINTS <<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint
% based on the user's input. The trajectory will be interpolated by the use
% of a 5th order polynom, for each via point. If the vecity is not given
% for the via points, the function will try to compute by the use of
% Jacobian or heuristic method. 
% Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Interpolated_wvp_Traj(pt, tvp, vl,va,qt)
% tvp = time of via points
% pt = cartesian via points
% ot = orientation of each via point
% vl = linear velocity via point (end-effector) [mm/sec]
% va = angular velocity via point (end-effector) [deg/sec]
%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)
RP = evalin('base', 'RP');          %Load Robot Parameters
a = RP.a; d = RP.d; A = RP.alpha;   %D-H parameters

cn = S.value{'cn'};  %get the command number from Settings structure
fps = S.value{'fps'}; %get the number of frames per second

if cn == 1
    q0 = S.value{'home_q'};           %get current theta angles
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

%% Generate the trajectory
% Obtain target theta angles from the target position and orientation
if exist('pt', 'var') && ~exist('qt', 'var')
    qt = PF_Inverse_Kinematics(pt, q0); %compute target q if not passed
end

n = size(q0,2); %number of joints (scalar)

tt = sum(tvp);  %Total time;
sp = ceil(tt * fps);% Computing step points (sp) 

tv = linspace(0,tt,sp)'; 
% Time vector from 0 to via point time, with sp rows
spvp = [];
for i = 1:size(pt,1)
    if i ~= size(pt,1)
        spvp = [spvp, round(tvp(i) * fps)];  %step points of each via point
        tvvp{i} = linspace(0, tvp(i), spvp(i))';%time vector of via point
    else
        sp_sum = sum(spvp);
        tvvp{i} = linspace(0, tvp(i), abs(sp - sp_sum))';
    end
end

dqt = zeros(size(pt,1), n);
ddqt = zeros(size(pt,1), n);

% Compute the joint velocity for each via points
for vp = 1:size(pt,1)
    if any(vl ~= 0) || any(va ~= 0)
        [~, T_m] = PF_Forward_Kinematics(qt(vp,:), d, a, A);
        J = PF_Jacobian(T_m);   %Computes the Jacobian
        vlt = (1/sqrt(3)) * (ones(1,3) * vl(vp));%linear velocity terms
        vat = (1/sqrt(3)) * (ones(1,3) * va(vp));%angular velocity terms
        dqt(vp,:) = (pinv(J) * [vlt, vat]')';
    else
        %Apply heuristic in the joint space
            %get previous theta
        if vp == 1
            q_p = q0;
        else
            q_p = qt(vp-1, :);
        end
            %get next theta
        if vp == size(pt,1)
            dqt(vp, :) = zeros(1,n);%the last via point has angular veloc 0
        else
            q_n = qt(vp+1,:);
        end
        
        mp = qt(vp,:) - q_p; %angular coefficient of the line
        mn = qt(vp,:) - q_n; %angular coefficient of the line
        
        for j = 1:n
            if sign(mp(j)) ~= sign(mn(j))
                dqt(vp, j) = (mp(j) + mn(j)) / 2;
            else
                dqt(vp, j) = 0;
            end
        end
    end
end    


% Compute the joint acceleration for each via points
for idx = 1:size(pt,1)
        %Apply heuristic in the joint space
        %get previous angular velocity
    if idx == 1
        dq_p = zeros(1,n);  %angular acceleration starts from 0
    else
        dq_p = dqt(idx-1, :);
    end
        %get next angualar velocity
    if idx == size(pt,1)
        dq_n = zeros(1,n);  %the last via point has angular acceleration 0
    else
        dq_n = dqt(idx+1,:);
    end

    mp = dqt(idx,:) - dq_p; %angular coefficient of the line
    mn = dqt(idx,:) - dq_n; %angular coefficient of the line

    for j = 1:n
        if sign(mp(j)) ~= sign(mn(j))
            ddqt(idx, j) = (mp(j) + mn(j)) / 2;
        else
            ddqt(idx, j) = 0;
        end
    end
end


%Preallocating matrices for the output
q = [];
dq = [];
ddq = [];
    
% Fifth order polynomial function
for ii = 1:size(pt,1)
    qvp = [];
    dqvp = [];
    ddqvp = [];
    for i=1:n
        if ii == 1
            a0 = q0(i);
            a1 = 0;
            a2 = 0;
            a3 = -(20*q0(i) - 20*qt(ii, i) + 8*dqt(ii, i)*tvp(ii) - ...
                                     ddqt(ii, i)*tvp(ii)^2)/(2*tvp(ii)^3);
                                                 
            a4 = (30*q0(i) - 30*qt(ii, i) + 14*dqt(ii, i)*tvp(ii) - ...
                                    2*ddqt(ii, i)*tvp(ii)^2)/(2*tvp(ii)^4);
                                                
            a5 = -(12*q0(i) - 12*qt(ii, i) + 6*dqt(ii, i)*tvp(ii)- ...
                                      ddqt(ii, i)*tvp(ii)^2)/(2*tvp(ii)^5);
        else
            a0 = qt(ii-1, i);
            a1 = dqt(ii-1, i);
            a2 = ddqt(ii-1, i)/2;
            a3 = -(20*qt(ii-1, i) - 20*qt(ii, i) + 8*dqt(ii,i)*tvp(ii) +...
                    12 *  dqt(ii-1, i)*tvp(ii) - ddqt(ii,i)*tvp(ii)^2 + ...
                                  3*ddqt(ii-1, i)*tvp(ii)^2)/(2*tvp(ii)^3);
                                                 
            a4 = (30*qt(ii-1, i) - 30*qt(ii, i) + 14*dqt(ii,i)*tvp(ii) +...
                   16 * dqt(ii-1, i)*tvp(ii) - 2*ddqt(ii,i)*tvp(ii)^2 + ...
                                  3*ddqt(ii-1, i)*tvp(ii)^2)/(2*tvp(ii)^4);
                                                
            a5 = -(12*qt(ii-1, i) - 12*qt(ii, i) + 6*dqt(ii,i)*tvp(ii) +...
                      6 * dqt(ii-1, i)*tvp(ii) - ddqt(ii,i)*tvp(ii)^2 + ...
                                    ddqt(ii-1, i)*tvp(ii)^2)/(2*tvp(ii)^5);
        end
        
            
        %Assembling joint position coefficients
        q_cf = [a5 a4 a3 a2 a1 a0]; 
        
        %Assembling joint velocity coefficients
        dq_cf = [5*a5, 4*a4, 3*a3, 2*a2, a1];
        
        %Assembling joint acceleration coefficients
        ddq_cf = [20*a5, 12*a4, 6*a3, 2*a2]; 
        
        % Computing theta, d_theta, dd_theta (column vector)
        qvp = [qvp, polyval(q_cf,tvvp{ii})];
        dqvp = [dqvp, polyval(dq_cf,tvvp{ii})];
        ddqvp = [ddqvp, polyval(ddq_cf,tvvp{ii})];
    end
    q = [q; qvp];
    dq = [dq; dqvp];
    ddq = [ddq; ddqvp];
end


end