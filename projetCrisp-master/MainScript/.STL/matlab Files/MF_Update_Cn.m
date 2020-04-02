%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-18: UPDATE COMMAND NUMBER <<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will update the command number that is used in
% the history structure and primary functions.
% When the GUI is started this number is set to 1, and each time the user
% gives the GUI a command (eg.: move arm by coordinate), this number is
% incremented by 1, this is used as a index for saving the position,
% velocity, acceleration and torque in the history structure. Refer to
% section 4 of documentation for details.
%==========================================================================
function MF_Update_Cn()
S = evalin('base', 'S');                    % Load S from base workspace
S.value{'cn'} = S.value{'cn'} + 1;          % Update cn
assignin('base', 'S', S);                   % Save in base workspace

Settings_path = which('SETTINGS.mat');      % Get Settings path
save(Settings_path, 'S', '-append');        % Save the mat file.         
end