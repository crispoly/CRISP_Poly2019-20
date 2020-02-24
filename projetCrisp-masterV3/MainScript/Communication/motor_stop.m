function [  ] = motor_stop( n )
%stop MST command.
%   Arrete les moteurs où n est vrai

global map;

for i = 1:6
    if (n(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 3, 0, 0, 0), 1);
    end
end

end

