function [  ] = init_commfile( )
%reset_commfile Initialisation du fichier de communication.
%   Les commandes sont d'abbord initialis�es comme vides, puis les
%   commandes r�curentes sont initialis�es.

global map enabled_ddl;

fprintf('r�initialisation du fichier de communication\n');

empty = uint8(zeros(1,9));

fields = fieldnames(map.data(1));
n = length(fields);
for i = 1:n
    field = fields(i);
    write_dg(map, field, empty, 1);
end
for i = 1:6 % initialisation des 6 contr�leurs
    ddl = num2str(i);
    if enabled_ddl(i)
        write_dg(map, strcat("pos_",ddl), get_sensor_dg(strcat("pos_",ddl)), 1);
        write_dg(map, strcat("ls_",ddl,"_1"), get_sensor_dg(strcat("ls_",ddl,"_1")), 1);
        write_dg(map, strcat("ls_",ddl,"_2"), get_sensor_dg(strcat("ls_",ddl,"_2")), 1);
        write_dg(map, strcat("t_",ddl), get_sensor_dg(strcat("t_",ddl)), 1);
        write_dg(map, strcat("Vmax_",ddl), get_sensor_dg(strcat("Vmax_",ddl)), 1);
        write_dg(map, strcat("Idemar_",ddl), get_sensor_dg(strcat("Idemar_",ddl)), 1);
        write_dg(map, strcat("CoupleP_",ddl), get_sensor_dg(strcat("CoupleP_",ddl)), 1);
        write_dg(map, strcat("CoupleI_",ddl), get_sensor_dg(strcat("CoupleI_",ddl)), 1);
        write_dg(map, strcat("VitesseP_",ddl), get_sensor_dg(strcat("VitesseP_",ddl)), 1);
        write_dg(map, strcat("VitesseI_",ddl), get_sensor_dg(strcat("VitesseI_",ddl)), 1);
        write_dg(map, strcat("PositionP_",ddl), get_sensor_dg(strcat("PositionP_",ddl)), 1);
    end
end
% 
% %Controleur #2
% if enabled_ddl(2)
%     write_dg(map, "pos_2", get_sensor_dg("pos_2"), 1);
%     write_dg(map, "ls_2_1", get_sensor_dg("ls_2_1"), 1);
%     write_dg(map, "ls_2_2", get_sensor_dg("ls_2_2"), 1);
%     % write_dg(map, "tl_2", get_sensor_dg("tl_2"), 1);
%     write_dg(map, "t_2", get_sensor_dg("t_2"), 1);
%     write_dg(map, "Vmax_2", get_sensor_dg("Vmax_2"), 1);
%     write_dg(map, "Idemar_2", get_sensor_dg("Idemar_2"), 1);
% end
% 
% %Controleur #3
% if enabled_ddl(3)
%     write_dg(map, "pos_3", get_sensor_dg("pos_3"), 1);
%     write_dg(map, "ls_3_1", get_sensor_dg("ls_3_1"), 1);
%     write_dg(map, "ls_3_2", get_sensor_dg("ls_3_2"), 1);
%     % write_dg(map, "tl_3", get_sensor_dg("tl_3"), 1);
%     write_dg(map, "t_3", get_sensor_dg("t_3"), 1);
%     write_dg(map, "Vmax_3", get_sensor_dg("Vmax_3"), 1);
%     write_dg(map, "Idemar_3", get_sensor_dg("Idemar_3"), 1);
% end
% 
% %Controleur #4
% if enabled_ddl(4)
%     write_dg(map, "pos_4", get_sensor_dg("pos_4"), 1);
%     write_dg(map, "ls_4_1", get_sensor_dg("ls_4_1"), 1);
%     write_dg(map, "ls_4_2", get_sensor_dg("ls_4_2"), 1);
%     % write_dg(map, "tl_4", get_sensor_dg("tl_4"), 1);
%     write_dg(map, "t_4", get_sensor_dg("t_4"), 1);
%     write_dg(map, "Vmax_4", get_sensor_dg("Vmax_4"), 1);
%     write_dg(map, "Idemar_4", get_sensor_dg("Idemar_4"), 1);
% end
% 
% if enabled_ddl(5)
%     write_dg(map, "pos_5", get_sensor_dg("pos_5"), 1);
%     write_dg(map, "ls_5_1", get_sensor_dg("ls_5_1"), 1);
%     write_dg(map, "ls_5_2", get_sensor_dg("ls_5_2"), 1);
%     % write_dg(map, "tl_5", get_sensor_dg("tl_5"), 1);
%     write_dg(map, "t_5", get_sensor_dg("t_5"), 1);
%     write_dg(map, "Vmax_1", get_sensor_dg("Vmax_5"), 1);
%     write_dg(map, "Idemar_1", get_sensor_dg("Idemar_5"), 1);
% end
% 
% if enabled_ddl(6)
%     write_dg(map, "pos_6", get_sensor_dg("pos_6"), 1);
%     write_dg(map, "ls_6_1", get_sensor_dg("ls_6_1"), 1);
%     write_dg(map, "ls_6_2", get_sensor_dg("ls_6_2"), 1);
%     % write_dg(map, "tl_6", get_sensor_dg("tl_6"), 1);
%     write_dg(map, "t_6", get_sensor_dg("t_6"), 1);
%     write_dg(map, "Vmax_6", get_sensor_dg("Vmax_6"), 1);
%     write_dg(map, "Idemar_6", get_sensor_dg("Idemar_6"), 1);
% end

end

