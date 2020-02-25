%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Robot communication script
%
%   Script qui doit �tre appel� par le programme principale
%   en parallele (� l'aide de la fonction batch de la
%   Parallel Computing Toolbox).
%
%   Ce script partage de l'information avec le programme
%   principale � l'aide du maping d'un fichier.
%
%   Ce script est charg� de g�rer le trafic sur le bus RS485.
%   Le memmapfile contient une liste de commande et de r�ponses et
%   CommBot se charge d'envoyer les commandes et de mettre � jour
%   les r�ponses.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

folder = fullfile(fileparts(which('CommBot')),'..');
addpath(genpath(folder));

fprintf('Ouverture du fichier de communications s�rial CommBot!\n');

empty = uint8(zeros(1,9));

fprintf('Getting memmapfile\n');
m = get_memmapfile();

fprintf('Opening serial communication\n');
delete(instrfindall)
clear serialPort
% port = read_parameter('PORT');
port = get_Port();

% baud_rate = str2double(read_parameter('BAUD'));
baud_rate = 115200;
serialPort = serial(port);
set(serialPort, 'BaudRate',baud_rate);
set(serialPort, 'DataBits', 8);
set(serialPort, 'Parity', 'none');
set(serialPort, 'StopBits', 1);
set(serialPort, 'FlowControl', 'none');
set(serialPort, 'Terminator', 'LF');
set(serialPort, 'Timeout',0.001); 
fopen(serialPort);

%Todo: ajout� checkup
%   si erreur de lecture -> finish

fprintf('Starting to send commands\n');
% print_memmapfile(m);
pause(3)
fields=fieldnames(m.data(1));
n = length(fields);
c = [empty; empty; empty; empty; empty; empty];
DownloadMode = 0;
while true   
% tic;
for i = 1:n
    field = fields(i);
    command_dg = read_dg(m, field, 1);
    if command_dg(2) == 132 %Enter Download Mode
        DownloadMode = 1;
    end
    %Send command
    if ~isequal(command_dg, empty)
        s = field{1};
        if (DownloadMode == 0) || strcmp(s,'free')
        if strfind(s, 'c_')
            i = str2double(s(end));
            if ~isequal(c(i,:), command_dg)  %Commande diff�rente de la derni�re
                c(i,:) = command_dg;
                send_command( m, field, command_dg, serialPort )
            end
        else
            send_command( m, field, command_dg, serialPort )
        end
        end
    end
    if command_dg(2) == 133 % Quit download mode
        DownloadMode = 0;
    end
end

% fprintf('finished sending commands!\n');
% toc
% pause();
% pause(0.03);
end

fclose(serialPort);

