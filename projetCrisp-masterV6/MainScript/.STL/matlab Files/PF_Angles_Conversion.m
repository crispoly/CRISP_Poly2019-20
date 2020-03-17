%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-N: ANGLES CONVERSION <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will convevrt the joints position from one set
% to another.
% Refer to section 4 of documentation for details.
%==========================================================================
function [Theta_converted] = PF_Angles_Conversion(Theta, Joints, Set)
%There are 5 sets of angles used by the program:
%The angles returned by the Inverse Kinematics function: World angles.
%The angles used in Forward Kinematics (Theta1, Theta2, Theta3, Theta4)
%The angles as seen by the servos, from 0 to 300.
%Command values from 0 to 1024.
%Joint angles +/-150.
%Theta_World Theta_FK Theta_Joint Theta_Motor Theta_Command
%Conversion is made by a linear equation: f(theta) = a*theta+b
%Eg. for joint 1 from Motor to FK: A1 = -Theta(n) + 150; >>> a= -1; b = 150

%'Set' is the conversion type:
%1: From World to FK
%2: From World to Joint
%3: From World to Motor
%4: From World to Command
%5: From FK to World
%6: From Joint to World
%7: From Motor to World
%8: From Command to World

%Note: Not all possibilities are inserted here, if you need a conversion, 
%      say from Motor to FK; you first convert from Motor to World and then 
%      from World to FK in the function that calls this one.

%T_World_Old is used to convert from World to joint, motor or command and
%vice-versa. Other functions can call this function and provide only one
%joint angle (eg. joint 3 world) and this is not enough to determine the
%angle converted to Command for instance, because the joint 3 command value
%will depend on the angle of joint 2.
T_World_Old = getappdata(0, 'Theta_World_Old');
%Note: The firt time the SMART_UI runs, Theta_World_Old will be empty, but
%when the program reach the end it will write the home position angle in
%this variable.

if length(Theta) ~= length(Joints)
%display error here: the arrays does not have the same length
%exit function
elseif any(Joints>5)
%display error here: There maximum number of joints is 5
%exit function

end
%Works for both configuration 1 and 2.
a = {[1, -1, 1 , 1, 1],[1 1 1 1 -1],[1, 1, 1, -1, -1], ...
[1, -1, 1, -1, -1].*(1024/300),[1, -1, 1, 1, 1], [1 1 1 1 -1], ...
[1, 1, 1, -1, -1], [1, -1, 1, -1, -1].*(300/1024)};

b = {[0 0 -90 180 0], [0 -45 0 0 70], [150 105 150 150 210], ...
[150 105 150 150 210].*(1024/300), [0 0 90 -180 0], [0 45 0 0 70],...
[-150 -105 -150 150 210], [-150 105 -150 150 210].*(300/1024)};


for i = 1:1:5     %For all joints, convert angle Theta
if any(Joints == i)      %using the coefficients a and b.
    n = find(Joints == i);
    Theta_converted(n) = a{Set}(i)*Theta(n) + b{Set}(i);
end
end

%Update T_World_Old:
for x = 1:1:length(Joints)
if Set<4 %From 1 to 4, Theta is always Theta_World
    T_World_Old(Joints(x)) = Theta(x);
elseif Set>4%From 5 to 8, Theta_converted is the Theta_World
    T_World_Old(Joints(x)) = Theta_converted(x);
end
end
setappdata(0, 'Theta_World_Old', T_World_Old);  

end
%>>>END OF FUNCTION