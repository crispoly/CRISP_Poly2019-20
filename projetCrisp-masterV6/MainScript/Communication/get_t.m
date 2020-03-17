function [ t ] = get_t()
%[ t ] = get_t()
%LA FONCTION DONNE LES VALEURS DES COUPLES DES MOTEURS
%   PARAMÈTRE DE FONCTION :
%       t:      Matrice colonne de couples mesurés par les capteurs
%               de la forme: t=[t1,t2,t3,t4,t5,t6]'
%       

global map enabled_ddl;
t = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("t_", num2str(i)), 2);
        t(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end

% % DDL #1
% dg = read_dg(map, 't_1', 2);
% t(1) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #2
% dg = read_dg(map, 't_2', 2);
% t(2) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #3
% dg = read_dg(map, 't_3', 2);
% t(3) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #4
% dg = read_dg(map, 't_4', 2);
% t(4) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #5
% dg = read_dg(map, 't_5', 2);
% t(5) = swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #6
% dg = read_dg(map, 't_6', 2);
% t(6) = swapbytes(typecast(dg(5:8), 'uint32'));


% todo: convertir les couples -> mA -> Nm moteur -> réducteurs

