function [ is_complete ] = set_p( q )
%[ is_complete ] = set_p( q )
%   LISTE DES PARAMÈTRES
%       q:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: q=[q1,q2,q3,q4,q5,q6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(q(i)) && enabled_ddl(i))
        %write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 4, 0, 0, q(i)), 1);
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 9, 0, 2, q(i)), 1); % Write to global value #0
    end
end

end

