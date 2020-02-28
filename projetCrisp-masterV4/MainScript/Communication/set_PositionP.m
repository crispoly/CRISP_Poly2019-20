function [ is_complete ] = set_PositionP( PositionP )
%[ is_complete ] = set_PositionP( PositionP )
%   LISTE DES PARAMÈTRES
%       PositionP:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: PositionP =[PositionP1,PositionP2,PositionP3,PositionP4,PositionP5,PositionP6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(PositionP(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 230, 0, PositionP(i)), 1);
    end
end

end
