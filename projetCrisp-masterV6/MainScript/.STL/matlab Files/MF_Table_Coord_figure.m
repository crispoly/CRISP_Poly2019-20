%==========================================================================
% >>>>>>>>>>>> FUNCTION MF-XX: TABLE OF COORDINATES FIGURE <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will create a new figure displaying a table
% of coordinates loaded by the user.
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Table_Coord_figure()
%Attempt to load Table of Points (from base workspace)
try
    TP = evalin('base', 'TP'); 
catch
     MF_Update_Message(17, 'warnings');
     return;
end

%% Configuring size and position
screen_size = get( groot, 'Screensize' );
fig_pos = screen_size(3:4)/4;
Position = [fig_pos, screen_size(3)/3, screen_size(4)/2];

%Close figure if already opened (to reload)
if ishandle(findobj('type','figure','name','TABLE OF COORDINATES'))
    close(findobj('type','figure','name','TABLE OF COORDINATES'));
end

% Create a figure and insert the table inside to display to the user
TP_fig = figure('Position',Position, 'Name', 'TABLE OF COORDINATES');

TP_fig.MenuBar = 'none';    % Hide standard menu bar menus.

% Create a table
RPT = uitable(TP_fig,'Data', TP);


% Construct the static text.
txt_pos = [0,Position(4)-30, 300,20];
txt = uicontrol(TP_fig,'Style','text',...
                'String','Enter the starting position (x, y, z) or table row number',...
                'Position',txt_pos);

% Construct the textbox.
start_tb_pos = [15,Position(4)-50, 200, 20];
start_pos = uicontrol(TP_fig,'Style','edit',...
                'String','',...
                'Position',start_tb_pos);
            
% Construct the button.
bt_pos = [Position(3)-120,Position(4)-50, 100,50];
Reorder_bt = uicontrol('Style','pushbutton','String','REORDER TABLE','Position',...
                                    bt_pos, 'Callback', @reorder_bt_Callback);
                                


%% Callback Functions
%%
    function reorder_bt_Callback(hObject,callbackdata)
        start_point = str2num(get(start_pos, 'String'));
        
        if ~isempty(start_point)
            if size(start_point, 2) == 3
                SPF_Reordering_CAD_Coordinates(start_point, TP);
            elseif size(start_point, 2) == 3
                SPF_Reordering_CAD_Coordinates(TP(start_point), TP);
            else
                SPF_Reordering_CAD_Coordinates(TP(1,:), TP);
            end
        else
            SPF_Reordering_CAD_Coordinates(TP(1,:), TP);
        end
        
    end
end