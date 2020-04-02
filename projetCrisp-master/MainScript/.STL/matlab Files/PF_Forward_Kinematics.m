%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-A: FORWARD KINEMATICS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will compute the homogeneous transformation
% matrices T. The function receives the Denavit-Hartenberg parameters and
% outputs a cell array formed by each joint T. The position vector of the
% last joint is also outputted. The inputs that are angles must be in
% degrees. Refer to section 4 of documentation for details.
%==========================================================================
function [P_XYZ, T] = PF_Forward_Kinematics(q, d, a, A)
%>>>>> FORWARD KINEMATICS BY DENAVIT-HARTENBERG REPRESENTATION <<<<<<
%Theta, d, a, Alpha are lists (1 row matrix) with n inputs
%       Where n is the number of links in the arm.
%T:     Joint Angles (theta)
%d:     Link offset
%a:     Link Length
%A:     Link Twist (alpha)
%n:     Robot degrees of freedom

n = length(q);
%% Compute T
%The homogeneous Transformation (Ai) is represented as the product of four
%   basic transformation (Rotation, Translation, Translation, Rotation):
%Ai = Rz,Thetai*Transz,di*Transx,ai*Rx,alphai

% Convert from degrees to radians (Computation in radians is faster)
q = deg2rad(q);
A = deg2rad(A);

% Preallocating matrices that will be used
T1_n = eye(4);
T{n} = zeros(4);

for i=1:n
    T_i = ...
   [cos(q(i)), -cos(A(i))*sin(q(i)), sin(A(i))*sin(q(i)),  a(i)*cos(q(i));
    sin(q(i)),  cos(A(i))*cos(q(i)),-sin(A(i))*cos(q(i)),  a(i)*sin(q(i));
            0,            sin(A(i)),           cos(A(i)),            d(i);
            0,                    0,                   0,              1];

    %Transformation matrix - T (from origin to respect to i), is obtained 
    %by multiplying all A_i matrices.
    T1_n = T1_n * T_i;
    T{i} = T1_n;
end

%x, y and z are obtained from the last Transformation matrix (T_0_n)
%i.e. the transformation matrix from the origin (0) to the end-effector (n)
%x, y and z are in the 4th column of the T matrix.
P_XYZ = T{n}((1:3),4)';
end
