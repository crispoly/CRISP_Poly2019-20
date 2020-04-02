function [ ] = init_communications(app, commBotInit)
%init_communications Initialisation de la layer communication
%   Maping du memmapfile
%   Démarrage du CommBot
%   Initialisation des variables globales (communication)


global map commBot;


fprintf('Initialisation des communications\n');

%% Maping du memmapfile
map = get_memmapfile();

%% Démarrage du CommBot
init_commfile();
fprintf('Appuyer sur un touche lorsque la fenêtre CommBot.m est exécutée')
pause();

%% Initialisation des paramètres et position initiales du robot
init_moteurs();

end

