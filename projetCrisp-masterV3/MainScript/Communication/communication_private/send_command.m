function [ ] = send_command( m, field, command_dg, serialPort )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

empty = uint8(zeros(1,9));

fprintf('sending %s\n', field{1});
reply_dg = send(serialPort, command_dg);
if strcmp(field{1}, 'free')
    write_dg(m, field, empty, 1);
end
write_dg(m, field, reply_dg, 2);  

end

