%==========================================================================
% >>>>>>>>>>>> FUNCTION MF-XX: LOAD ROBOT DATA TO PROGRAM <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will load an external .mat file with the robot
% data. The file loaded is checked before passin it to base workspace.
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Load_Robot_Data()
    uiopen('load')
    %Validate the file loaded (using RP.Properties.Description)
    try
        valid_msg = RP.Properties.Description;
        %compare both strings
        if strcmp(valid_msg, 'Valid Smart GUI robot parameters table'); 
            isvalidfile = true;
        else
            isvalidfile = false;
        end
    catch
        isvalidfile = false;
    end

    % Save program table in workspace for future use
    if isvalidfile
        save('ROBOT_DATA.mat', 'RP', 'LD', '-append');    % Save file
        assignin('base', 'RP', RP);   %save parameters table (P) in base workspace
        assignin('base', 'LD', LD);   %save parameters table (P) in base workspace
    else
        MF_Update_Message(3, 'warnings');   
        return
    end

    % Display the loaded file in the robot parameters table handle
    MF_Load_Robot_param_table;
end