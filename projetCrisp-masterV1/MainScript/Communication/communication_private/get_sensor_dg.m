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
    otherwise
        error('sensor command not implemented');
end

