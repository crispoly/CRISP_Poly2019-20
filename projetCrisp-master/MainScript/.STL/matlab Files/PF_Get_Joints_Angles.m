%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-M: GET JOINTS ANGLES <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will send a request to the joint actuator
% controller to obtain the current joint position.This function is hightly
% dependent on the robot servos, and servos controller used. It should be
% modified for specific robots. The function bellow works for the AX-12A
% SMART robotic arm. Refer to section 4 of documentation for details.
%==========================================================================
function [Theta_Command] = PF_Get_Joints_Angles(servos_id, DEFAULT_PORTNUM, DEFAULT_BAUDNUM)
%FUNCTION DESCRIPTION:
        %1 - Load Dynamixel Library;
        %2 - Get Servos response;
        %3 - Get the servos position;
        %4 - Convert servo position into angle;
        
%Constants:
num_servos = 7;
P_PRESENT_POSITION = 36;        %Necessary value for Dynamixel Library

%>>>1: Load Dynamixel Library.   
loadlibrary('dynamixel','dynamixel.h');

%>>>2: Get Servos response. 
response = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
pause on
%>>>3: Get the servos position (Range from 0 to 1024).
servo_position = zeros(1,num_servos);
if response == 1
    for n = 1:1:7
         servo_position(n) = int32(calllib('dynamixel','dxl_read_word', ...
                                        servos_id(n), P_PRESENT_POSITION));
    end
end

%>>>4: Remove servo 3 and 5 from the list
%Servo 3 and 5 are in the same axis of joint 2 and 3 (only the right servo
%is necessary).
Theta_Command = [servo_position(1), servo_position(2),servo_position(4), ...
                                    servo_position(6),servo_position(7)];
calllib('dynamixel','dxl_terminate');
unloadlibrary('dynamixel');
%>>> END OF FUNCTION        
end