%==========================================================================
% >>>>>>>>>>>>>> FUNCTION MF-13: PLOT BASE REFERENCE FRAME <<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will plot base frame on the robot
% representation in animation window. The function checks if
% Tools>Reference Frames is checked and then create the axes frames in
% robot 0 coordinate. The color for the axes follow a standar for
% coordinates frames: X: red; Y: green; Z: blue. Refer to section 4 of
% documentation for details.
%==========================================================================
function MF_Plot_Base_frame(show)
%Load and assemble variables
RP = evalin('base', 'RP');    % Load Robot parameters (from base workspace)
AF = evalin('base', 'AF');    % Load figure (Animation Figure)

% show = true: display the axes on the screen; false: delete the axes
if ~exist('show', 'var')
    HD = evalin('base', 'HD');    % Load Handles (from base workspace)
    if strcmp(get(HD.disp_ref_frames, 'Checked'), 'on')
        show = true;
    else
        show = false;
    end
end

try
    figure(AF);
catch
    return
end
%% Display axes
if show
    show_axes(RP);
else    %If the axes lines exist, delete it.
    delete_axes()
end

%% Functions 
    function show_axes(RP)
        axis_length = ceil(norm(RP.d + RP.a)/length(RP.d))*2.5; 

        % Creating base frame vertices
        Vbx = [[0; axis_length], [0; 0], [0; 0]];
        Vby = [[0; 0], [0; axis_length], [0; 0]];
        Vbz = [[0; 0], [0; 0], [0; axis_length]];

        x_axis = plot3(Vbx(:, 1), Vbx(:, 2), Vbx(:, 3),'r');
        y_axis = plot3(Vby(:, 1), Vby(:, 2), Vby(:, 3),'g');
        z_axis = plot3(Vbz(:, 1), Vbz(:, 2), Vbz(:, 3),'b');

        plotted_axes = [x_axis, y_axis, z_axis];
        setappdata(0, 'base_frame', plotted_axes);
    end


    function delete_axes()
        try
            axes_lines = getappdata(0, 'base_frame');
            for j = 1:size(axes_lines,1)        %for each joint
                for c = 1 : size(axes_lines,2)  %for each coordinate
                    line = axes_lines(j,c);
                    delete(line);
                end
            end
        end
    end
end