function [ ls ] = get_ls( )
%get_ls Retourne les plus recentes valeurs des limit switches
%   Retourne une matrice 2x6 où chaque ligne est un ddl et où la première
%   colonne est la limit switch #1 et la deuxième la #2.



global map enabled_ddl;

ls = [NaN, NaN, NaN, NaN, NaN, NaN;
      NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("ls_", num2str(i), "_1"), 1);
        ls(i,1) = ~swapbytes(typecast(dg(5:8), "uint32"));
        dg = read_dg(map, strcat("ls_", num2str(i), "_2"), 2);
        ls(i,2) = ~swapbytes(typecast(dg(5:8), "uint32"));        
    end
end

% % DDL #1
% dg = read_dg(map, 'ls_1_1', 1);
% ls(1,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_1_2', 2);
% ls(1,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #2
% dg = read_dg(map, 'ls_2_1', 1);
% ls(2,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_2_2', 2);
% ls(2,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #3
% dg = read_dg(map, 'ls_3_1', 1);
% ls(3,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_3_2', 2);
% ls(3,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #4
% dg = read_dg(map, 'ls_4_1', 1);
% ls(4,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_4_2', 2);
% ls(4,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #5
% dg = read_dg(map, 'ls_5_1', 1);
% ls(5,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_5_2', 2);
% ls(5,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% % DDL #6
% dg = read_dg(map, 'ls_6_1', 1);
% ls(6,1) = ~swapbytes(typecast(dg(5:8), 'uint32'));
% dg = read_dg(map, 'ls_6_2', 2);
% ls(6,2) = ~swapbytes(typecast(dg(5:8), 'uint32'));



