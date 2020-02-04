function [ is_complete ] = set_t( t )
%[ is_complete ] = set_t( t )
%   LISTE DES PARAMÈTRES
%       t:      Matrice colonne de couple
%               de la forme: t=[t1,t2,t3,t4,t5,t6]';


global map enabled_ddl;

for i = 1:6
    if (~isnan(t(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 155, 0, t(i)), 1);
    end
end

end

