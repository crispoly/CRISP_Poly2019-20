%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-F: JACOBIAN MATRIX <<<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will compute the Jacobian matrix numerically
% (wihtout taking the partial derivative of the position function). Refer
% to Robot Dynamics and Control (SPONG, VIDYASAGAR, 1989; p. 112 - 115) and
% section 4 of documentation for details. 
%==========================================================================
function J = PF_Jacobian(T_m)
% T_m: Homogeneous transform matrices (cell array w/ all n matrices from FK)
% T: Vector with the theta angles (array 1xn)
% n: number of degrees of freedom (number of variables)
% J: Jacobian matrix (6xn: 3xn for the linear velocity and 3xn angular vel)

n = length(T_m);
k = [0 0 1]';   %unit vector k_hat

% Preallocating the Jacobian matrices
Jv = zeros(3,n);
J_omega = zeros(3,n);
for i=1:n
    if i == 1
        R0_i_1 = eye(3);            % Rotation matrix from 0 to 0;
        d_im1_n = T_m{n}((1:3),4);   % p_vector    

    else
        R0_i_1 = T_m{i-1}((1:3),(1:3)); % Rotation matrix
        d_im1_n = T_m{n}((1:3),4) - T_m{i-1}((1:3),4);   %position vector
    end
    
    zi_1 = R0_i_1 * k;              % z term i equation XX

    Jv(:,i) = cross(zi_1, d_im1_n);  % Jacobian (for linear velocity)
    J_omega(:,i) = zi_1;            % Jacobian (for angular velocity)
end

%Assemblying Jacobian matrix
J = [Jv ; J_omega];
end




