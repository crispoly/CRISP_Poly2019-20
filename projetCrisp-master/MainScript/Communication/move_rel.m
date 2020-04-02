function [  ] = move_rel( q )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here



global map enabled_ddl;

for i = 1:6
    if (~isnan(q(i)) && enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 4, 1, 0, q(i)), 1);
    end
end

end

