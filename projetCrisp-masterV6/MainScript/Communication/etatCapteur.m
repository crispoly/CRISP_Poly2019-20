function [ capteur ] = etatCapteur( )
%[ capteur ] = etatCapteur( )
%LA FONCTION DONNE LES VALEURS DES CAPTEURS
%   PARAM�TRE DE FONCTION :
%       capteur.ls: tableau contenant les info des Limit switch
%                   =[LS1 LS2...LS6] o� LS: limit switch [1,-1 ou 0] selon 
%                   lim atteinte +-
%       capteur.lc: tableau contenant les info des capteurs des limiteur 
%                   de couple. LC prends la valeur 0 pour ok et 1 si le
%                   limiteur est d�clench� =[LC1 LC2...LC6]
%
%% Initalisation 

%                               � COMPL�TER SVP ********* Dummy code 

capteur.ls=zeros(1,6);
capteur.lc=zeros(1,6);

end




