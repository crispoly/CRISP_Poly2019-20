function [ reply_dg ] = send_other( command_dg )
%send_other Envoi une commande inhabituel sur le bus.
%   La fonction �crit le datagram de commande dans le field �free� de la
%   memory map et attend la r�ponse. La commande est ensuite effac�e.

global map;
empty = uint8(zeros(1,9));

write_dg( map, "free", command_dg, 1 );

finish = false;
while ~finish
    pause(0.05);
    reply_dg = read_dg(map, "free", 2);
    finish = ~isequal(reply_dg, empty);
end
write_dg( map, "free", empty, 2 );


end

