%==========================================================================
% >>>>>>>>>>>> FUNCTION MF-9: LOADING ROBOT PARAMETERS TABLE <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will create a new figure displaying a table
% for the user to edit the parameters of the robot, such as: D-H
% parameters, mass of each link, joints range, Inertia, links colors, etc.
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Load_Robot_param_table()
%% Loading variables
S = evalin('base', 'S');   %Load Settings from base workspace
n = S.value{'dof'};

%% Configuring size and position
screen_size = get( groot, 'Screensize' );
fig_pos = screen_size(3:4)/4;
Position = [fig_pos, screen_size(3:4)/1.75];
 
%  Create and then hide the UI as it is being constructed.
RPT_fig = figure('Visible','off','Position',Position, 'Name', ...
                                                      'ROBOT PARAMETERS');

RPT_fig.MenuBar = 'none';    % Hide standard menu bar menus.

% Construct the buttons.
save_bt_pos = [Position(3)-120,Position(4)-50, 100,50];
Save_bt = uicontrol('Style','pushbutton','String','SAVE','Position',...
                              save_bt_pos, 'Callback', @save_bt_Callback);
                          
load_param_bt_pos = [Position(3)-280 , Position(4)-50, 130,50];
load_param_bt = uicontrol('Style','pushbutton','String','LOAD PARAMETERS','Position',...
                   load_param_bt_pos, 'Callback', @load_param_bt_Callback);

%% Setting table 
%get the folder where ROBOT_DATA is located
if exist('ROBOT_DATA.mat') ~= 0
    Robot_data_path = which('ROBOT_DATA.mat');
    Parameters = matfile(Robot_data_path,'Writable',true); %load as matfile
    RP = Parameters.RP;
else
    return
end

row_names = RP.Properties.VariableNames; %getting fields names in RP table
col_names = linspace(1,n,n);
nc = n; %number of columns in the table
if S.value{'enable_ee'}
    col_names = {col_names, 'End-Effector'};
    nc = nc + 1;
end

RP.color{nc} = [0.8, 0.8, 0.8]; %Setting a color to end-effector 
                                              % (PS: The user can change)

                                              
%% Converting table to string so it can be loaded in handle table
tf = RP;
tf_cell = table2cell(RP);   %table converted to cell

%Converting to string (cts: converted table to string)
for row = 1:size(tf,1)
    for col=1:size(tf,2)
        cts(row, col) = {num2str(tf_cell{row, col})};
    end
end
edit_col = boolean(ones(1,nc)); %set the editable columns

% Creating UITable and attributing properties
RPT = uitable(RPT_fig,'Data',cts','ColumnName',col_names,...
    'ColumnEditable', edit_col, 'RowName', row_names, 'ColumnWidth',{80},...
    'CellEditCallback', @table_edit, 'CellSelectionCallback',@cell_selection);

%Extend the table to the size of its columns
RPT.Position(3) = RPT.Extent(3);
RPT.Position(4) = RPT.Extent(4);
RPT_fig.Visible = 'on'; %set visibility to on.

%% Callback Functions
%%
    function table_edit(hObject,callbackdata)
        %*** INSERT CODE TO CHECK TO CHECK THE USER INPUTS****
%         numval = eval(callbackdata.EditData);
%          r = callbackdata.Indices(1)
%          c = callbackdata.Indices(2)
%          hObject.Data{r,c} = numval;
     
             
             
    end

%%
    function cell_selection(hObject,callbackdata)
     r = callbackdata.Indices(1);   %get selection row
     MF_Update_Message(r, 'robotP');
             
    end

%%
    function save_bt_Callback(hObject,callbackdata)
        %Show confirmation of save
        M = evalin('base', 'M');   %Load Messages
        answer = questdlg(M(31).warnings,'Confirmation'); 
        if strcmp(answer,'No')
            MF_Update_Message(14,'notice');              % Display message
            return
        elseif strcmp(answer, 'Yes')
            table = get(RPT, 'Data')'; %get the table from the handle

            % Reconverting to UItable to table array
            for r_idx = 1 : size(table, 1)
                for c_idx = 1 : size(table, 2)
                    if isnan(str2double(table{r_idx, c_idx}))
                        if isempty(str2num(table{r_idx, c_idx}))
                            RP{r_idx, c_idx}{:} = table{r_idx, c_idx};
                        else
                            RP{r_idx, c_idx}{:} = str2num(table{r_idx, c_idx});
                        end
                    else
                        RP(r_idx, c_idx) = num2cell(str2double(table{r_idx, c_idx}));
                    end
                end
            end

            save('ROBOT_DATA.mat', 'RP', '-append');    % Save file
            MF_Update_Message(8,'notice');              % Display message
            MF_Clear_History();                         % Clear history
            SPF_Importing_CAD();                        % Run SF_Import_CAD
            
            %Load ROBOT DATA again to save as mat file
            load(Robot_data_path);
            uisave({'RP', 'LD'}, 'ROBOT_DATA_');
        end
    
    %Load structures files to workspace again
    MF_Load_Structures();
    end


    function load_param_bt_Callback(hObject,callbackdata)
        MF_Load_Robot_Data();
    end

end