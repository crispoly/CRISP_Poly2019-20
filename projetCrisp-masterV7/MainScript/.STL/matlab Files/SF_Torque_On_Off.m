%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-13: TURN TORQUE ON/OFF <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will turn off or on the torque in the robot
% joints in order to allow the user to move it around freely (as in
% teach-pendent robots). For heavy robots the torque cannot be completely
% be turned off so a gravity compensation is made. The control system is
% turned off in this function.
% Refer to section 6.4.1 for details. 
%==========================================================================
function SF_Torque_On_Off(id, Torque_Status, handles)
%DEFAULT_PORTNUM : COM Port number
%DEFAULT_BAUDNU : Speed of communication 
%id: all servos id of the arm
%Torque_Status 
%   0: Interrupts the power of motor, turning the torque off.
%   1: Generates Torque by returning the power to the motor.

port_num = handles.port_number;
baud_num = handles.default_baudnum;

P_Torque_Enable=24; %address of Torque Enable on the RAM
%Load the dynamixel library
loadlibrary('dynamixel','dynamixel.h');
%look if dynamixel can be open
response = calllib('dynamixel', 'dxl_initialize', port_num, baud_num);
pause on

if response == 1 
    for i=1:1:length(id) % For every servo in the id list
    calllib('dynamixel','dxl_write_word',id(i),P_Torque_Enable,Torque_Status);
    end
else
    %>>>3: Update Message box.
    handles.messages = 'Failed to open USB_Dynamixel';
    set(handles.messages_txt, 'string', handles.messages);
end
%close Dynamixel device
calllib('dynamixel','dxl_terminate');
%Unload the dynamixel library
unloadlibrary('dynamixel');