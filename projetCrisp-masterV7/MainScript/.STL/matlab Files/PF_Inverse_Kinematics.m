%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-B: INVERSE KINEMATICS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function computes the inverse kinematics of the robotic
% arm. The technique used is the Dumped Least Square together with Newton's
% method for optimization used to achieve the desired orientation. If the
% robot has fewer than 6 dof, then the orientation cannot be satisfied in
% all axes. The output is a matrix (qm) of size:(sp x n => step points by
% dof). Refer to section 4 of documentation for details.
%==========================================================================
function qm = PF_Inverse_Kinematics(p_o, q0, s)
% p_o = position and orientation vector (x, y, z, rx, ry, rz)(step pts x 6)
%                 rx, ry, rz: rotation angle in degrees around the axis xyz
% q0 = initial 'guess' or 'position' for the joints s = [Rx Ry Rz]
% orientation specification: [1 1 1] all axes orientation will be
% considered. [1 1 0]: only orientation around x and y will be considered,
% and so on...
%% GET THE NECESSARY VALUES
RP = evalin('base', 'RP');                 %Load Robot Parameters
S = evalin('base', 'S');          % Load Settings (from base workspace)
a = RP.a'; d = RP.d'; alpha = RP.alpha';   %D-H parameters

n = length(q0);

m_error = S.value{'ik_error'} * ones(1,n); %Maximum permitted error vector.

max_iter = S.value{'ik_iternum'};          %Maximum number of iterations.
%% ==========================================
% Pre-allocating the matrix that will store theta angles for each point
qm = zeros(size(p_o, 1), length(q0));
Tmatrix(:,:,n) = zeros(4,4);
nci = 0;    %not computed itens
if ~exist('s', 'var'); s = [0 0 0]; end

%set orientation to 0 if not given
if size(p_o, 2) < 4
	p_o = [p_o, zeros(size(p_o, 1), 3)];   
end
    
for i=1:length(p_o(:,1));
    [~, T_m] = PF_Forward_Kinematics(q0, d, a, alpha);
    
    
    
    T_d = Goal_Transform(p_o(i, 4:end), p_o(i,1:3));
    
    
    error = error_f(T_m{n}, T_d, s);%initial error (posit. and orientation) 
    
    q = q0;
    lambda = 20;       %lambda factor;
    iter = 0;          %iteration counter
    we = 50;
    
%     Method 1: Dumped least square, used to approximate the end-effector
%     position to the neighbourhood of the goal position (position only,
%     orientation not considered)
    while any(abs(error(1:3)) > abs(m_error(1:3)))   
        J = PF_Jacobian(T_m);   %Computes the Jacobian
        q = DSL(q, J, lambda, we, n, error);
        q = Correcting_angles(q);
        
        %Update ee position and compute errors
        [~, T_m] = PF_Forward_Kinematics(q, d, a, alpha);
        error = error_f(T_m{n}, T_d, s);
        
        iter = iter + 1;    %Increment of iteration number.
        if iter > max_iter
        %             disp('REACHED MAXIMUM NUMBER OF ITERATIONS');
            nci = [nci; i];
            break
        end
    end 
    iter = 0;
    
%     Method 2: Newton-Raphson used to find the final position and
%     orientation of the end-effector (uses optimization technique)
    while any(abs(error) > abs(m_error))
        J = PF_Jacobian(T_m);   %Computes the Jacobian
        q = NR(q, J, T_m{n}, T_d);
        
        q = Correcting_angles(q);
        %Update ee position and compute errors
        [~, T_m] = PF_Forward_Kinematics(q, d, a, alpha);
        error = error_f(T_m{n}, T_d, s);
        
        iter = iter + 1;    %Increment of iteration number.
        if iter > max_iter
        %             disp('REACHED MAXIMUM NUMBER OF ITERATIONS');
            nci = [nci; i];
            break
        end
    end
    Tmatrix(:,:,i) = T_m{n}- T_d; %#delete this (for checking errors only)
    %Update initial theta angles
    q0 = q;
    qm(i,:) = q;
end
end

%% METHODS
function q = DSL(q, J, lambda, we, n, error)
dq = (J' * inv(J * J' + lambda ^ 2  * eye(n))) * we * error';
q = q + dq';  %Update theta angle
end

function q = NR(q, J, Ta, Td)
    r = residual(Ta, Td);
    
    if size(J) == size(J')
        Jinv = inv(J);
    else
        Jinv = pinv(J);
    end
    
    dq = Jinv * r';
    q = q + dq';  %Update theta angle
end

%% Functions
function goal_T = Goal_Transform(orient, pos)
%   Multiply the 3 rotation matrix for the 3 angles
%   Return a 3x3 rotation matrix;
    goal_T = eye(4);
    goal_T(1:3, 1:3) = rotx(orient(1)) * roty(orient(2)) * rotz(orient(3));
    goal_T(1:3,4) = pos';
end


function r = residual(Ta, Td)
    na = Ta(1:3,1); oa = Ta(1:3,2); aa = Ta(1:3,3); pa = Ta(1:3,4);
    nd = Td(1:3,1); od = Td(1:3,2); ad = Td(1:3,3); pd = Td(1:3,4);
    %Residual position as described by GOLDENBERG et. al (1985)
    r(1) = na' * (pd - pa);
    r(2) = oa' * (pd - pa);
    r(3) = aa' * (pd - pa);
    
    %Residual orientation vector (for yaw-pitch-roll angles)
%     r(4) = atan2((oa' * ad), (aa' * ad)) + 180;
%     r(5) = atan2(((na' * ad)*cos(r(4)) + (oa' * ad) * sin(r(4))),(aa' * ad));
%     r(6) = atan2((-(na' * nd)* sin(r(4)) + (oa' *  nd)*cos(r(4))), ...
%                 (-(na' * oa)*sin(r(4)) + (oa' * od) * cos(r(4))) );                

    %Residual orientation vector (for a set of x,y,z rotation axes)
    r(4) = 0.5* (aa' * od - ad' * oa);
    r(5) = 0.5* (na' * ad - nd' * aa);
    r(6) = 0.5* (oa' * nd - od' * na);
end

function theta = Correcting_angles(q)
% wrap angles for revolute joints
    theta = zeros(size(q));
    for i = 1:size(q,1)
        q_row = q(i,:);
        k = q_row > 360;
        q_row(k) = rem(q_row(k), 360);

        k = q_row < -360;
        q_row(k) = -rem(q_row(k), 360);
        theta(i,:) = q_row;
    end
end

function delta = error_f(Tc, Td, s)
    %extract rotation matrices
    Rc = Tc(1:3,1:3); Rd = Td(1:3,1:3);
    %orientation error
    O_err  = [s(1) * ((Rd(:,1)'* Rc(:,1))-1),...
              s(2) * ((Rd(:,2)'* Rc(:,2))-1),...
              s(3) * ((Rd(:,3)'* Rc(:,3))-1)];
    %s: sigma factor (if the jth direction needs specifying)
	wo = -1; %orientation weight
    delta = [ (Td(1:3,4) - Tc(1:3,4))', wo * O_err ];
end