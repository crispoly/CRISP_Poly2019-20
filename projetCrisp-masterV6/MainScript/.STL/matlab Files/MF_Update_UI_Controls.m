%==========================================================================
% >>>>>>>>>>> FUNCTION MF-2: UPDATE TRANSFORMATION MATRIX <<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will .... 
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Update_UI_Controls()
%% Load files and variables
HD = evalin('base', 'HD');      %Get handles as HD from base workspace
RP = evalin('base', 'RP');      %Load Robot Parameters
S = evalin('base', 'S');        %Load Settings (from base workspace)
H = evalin('base', 'H');        %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
a = RP.a';
d = RP.d';
alpha = RP.alpha';


% get current position
if cn == 1
    qc = S.value{'home_q'};
else
    try
        qc = H(cn-1).q(end,:);
    catch
        qc = S.value{'home_q'};
    end
end

%%
%Get the number of the matrix chosen (Eg.: T_03 will return Tn = 3)
Tn = get(HD.transformation_options,'Value');
    
% Call Forward Kinematics and get the T matrix.
[pos, Tm] = PF_Forward_Kinematics(qc, d, a, alpha);
Tm = Tm{Tn};   %T_Matrix is the transformation matrix chosen

set(HD.transformation_table, 'Data', round(Tm, 3));
%------

%Update current end-effector and joint position (text box below messages)
set(HD.current_ee_pos, 'String', num2str(round(pos, 4)));
set(HD.current_joint_pos, 'String', num2str(round(qc, 2)));
%-------

%Update sliders and static text on UI.
jn = get(HD.jointn_menu, 'Value');
qmin = RP.j_range{jn}(1);
qmax = RP.j_range{jn}(2);
%Joint n slider
set(HD.slider_jointn, 'Value', qc(jn));
set(HD.slider_jointn, 'Min', qmin);
set(HD.slider_jointn, 'Max', qmax);
set(HD.slider_jointn, 'SliderStep',[1/qmax, 10/qmax]);
set(HD.jointn_value, 'String', num2str(round(qc(jn)), 2));
%-------

%Enabling Gripper ui
if S.value{'enable_ee'}
    g_status = 'on';    %gripper will be enabled in Commands tab
    gn = S.value{'dof'} + 1;
    qming = RP.j_range{gn}(1);
    qmaxg = RP.j_range{gn}(2);
    set(HD.gripper_slider, 'Min', qming);
    set(HD.gripper_slider, 'Max', qmaxg);
    set(HD.gripper_slider, 'SliderStep',[1/qmaxg, 10/qmaxg]);
else
    g_status = 'off';
end
set(HD.open_gripper_bt, 'Enable', g_status);
set(HD.close_gripper_bt, 'Enable', g_status);
set(HD.opening_txt, 'Enable', g_status);
set(HD.gripper_angle_value, 'Enable', g_status);
set(HD.gripper_slider, 'Enable', g_status);

%-------
% Update frames
% show = true: display the axes on the screen; false: delete the axes
if strcmp(get(HD.disp_link_frame, 'Checked'), 'on')
    MF_Plot_Links_frame(0);
elseif strcmp(get(HD.display_cg, 'Checked'), 'on')
    MF_Plot_CG_frames(0);
end

end
    
%>>> END OF FUNCTION 