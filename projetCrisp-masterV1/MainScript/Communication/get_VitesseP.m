function [ Vmax ] = get_Vmax()
%[ Vmax ] = get_Vmax()
%LA FONCTION ...
%       

global map enabled_ddl;
Vmax = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("Vmax_", num2str(i)), 2);
        Vmax(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



