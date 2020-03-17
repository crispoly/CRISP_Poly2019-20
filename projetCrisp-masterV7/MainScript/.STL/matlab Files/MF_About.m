%==========================================================================
% >>>>>>>>>>>> FUNCTION MF-9: ABOUT SOFTWARE <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will create a new figure displaying
% information abou the software, the author, year, and version
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_About()
screen_size = get( groot, 'Screensize' );
fig_pos = screen_size(3:4)/4;
pos = [fig_pos, screen_size(4)/2 screen_size(3)/4];
 
%  Create and then hide the UI as it is being constructed.
About_fig = figure('Visible','on','Position',pos, 'Name','About Software', ...
                    'Resize', 'off');

About_fig.MenuBar = 'none';    % Hide standard menu bar menus.

% Construct the text.
softwareName = 'SMART AX-12A ROBOTIC ARM SIMULATOR';
createdby = 'Developed by Diego Varalda de Almeida.';
version = 'version 2.0 - Released on June 11th of 2016.';
disclaimer = 'This software is part of the final project presented to the UNIVERSIDADE DE MOGI DAS CRUZES in partial fulfillment of the requirements for the degree of Mechanical Engineer.';

about_txt = strcat(createdby, '\n', version, '\n', disclaimer);
msg = sprintf(about_txt); %assembled message (with inputs)
softwareName_uictrl = uicontrol('Style','text',...
                         'Position',[0 0 pos(3) pos(4)],...
                         'Max', 10,...
                         'HorizontalAlignment', 'center',...
                         'FontSize', 12,...
                         'String',softwareName);
                     
about_uictrl = uicontrol('Style','text',...
                         'Position',[0 0 pos(3) pos(4)/1.4],...
                         'Max', 10,...
                         'HorizontalAlignment', 'left',...
                         'FontSize', 10,...
                         'String',msg);
% Save_bt = uicontrol('Style','pushbutton','String','SAVE','Position',...
%                                     bt_pos, 'Callback', @save_bt_Callback);