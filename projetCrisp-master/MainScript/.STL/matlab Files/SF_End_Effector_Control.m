%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-5: END-EFFECTOR CONTROL <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will create a smooth trajectory taking the
% current end-effectory position (gripper aberture) and target position.
% Then the function will call Drive actuators function to make the movement
% in the robot if connected. The animation is not made as the
% representation of the gripper (or other end-effector) is static. This
% function works as a intermediate for the GUI (user inputs) and the
% primary function responsible for generating the trajectory. Refer to
% section 4 of documentations for details.
%==========================================================================
function SF_End_Effector_Control(In)
% In.qt (target q), In.time or In.vl;

%>>> END OF FUNCTION