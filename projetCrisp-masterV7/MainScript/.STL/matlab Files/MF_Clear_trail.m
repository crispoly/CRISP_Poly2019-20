%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-23: CLEAR TRAIL <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will clear the trail in the graphical
% representation in each command or when the user click on the button
% Refer to section 4 of documentation for details. 
%==========================================================================
%% Clear trail path
function MF_Clear_trail()
%disp('pushed clear trail bottom');
Patch_data = getappdata(0,'patch_h');  %delete line
Tr = Patch_data(7);                    %delete line
%
setappdata(0,'xtrail',0); % used for trail tracking.
setappdata(0,'ytrail',0); % used for trail tracking.
setappdata(0,'ztrail',0); % used for trail tracking.
%
set(Tr,'xdata',0,'ydata',0,'zdata',0);
end