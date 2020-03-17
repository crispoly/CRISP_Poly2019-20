function [ is_complete ] = set_CoupleP( CoupleP )
%[ is_complete ] = set_CoupleP( CoupleP )
%   LISTE DES PARAMÈTRES
%       CoupleP:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: CoupleP =[CoupleP1,CoupleP2,CoupleP3,CoupleP4,CoupleP5,CoupleP6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(CoupleP(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 172, 0, CoupleP(i)), 1);
    end
end
end
