%==========================================================================
% >>>>>>>>>>>>>> FUNCTION MF-11: LOAD TABLE OF COORDINATES <<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will open a window for the user to choose the
% excel spreadsheet with the coordinates, then the function will check the
% coordinates in the table and if valid, it will be saved in base workspace
% under the variable name TB. Refer to section 4 of documentation for
% details.
%==========================================================================
function MF_Load_Table_Coord()
%open an window to the user choose the table (excel)
[filename, folder] = uigetfile('*');
ffname = fullfile(folder, filename);    %full filename

% Attempt to open the file
try
    TP = xlsread(ffname);
catch
    try
        TP = open(ffname);
    catch
        MF_Update_Message(13, 'warnings');
        return
    end
end

% Make sure all rows are number (it does not check here if the points are
% reacheable or not)
if ~isnumeric(TP)
    MF_Update_Message(14, 'warnings');
    return
end

if size(TP,2) < 6
    MF_Update_Message(24, 'warnings');
end

% saving in base workspace
assignin('base', 'TP', TP); 

% update message about load status
MF_Update_Message(7, 'notice');
end
