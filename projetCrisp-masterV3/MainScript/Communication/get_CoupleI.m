function [ CoupleI ] = get_CoupleI()
%[ CoupleI ] = get_CoupleI()
%LA FONCTION ...
%       

global map enabled_ddl;
CoupleI = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("CoupleI_", num2str(i)), 2);
        CoupleI(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



