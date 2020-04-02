function [ is_complete ] = skipCalib( )
%[ is_complete ] = skipCalib( q )
%   Skip all Calibration
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 9, 1, 2, 10), 1);
    end
end

end

