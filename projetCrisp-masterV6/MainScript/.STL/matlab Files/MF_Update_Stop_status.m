%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-19: UPDATE STOP STATUS <<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - May 16th, 2016.

% DESCRIPTION: This function will update the stop status in Settings
% structure. The other functions check this status whenever they start a
% new command, if this is status is set to true then the robot interrupts
% its movement. Refer to section 4 of documentation for details.
%==========================================================================
function MF_Update_Stop_status(status)
% status: either true or false (boolean type)
S = evalin('base', 'S');   %Load Settings from base workspace

S.value{'stop'} = status;

% saving in base workspace
assignin('base', 'S', S); 
end