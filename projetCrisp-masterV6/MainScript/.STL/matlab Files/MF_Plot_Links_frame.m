%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-15: PLOT LINKS FRAME <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will plot the links reference frames on the
% robot representation in animation window. The function checks if the user
% selected the option Display Links Frames and transform a reference frame
% from the base to the selected link (in Transformation Matrices menu -
% Commands tab). If the Settings tab option: Show all axes are set to true,
% then all links(joints) reference frames are plotted at once. Refer to
% section 4 of documentation for details.
%==========================================================================
function MF_Plot_Links_frame(T, show)
%Load and assemble variables
S = evalin('base', 'S');      % Load Settings (from base workspace)
H = evalin('base', 'H');      % Load History (from base workspace)
HD = evalin('base', 'HD');    % Load Handles (from base workspace)
RP = evalin('base', 'RP');    % Load Robot parameters (from base workspace)
AF = evalin('base', 'AF');    % Load figure (Animation Figure)
cn = S.value{'cn'};

% show = true: display the axes on the screen; false: delete the axes
if ~exist('show', 'var')
    if strcmp(get(HD.disp_link_frame, 'Checked'), 'on')
        show = true;
    else
        show = false;
    end
end

all_links = S.value{'axes'};    % display the axes for all joints

if exist('T', 'var')
    if ~iscell(T) && (T == 0)
        if cn == 1
            q = S.value{'home_q'};
        else
            q = H(cn - 1).q(end,:);
        end
        d = RP.d; a = RP.a; alpha = RP.alpha;
       [~, T] = PF_Forward_Kinematics(q, d, a, alpha);
    end
else
    return
end

try
    figure(AF);
catch
    return
end
%% Display axes
if show
    delete_axes();
    show_axes(T, RP, HD, S);
else    %If the axes lines exist, delete it.
    delete_axes()
end

%% Functions 
    function show_axes(T, RP, HD, S)
        if all_links
            link = 1:1:S.value{'dof'};
        else
            link = get(HD.transformation_options, 'Value');
        end
        for i= 1:length(link)
            Tm = T{link(i)};  %Transformation matrix from base to link chosen

            axis_length = ceil(norm(RP.d + RP.a)/length(RP.d)); 

            % Creating base frame vertices
            Vbx = [[0; axis_length], [0; 0], [0; 0], [1; 1]];
            Vby = [[0; 0], [0; axis_length], [0; 0], [1; 1]];
            Vbz = [[0; 0], [0; 0], [0; axis_length], [1; 1]];

            %Transforming the base frame vertices to chosen link
            Vtx = (Tm * Vbx')';
            Vty = (Tm * Vby')';
            Vtz = (Tm * Vbz')';

            x_axis = plot3(Vtx(:, 1), Vtx(:, 2), Vtx(:, 3),'r');
            y_axis = plot3(Vty(:, 1), Vty(:, 2), Vty(:, 3),'g');
            z_axis = plot3(Vtz(:, 1), Vtz(:, 2), Vtz(:, 3),'b');
            
            plotted_axes(i,:) = [x_axis, y_axis, z_axis];
            setappdata(0, 'links_frames', plotted_axes);
        end
    end


    function delete_axes()
        try
            axes_lines = getappdata(0, 'links_frames');
            for j = 1:size(axes_lines,1)        %for each joint
                for c = 1 : size(axes_lines,2)  %for each coordinate
                    line = axes_lines(j,c);
                    delete(line);
                end
            end
        end
    end
end