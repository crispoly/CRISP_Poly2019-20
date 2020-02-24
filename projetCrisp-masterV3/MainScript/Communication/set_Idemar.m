function [ is_complete ] = set_Idemar( Idemar )
%[ Idemar ] = get_p()
%LA FONCTION DONNE LES VALEURS D'ANGLES DES CAPTEURS
%   PARAMÈTRE DE FONCTION :
%       Idemar:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: Idemar=[Idemar1,Idemar2,Idemar3,Idemar4,Idemar5,Idemar6]'
%       
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (~isnan(Idemar(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 5, 177, 0, Idemar(i)), 1);
    end
end

end

% % DDL #1
% dg = read_dg(map, 'pos_1', 2);
% q(1) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #2
% dg = read_dg(map, 'pos_2', 2);
% q(2) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #3
% dg = read_dg(map, 'pos_3', 2);
% q(3) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #4
% dg = read_dg(map, 'pos_4', 2);
% q(4) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #5
% dg = read_dg(map, 'pos_5', 2);
% q(5) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #6
% dg = read_dg(map, 'pos_6', 2);
% q(6) = swapbytes(typecast(dg(5:8), 'uint32'));



