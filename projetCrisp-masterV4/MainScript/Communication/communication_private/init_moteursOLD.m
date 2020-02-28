function [ ] = init_moteurs(app)
%init_moteurs Initialise les variables globals des controlleurs
%   Detailed explanation goes here

global enabled_ddl;
app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Initialisation des moteurs...");
app.Terminal.scroll('bottom');
if enabled_ddl(1)
    init_moteur1();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 1 (Pectoral) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(2)
    init_moteur2();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 2 (Épaule) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(3)
    init_moteur3();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 3 (Bras) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(4)
    init_moteur4();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 4 (Coude) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(5)
    init_moteur5();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 5 (Avant-Bras) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(6)
    init_moteur6();
    app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Moteur 6 (Poignet) initialisé.");
    app.Terminal.scroll('bottom');
end

if enabled_ddl(7)
     %Ajouter main
end

app.Terminal.Items{length(app.Terminal.Items)+1} = sprintf('%s', "Fin de l'initialisation des moteurs.");
app.Terminal.scroll('bottom');
end

