function [ is_complete ] = set_Vmax( Vmax )
%[ is_complete ] = set_Vmax( Vmax )
%   LISTE DES PARAMÈTRES
%       Vmax:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: Vmax =[Vmax1,Vmax2,Vmax3,Vmax4,Vmax5,Vmax6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(Vmax(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 4, 0, Vmax(i)), 1);
    end
end

end
