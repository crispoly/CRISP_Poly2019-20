function [ q ] = get_p()
%[ q ] = get_p()
%LA FONCTION DONNE LES VALEURS D'ANGLES DES CAPTEURS
%   PARAMÈTRE DE FONCTION :
%       q:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: q=[q1,q2,q3,q4,q5,q6]'
%       

global map enabled_ddl;
q = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("pos_", num2str(i)), 2);
        q(i) = swapbytes(typecast(dg(5:8), "int32"));        
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



