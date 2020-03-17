function [ VitesseI ] = get_VitesseI()
%[ VitesseI ] = get_VitesseI()
%LA FONCTION ...
%       

global map enabled_ddl;
VitesseI = [NaN, NaN, NaN, NaN, NaN, NaN];

for i = 1:6
    if enabled_ddl(i)
        dg = read_dg(map, strcat("VitesseI_", num2str(i)), 2);
        VitesseI(i) = swapbytes(typecast(dg(5:8), "int32"));        
    end
end



