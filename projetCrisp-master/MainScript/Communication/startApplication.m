function [ is_complete ] = startApplication( )
%[ is_complete ] = stopApplication( )
%   Stop all programs

is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 129, 1, 0, 0), 1);
    end
end

end

