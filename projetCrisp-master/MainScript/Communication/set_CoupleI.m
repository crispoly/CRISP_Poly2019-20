function [ is_complete ] = set_CoupleI( CoupleI )
%[ is_complete ] = set_CoupleI( CoupleI )
%   LISTE DES PARAMÈTRES
%       CoupleI:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: CoupleI =[CoupleI1,CoupleI2,CoupleI3,CoupleI4,CoupleI5,CoupleI6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(CoupleI(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 173, 0, CoupleI(i)), 1);
    end
end

end
