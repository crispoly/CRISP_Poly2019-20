%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-1: UPDATE MESSAGES <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will .... 
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Update_Message(mn, fname, inputs)
% mn: messge number (M(mn).fname) - integer number
% fname: field name in M structure (eg: robotP, or settings) - string
% inputs: message inputs (cell array), applicable for some messages only
%      in the message use (%0.2f) for input numbers and (%s) for input text
% M structure:
% M(mn).settings
% M(mn).commands
% M(mn).programs
% M(mn).notice
% M(mn).warnings
% M(mn).animW
% M(mn).robotP
% M(mn).simulation
% M(mn).controlS

HD = evalin('base', 'HD');
%Load message structure from base workspace
M = evalin('base', 'M');


%Check if the inputs variables was passed to the function
if exist('inputs', 'var')
    if ~iscell(inputs)
        try
            inputs = num2cell(inputs); %convert to cell array if not
        catch
            inputs = {};               %create an empty cell array
        end
    end
else
    inputs = {};
end

msg_txt = getfield(M(mn), fname);   %get message from M strucute
previous_msg = get(HD.messages_txt, 'String');
divider = ' ';
if ~isempty(msg_txt)%if message exists in M structure
%     msg_ass = strcat(previous_msg,'\n', divider, '\n\n', msg_txt);
    msg_ass = strcat('\n\n', msg_txt);
    %check message number of inputs
    ni = strfind(msg_txt,'%');
    if size(inputs, 2) ~= size(ni, 2)
        inputs = inputs(1 : min(length(inputs), length(ni)));
    end

    msg = sprintf(msg_ass, inputs{:}); %assembled message (with inputs)
    
    set(HD.messages_txt, 'String', msg); %set message in handle
end
%>>>END OF FUNCTION 