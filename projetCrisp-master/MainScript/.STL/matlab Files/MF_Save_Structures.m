%==========================================================================
% >>>>>>>>>>>>>>>> FUNCTION MF-20: LOAD STRUCTURES FILES <<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will load structures to base workspace on
% software opening
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Save_Structures(sname, varargin)
% sname: structure name the function needs saving
% varargin: variables the function needs update before saving in mat file
%    for H structure, varargin must have the field names followed by the
%    variable values.
%         Eg.: varargin = {'q', q, 'dq', dq, 'ddq', ddq} etc. so then the
%         function will know in which field of the structure the variable
%         should be updated
%%
%get command number to save the variables in the correct 'layer' in
S = evalin('base', 'S');                                       %structure
cn = S.value{'cn'};                                             

Settings_path = which('SETTINGS.mat');
Rdata_path = which('ROBOT_DATA.mat');
GR_data_path = which('GR_DATA.mat');
History_path = which('HISTORY.mat');
Messages_path = which('MESSAGES.mat');


% S = evalin('base', 'S');    %Get Settings structure (S) from base workspace
% RP = evalin('base', 'RP');  %Get Settings structure (S) from base workspace


switch sname
    case 'H'    %History'
        H = evalin('base', 'H'); %Get H structure from base workspace
        if nargin > 1
            for i = 1:size(varargin, 2)
                if isfield(H, varargin{i})   %update field with input given
                    H(cn).(varargin{i}) = varargin{i+1};
                end
            end
        end
        save(History_path, 'H', '-append');       %Save the mat file.
        assignin('base', 'H', H);                 %Save in base workspace
        
    case 'S'
        
end

        



end
