%==========================================================================
% >>>>>>>> FUNCTION MF-3: Creating GUI for Robot Representation <<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will create a new figure to host the axes of
% the graphical animation
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Creating_RR_GUI()
%% Configuring size and position
screen_size = get( groot, 'Screensize' );
Position = [screen_size(3)/2, 0, screen_size(3)/2, screen_size(4)];

%  Create and then hide the UI as it is being constructed.
%  (AF: animation figure)
AF = figure('Visible','off','Position',Position, 'Name','ANIMATION WINDOW');
assignin('base', 'AF', AF);     %save AF in base workspace
% AF =  see hoe to change name to Simulation Window

%% Configuring the menu bar
% RR_fig.MenuBar = 'none';    % Hide standard menu bar menus.
% >>> Tool menu
Tools_menu = uimenu(AF,'Label', 'Tools');
Tm1 = uimenu(Tools_menu,'Label','Repeat Simulation', 'Callback',...
                                                      @RS_mi_Callback );
Tm2 = uimenu(Tools_menu,'Label', 'Clear trail', 'Callback',...
                                              @Clear_trail_mi_Callback);
                                             
Tm3 = uimenu(Tools_menu,'Label', 'Display CG frames', 'Callback',...
                                                 @Show_cg_mi_Callback);

Tm4 = uimenu(Tools_menu,'Label', 'Display Reference frame',...
                               'Callback',@Show_ref_frame_mi_Callback);
                                   
Tm5 = uimenu(Tools_menu,'Label', 'Display Links frames',...
                             'Callback',@Show_links_frame_mi_Callback);
                                             
Tm6 = uimenu(Tools_menu,'Label', 'Plot Graphs', 'Callback',...
                                              @Plot_graphs_mi_Callback);
Tm7 = uimenu(Tools_menu,'Label', 'Exit', 'Callback',@Exit_mi_Callback);

% >>> Views menu
View_menu = uimenu(AF,'Label', 'Change View');
vm1 = uimenu(View_menu,'Label', 'View 1', 'Callback', @view_Callback);
vm2 = uimenu(View_menu,'Label', 'View 2', 'Callback', @view_Callback);
vm3 = uimenu(View_menu,'Label', 'View 3', 'Callback', @view_Callback);
vm4 = uimenu(View_menu,'Label', 'View 4', 'Callback', @view_Callback);
vm5 = uimenu(View_menu,'Label', 'View 5', 'Callback', @view_Callback);
vm6 = uimenu(View_menu,'Label', 'View 6', 'Callback', @view_Callback);

%% Configuring Toolbar
% RR_fig.Toolbar = 'figure';  % Display the standard toolbar
Toolbar = findall(AF,'Type','uitoolbar');

%% Creating axes
% R_GR = axes('Units','pixels','Position',[0,0, Position(3:4)]);
R_GR = axes();
AF.Visible = 'on';
MF_Init_Graph_Rep();
zoom (1.7)
%% Callbacks
    function RS_mi_Callback(hObject,eventdata) 

    end

    function  Clear_trail_mi_Callback(hObject,eventdata)
        
    end

    function  Show_cg_mi_Callback(hObject,eventdata)

    end
    function  Show_ref_frame_mi_Callback(hObject,eventdata)

    end
    function  Show_links_frame_mi_Callback(hObject,eventdata)

    end

    function  Plot_graphs_mi_Callback(hObject,eventdata)
        
    end


    function  Exit_mi_Callback(hObject,eventdata)
        
        
        
    end


    function view_Callback(source,eventdata, callbackdata)
        switch source.Label
            case 'View 1'
                
            case 'View 2'
                
            case 'View 3'
            case 'View 4'
            case 'View 5'
            case 'View 6'
        end
    end

                
end

