%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-5: GET JOINTS ANGLES <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will .... 
% Refer to section 6.4.1 for details. 
%==========================================================================
%% >>>>>>> FUNCTION 5: GET JOINTS ANGLES <<<<<<<<
function SF_Get_Angles(function_variables, eventdata, handles)
global Theta_Command Theta_World
%THIS FUNCTION WILL HANDLE THE INSTRUCTIONS OPTIONS: SAVE JOINTS ANGLES
%(IN THE ADD BUTTON) AND SAVE JOINTS AUTOMATICALLY (A TIME WILL BE PASSED
%TO THIS FUNCTION AND THE JOINTS WILL BE RECORDED EVERY X SECONDS uNTIL THE
%BUTTON STOP IS PRESSED).

%Save the number of division of all servos (The robot must be connected, 
%Simulate Mode off).

Theta_Command = Get_Servos_Angles(handles.id, handles.port_number, ...
                                                handles.default_baudnum );

%Convert Command set to World set
Theta_World = Angles_Conversion(Theta_Command, length(Theta_Command), 8);

%Update sliders after convertion
Update_Theta(eventdata, handles);

%>>> END OF FUNCTION