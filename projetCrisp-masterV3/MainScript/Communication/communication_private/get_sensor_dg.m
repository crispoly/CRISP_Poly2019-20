function [ dg ] = get_sensor_dg( name )
%get_dg Summary of this function goes here
%   Detailed explanation goes here

switch name
    case 'ls_1_1'
        dg = create_dg(2, 15, 0, 0, 0);
    case 'ls_1_2'
        dg = create_dg(2, 15, 1, 0, 0);
    case 'ls_2_1'
        dg = create_dg(3, 15, 0, 0, 0);
    case 'ls_2_2'        
        dg = create_dg(3, 15, 1, 0, 0);
    case 'ls_3_1'
        dg = create_dg(4, 15, 0, 0, 0);
    case 'ls_3_2'
        dg = create_dg(4, 15, 1, 0, 0);
    case 'ls_4_1'
        dg = create_dg(5, 15, 0, 0, 0);
    case 'ls_4_2'
        dg = create_dg(5, 15, 1, 0, 0);
    case 'ls_5_1'
        dg = create_dg(6, 15, 0, 0, 0);
    case 'ls_5_2'
        dg = create_dg(6, 15, 1, 0, 0);
    case 'ls_6_1'
        dg = create_dg(7, 15, 0, 0, 0);
    case 'ls_6_2'
        dg = create_dg(7, 15, 1, 0, 0);
    case 'pos_1'
        dg = create_dg(2, 6, 1, 0, 0);
    case 'pos_2'
        dg = create_dg(3, 6, 1, 0, 0);
    case 'pos_3'
        dg = create_dg(4, 6, 1, 0, 0);
    case 'pos_4'
        dg = create_dg(5, 6, 1, 0, 0);
    case 'pos_5'
        dg = create_dg(6, 6, 1, 0, 0);
    case 'pos_6'
        dg = create_dg(7, 6, 1, 0, 0);
    case 'tl_1'
        error('sensor command not implemented');
    case 'tl_2'
        error('sensor command not implemented');
    case 'tl_3'
        error('sensor command not implemented');
    case 'tl_4'
        error('sensor command not implemented');
    case 'tl_5'
        error('sensor command not implemented');
    case 'tl_6'
        error('sensor command not implemented');
    case 't_1'
        dg = create_dg(2, 6, 150, 0, 0);
    case 't_2'
        dg = create_dg(3, 6, 150, 0, 0);
    case 't_3'
        dg = create_dg(4, 6, 150, 0, 0);
    case 't_4'
        dg = create_dg(5, 6, 150, 0, 0);
    case 't_5'
        dg = create_dg(6, 6, 150, 0, 0);
    case 't_6'
        dg = create_dg(7, 6, 150, 0, 0);
    case 'Vmax_1'
        dg = create_dg(2, 6, 4, 0, 0);
    case 'Vmax_2'
        dg = create_dg(3, 6, 4, 0, 0);
    case 'Vmax_3'
        dg = create_dg(4, 6, 4, 0, 0);
    case 'Vmax_4'
        dg = create_dg(5, 6, 4, 0, 0);
    case 'Vmax_5'
        dg = create_dg(6, 6, 4, 0, 0);
    case 'Vmax_6'
        dg = create_dg(7, 6, 4, 0, 0);
    case 'Idemar_1'
        dg = create_dg(2, 6, 177, 0, 0);
    case 'Idemar_2'
        dg = create_dg(3, 6, 177, 0, 0);
    case 'Idemar_3'
        dg = create_dg(4, 6, 177, 0, 0);
    case 'Idemar_4'
        dg = create_dg(5, 6, 177, 0, 0);
    case 'Idemar_5'
        dg = create_dg(6, 6, 177, 0, 0);
    case 'Idemar_6'
        dg = create_dg(7, 6, 177, 0, 0);
    case 'CoupleP_1'
        dg = create_dg(2, 6, 172, 0, 0);
    case 'CoupleP_2'
        dg = create_dg(3, 6, 172, 0, 0);
    case 'CoupleP_3'
        dg = create_dg(4, 6, 172, 0, 0);
    case 'CoupleP_4'
        dg = create_dg(5, 6, 172, 0, 0);
    case 'CoupleP_5'
        dg = create_dg(6, 6, 172, 0, 0);
    case 'CoupleP_6'
        dg = create_dg(7, 6, 172, 0, 0);
    case 'CoupleI_1'
        dg = create_dg(2, 6, 173, 0, 0);
    case 'CoupleI_2'
        dg = create_dg(3, 6, 173, 0, 0);
    case 'CoupleI_3'
        dg = create_dg(4, 6, 173, 0, 0);
    case 'CoupleI_4'
        dg = create_dg(5, 6, 173, 0, 0);
    case 'CoupleI_5'
        dg = create_dg(6, 6, 173, 0, 0);
    case 'CoupleI_6'
        dg = create_dg(7, 6, 173, 0, 0);
    case 'VitesseP_1'
        dg = create_dg(2, 6, 234, 0, 0);
    case 'VitesseP_2'
        dg = create_dg(3, 6, 234, 0, 0);
    case 'VitesseP_3'
        dg = create_dg(4, 6, 234, 0, 0);
    case 'VitesseP_4'
        dg = create_dg(5, 6, 234, 0, 0);
    case 'VitesseP_5'
        dg = create_dg(6, 6, 234, 0, 0);
    case 'VitesseP_6'
        dg = create_dg(7, 6, 234, 0, 0);
    case 'VitesseI_1'
        dg = create_dg(2, 6, 235, 0, 0);
    case 'VitesseI_2'
        dg = create_dg(3, 6, 235, 0, 0);
    case 'VitesseI_3'
        dg = create_dg(4, 6, 235, 0, 0);
    case 'VitesseI_4'
        dg = create_dg(5, 6, 235, 0, 0);
    case 'VitesseI_5'
        dg = create_dg(6, 6, 235, 0, 0);
    case 'VitesseI_6'
        dg = create_dg(7, 6, 235, 0, 0);
    case 'PositionP_1'
        dg = create_dg(2, 6, 230, 0, 0);
    case 'PositionP_2'
        dg = create_dg(3, 6, 230, 0, 0);
    case 'PositionP_3'
        dg = create_dg(4, 6, 230, 0, 0);
    case 'PositionP_4'
        dg = create_dg(5, 6, 230, 0, 0);
    case 'PositionP_5'
        dg = create_dg(6, 6, 230, 0, 0);
    case 'PositionP_6'
        dg = create_dg(7, 6, 230, 0, 0);
    otherwise
        error('sensor command not implemented');
end

