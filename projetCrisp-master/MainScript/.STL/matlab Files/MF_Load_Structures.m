%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-12: LOAD STRUCTURES FILES <<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will .... 
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Load_Structures()
Settings_path = which('SETTINGS.mat');
Rdata_path = which('ROBOT_DATA.mat');
GR_data_path = which('GR_DATA.mat');
History_path = which('HISTORY.mat');
Messages_path = which('MESSAGES.mat');

Robot_data = matfile(Rdata_path,'Writable',true);  %load as matfile
History = matfile(History_path,'Writable',true);  %load as matfile
Settings = matfile(Settings_path,'Writable',true);  %load as matfile
Messages = matfile(Messages_path,'Writable',true);  %load as matfile

RP = Robot_data.RP;  %Read the variable topo from the MAT-file.
LD = Robot_data.LD;  %Read the variable topo from the MAT-file.
H = History.H;      %Load History
S = Settings.S;     %Load Settings
AS = Settings.AS;     %Load Additional Settings
M = Messages.M;      %Load History


assignin('base', 'RP', RP);
assignin('base', 'H', H);
assignin('base', 'S', S);
assignin('base', 'AS', AS);
assignin('base', 'LD', LD);
assignin('base', 'M', M);

end
