function [ is_complete ] = set_VitesseI( VitesseI )
%[ is_complete ] = set_VitesseI( VitesseI )
%   LISTE DES PARAM�TRES
%       VitesseI:      Matrice colonne d'angle mesur�s par les capteurs
%               de la forme: VitesseI =[VitesseI1,VitesseI2,VitesseI3,VitesseI4,VitesseI5,VitesseI6]';
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(VitesseI(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 235, 0, VitesseI(i)), 1);
    end
end

end
