function [ ] = init_communications(app, commBotInit)
%init_communications Initialisation de la layer communication
%   Maping du memmapfile
%   D�marrage du CommBot
%   Initialisation des variables globales (communication)


global map commBot;


fprintf('Initialisation des communications\n');

%% Maping du memmapfile
map = get_memmapfile();

%% D�marrage du CommBot
init_commfile();
fprintf('Appuyer sur un touche lorsque la fen�tre CommBot.m est ex�cut�e')
pause();

%% Initialisation des param�tres et position initiales du robot
init_moteurs();

end

