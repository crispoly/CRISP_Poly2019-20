%==========================================================================
% >>>>>>>>>>>>>>>> FUNCTION MF-8: LOADING SETTINGS TABLE <<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will xxx
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Load_Settings_table()
HD = evalin('base', 'HD');
S = evalin('base', 'S');

Settings_table = {};

  for i = 1:1:height(S)     %Each row of Settings
    try
        %Use str2num to convert string to a list of numbers
        %It is necessary because Instructions section send angles as a
        %   string not as numbers.
        if isnumeric(S.value{i})
            Settings_table{i,2} = num2str(S.value{i});
            Settings_table{i,1} = num2str(S.param{i});
        else
            Settings_table{i,2} = S.value{i};
            Settings_table{i,1} = S.param{i};
        end
    catch
    end
  end
set(HD.settings_table,'Data', Settings_table);
end