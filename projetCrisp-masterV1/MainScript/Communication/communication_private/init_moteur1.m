function [ ] = init_moteur1( )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

send_other(create_dg(2, 5, 31, 0, 0));    %set reinit bldc regulation
pause(0.5);
send_other(create_dg(2, 5, 159, 0, 7));    %set commutation mode
send_other(create_dg(2, 5, 134, 0, 2));    %set current regulation loop delay [50us]
send_other(create_dg(2, 5, 133, 0, 1));    %set velocity regulation loop delay [50us]

%=== motor/module settings ===
send_other(create_dg(2, 5, 253, 0, 24));	% motor poles
send_other(create_dg(2, 5, 6, 0, 4700)); 	% max current
send_other(create_dg(2, 5, 177, 0, 6000));  % start current
send_other(create_dg(2, 5, 25, 0, 5230));    %set thermal winding time constant [ms]

%=== encoder/initialization settings ===
send_other(create_dg(2, 5, 250, 0, 25600)); 	% encoder steps
send_other(create_dg(2, 5, 251, 0, 0)); 		% encoder direction
send_other(create_dg(2, 5, 249, 0, 1));  		% init encoder mode
send_other(create_dg(2, 5, 244, 0, 1000));      %set init sine delay [ms]
send_other(create_dg(2, 5, 241, 0, 100));		% init encoder speed
send_other(create_dg(2, 5, 165, 0, 0));    		%set encoder offset

send_other(create_dg(2, 5, 252, 0, 0));    %set hall interpolation
send_other(create_dg(2, 5, 254, 0, 0)); 	% hall sensor invert

%=== motion settings ===

send_other(create_dg(2, 5, 9, 0, 5));      %set motor halted velocity [rpm]
send_other(create_dg(2, 5, 4, 0, 500)); 	% max ramp velocity
send_other(create_dg(2, 5, 11, 0, 1000));  % acceleration
send_other(create_dg(2, 5, 146, 0, 1)); 	% enable velocity ramp
send_other(create_dg(2, 5, 7, 0, 500)); 	% target reached velocity
send_other(create_dg(2, 5, 10, 0, 5)); 	% target reached distance

%=== current PID values ===
send_other(create_dg(2, 5, 172, 0, 550)); 	% P
send_other(create_dg(2, 5, 173, 0, 200)); 	% I

%=== velocity PID values ===
send_other(create_dg(2, 5, 234, 0, 5000));	% P
send_other(create_dg(2, 5, 235, 0, 100));	% I

%=== position PID values ===
send_other(create_dg(2, 5, 230, 0, 10)); 	% P

send_other(create_dg(2, 5, 164, 0, 3));    %set activate stop switch

%SGP 77, 0, 1     % start tmcl application after power up


% send_other(create_dg(2, 5, 1, 0, 0)    %set actual position
%5, 163, 0, 0    %set clear once

end

