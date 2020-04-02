function [ ] = set_actual_p( q )
%set_actual_p Set la position actuelle.
%   Permet de calibrer les ddl.
%   LISTE DES PARAMÈTRES
%       q:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: q=[q1,q2,q3,q4,q5,q6]';


global map enabled_ddl;

for i = 1:6
    if (enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 1, 0, q(i)), 1);
    end
end

end
