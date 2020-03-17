%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-11: PAUSE PROGRAM <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will pause the program by a determined time
% (in seconds). This funciton is used in Program tab, where a pause between
% commands can be added by the user.
% Refer to section 4 of documentation for details. 
%==========================================================================
function SF_Pause_Program(In)
%Function making reference to Program Command: Add a pause
%Pause the program by the time inputted by the user.
tic
if ischar(In.time)
    time = str2double(In.time);
else
    time = In.time;
end

if isnan(time)
    time = In.time;
end

add_ti = toc;
pause(time + add_ti);
%>>> END OF FUNCTION