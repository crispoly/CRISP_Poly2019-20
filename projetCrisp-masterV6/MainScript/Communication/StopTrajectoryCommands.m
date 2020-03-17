function [ is_complete ] = StopTrajectoryCommands()
%[ is_complete ] = startCalib( q )
%   Start all calibration
is_complete = true;

global map enabled_ddl;

for i = 1:6
    if (enabled_ddl(i))
        write_dg(map, strcat("c_",num2str(i)), create_dg(i+1, 9, 3, 2, 0), 1);
    end
end

end

