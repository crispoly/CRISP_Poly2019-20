%==========================================================================
% >>>>>>>>>>>>>>>>> FUNCTION MF-7: RESET HISTORY STRUCTURE <<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - May 14th, 2016.

% DESCRIPTION: This function will clear history structure and reset command
% number. Refer to section 4 of documentation for details.
%==========================================================================
function MF_Clear_History()


%% Loading variables
M = evalin('base', 'M');
H = evalin('base', 'H');
S = evalin('base', 'S');
%%

answer = questdlg(M(28).warnings,'Confirmation'); 
if strcmp(answer,'No')
    return
elseif strcmp(answer, 'Yes')
    History_path = which('HISTORY.mat');    %get file path
    settings_path = which('SETTINGS.mat');
    H_fields = fieldnames(H);
    H_size = size(H);
    if H_size(2) > 1
        H(2:H_size(2)) = [];   %deleting 'layers' (indices - nonscalar) of H
    end
    
    % Deleting fields of layer 1;
    for i = 1:length(H_fields)
        H(1).(H_fields{i}) = [];
    end
    
    % Reset command number
    S.value{'cn'} = 1;
    
    %Save the empty H in base workspace and .mat file
    assignin('base', 'H', H);                 %Save H in base workspace
    save(History_path, 'H', '-append');       %Save the mat file.
    save(settings_path, 'S', '-append');
    assignin('base', 'S', S);                 %Save S in base workspace
    MF_Update_Message(12, 'notice');          %Update message
    MF_Init_Graph_Rep();                      %Update animation window
    MF_Load_Settings_table();                 %Update table in Settings tab
    MF_Update_UI_Controls();
else
    return
end

%Clear GR_Data

end