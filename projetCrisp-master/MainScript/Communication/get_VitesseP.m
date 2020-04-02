function [ VitesseP ] = get_VitesseP()
%[ Vmax ] = get_Vmax()
%LA FONCTION ...
%       

global map enabled_ddl;
VitesseP = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("VitesseP_", num2str(i)), 2);
        VitesseP(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



