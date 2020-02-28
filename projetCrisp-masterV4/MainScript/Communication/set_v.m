function [ is_complete ] = set_v( v )
%[ is_complete ] = set_v( q )
%   LISTE DES PARAMÈTRES
%       v:      Matrice colonne de vitesses
%               de la forme: v=[v1,v2,v3,v4,v5,v6]';
%               où vi sont en rpm.


global map enabled_ddl;

for i = 1:6
    if (~isnan(v(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 1, 0, 0, v(i)), 1);
    end
end

end

