function [ PositionP ] = get_PositionP()
%[ PositionP ] = get_PositionP()
%LA FONCTION ...
%       

global map enabled_ddl;
PositionP = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("PositionP_", num2str(i)), 2);
        PositionP(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



