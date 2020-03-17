function [ Idemar ] = get_Idemar()
%[ Idemar ] = get_Idemar()
%LA FONCTION DONNE LES VALEURS D'ANGLES DES CAPTEURS
%   PARAMÈTRE DE FONCTION :
%       q:      Matrice colonne d'angle mesurés par les capteurs
%               de la forme: Idemar=[Idemar1,Idemar2,Idemar3,Idemar4,Idemar5,Idemar6]'
%       

global map enabled_ddl;
Idemar = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("Idemar_", num2str(i)), 2);
        Idemar(i) = swapbytes(typecast(dg(5:8), "int32"));        
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



