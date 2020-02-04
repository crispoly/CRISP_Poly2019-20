function [ is_complete ] = set_VitesseP( VitesseP )
%[ is_complete ] = set_VitesseP( VitesseP )
%   LISTE DES PARAMÈTRES
%       VitesseP:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: VitesseP =[VitesseP1,VitesseP2,VitesseP3,VitesseP4,VitesseP5,VitesseP6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(VitesseP(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 234, 0, VitesseP(i)), 1);
    end
end

end
