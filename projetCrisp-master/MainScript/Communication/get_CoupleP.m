function [ CoupleP ] = get_CoupleP( )
%[ CoupleP ] = get_CoupleP( )
%LA FONCTION ...
%       

global map enabled_ddl;
CoupleP = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("CoupleP_", num2str(i)), 2);
        CoupleP(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



