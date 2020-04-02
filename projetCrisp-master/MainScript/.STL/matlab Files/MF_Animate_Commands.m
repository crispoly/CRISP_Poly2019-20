%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-4: ANIMATE COMMANDS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will load the joints trajectory from History
% and animate it in the Animation window by transforming (rotaion and
% translation) the LD matrices that contain the vertices and patches got
% from SF_Importing_CAD. The transformation is made by using the Transform
% matrix (primary function Forward_Kinematics); the animation will have fps
% frames per second (From Settings). Refer to section 4 of documentation
% for details.
%==========================================================================
function MF_Animate_Commands(cn, axessize)
% cn: command number (a scalar or a vector with all commands the user wants
% to animate).
%% Loading structures and collecting variables
S = evalin('base', 'S');     % Load Settings (from base workspace)
RP = evalin('base', 'RP');   % Load Robot parameters (from base workspace)
H = evalin('base', 'H');     % Load History (from base workspace)
LD = evalin('base', 'LD');   % LD contain all the face and vertices points
AF = evalin('base', 'AF');   % Load figure (Animation Figure)

HD = evalin('base', 'HD');   % Load Handles (from base workspace)

sp = H(cn).sp;                %get the number of steps

save_video = S.value{'save_video'};%get the save video option (save as avi)
robot_offset = S.value{'ground_offset'};
% Trail and axes (display options)
trail = S.value{'trail'};

% Print trail one specific plane only
trailP = S.value{'trail_plane'};
if strcmp(trailP, '-') || strcmp(trailP, 'na')
    trailOnPlane = false;
elseif ~isempty(strfind(trailP, '='));
    trailOnPlane = true;
    try
        if strcmp(trailP(1), 'x')
            trailPlane = 1;
        elseif strcmp(trailP(1), 'y')
            trailPlane = 2;
        elseif strcmp(trailP(1), 'z')
            trailPlane = 3;
        else
            trailOnPlane = false;
        end
        
        % get the distance and convert to number
        try
            trailPlaneDist = str2num(trailP(strfind(trailP, '=')+1 : ...
                                    length(trailP)));
        catch
            trailOnPlane = false;
        end
        
    catch
        trailOnPlane = false;
    end
end
    

clear_trail_after_command = S.value{'ctrail_ac'};
if strcmp(get(HD.display_cg, 'Checked'), 'on')
    show_cg_frame = true; 
else
    show_cg_frame = false;
end

if strcmp(get(HD.disp_link_frame, 'Checked'), 'on')
    show_link_frame = true; 
else
    show_link_frame = false;
end

show_axes = S.value{'axes'};

% Robot parameters
fps = S.value{'fps'};
tpf = 1/fps;     %time per frame
nl = S.value{'dof'}-1;      %get the number of links (dof-1)
d = RP.d'; a = RP.a'; alpha = RP.alpha';  %get D-H parameters

if (S.value{'enable_control'})
        q = H(cn).qc; %get theta angles from history
    else
        q = H(cn).q;  
end

% Creating a new q list if the number of rows in H is larger than fps*time
if size(q,1) > ceil(fps * H(cn).time(end))
    idxlist = round(linspace(1, size(q,1), 1*(fps * H(cn).time(end))));
    q = q(idxlist, :);
    sp = size(q,1);
end
%% 
%   Making the Robot Representation the current figure
%   This figure was created in: MF_Creating_RR_GUI()
try
	figure(AF); 
catch
    MF_Creating_RR_GUI();
end

    set(gcf,'Visible', 'on'); 
    try
        children = get(gca, 'children');
        delete(children);
    end
    
    hold on;
    grid('on');
    light                               %Add a default light

    max_r = S.value{'max_reach_p'};     %Get maximum reach distance
    ax_size = max_r+200;                %set the axes dimensions
%     daspect([1 1 1])                    %Setting the aspect ratio
%     view(135,25)                        %Adjust the view orientation.
%     xlabel('X'),ylabel('Y'),zlabel('Z');  
    if exist('axessize', 'var')
        if strcmp(axessize, 'full')
        %set the axes dimensions
        axis([-ax_size ax_size -ax_size ax_size -ax_size ax_size]);
        end
    else
        %set the axes dimensions
        axis([-ax_size ax_size -ax_size ax_size -robot_offset (ax_size + RP.d(1))]);
    end
%% Setting and drawing base
    Base_vert = LD(nl+1).Ve;   %get the base vertices for patch
                        %The base is the immediate item after the joints

    Base_patch = patch('faces', LD(nl+1).Fa, 'vertices', Base_vert(:,1:3));
    set(Base_patch, 'facec', [.8,.8,.8]);% set base color and draw
    set(Base_patch, 'EdgeColor','none');% set edge color to none   
    
    if clear_trail_after_command
        %Clear trail
        setappdata(0,'xtrail',[]);
        setappdata(0,'ytrail', []);
        setappdata(0,'ztrail',[]);
        Tr = plot3(0,0,0,'r', 'LineWidth',2);
        set(Tr,'xdata',[],'ydata',[],'zdata',[]);
    else
        Tr = plot3(0,0,0,'r', 'LineWidth',2);
    end
   
  
%% Drawing the links and end-effector for all points in the trajectory

  for i = 1:sp    %1 to setp points
      tic;       %Start computing time
      stop = S.value{'stop'};
      if stop
          MF_Update_Message(8,'warnings');
          MF_Update_Stop_status(false); %reseting stop status
          break
      end
      
    %Delete previous patches
    try
       for idx = 1:nl
           delete(L_patch{idx});
       end
       delete(EE_patch);
    end
    
    q_row = q(i,:);
    [p_xyz, T_m] = PF_Forward_Kinematics(q_row, d, a, alpha);

    % Setting and drawing links

    for j = 1:nl %number of links (dof-1)
        L_vert = (T_m{j} * LD(j).Ve')'; % get the vertices transformed
        L_patch{j} = patch('faces', LD(j).Fa, 'vertices', L_vert(:,1:3));
        % set link color and draw
        set(L_patch{j}, 'facec', RP.color{j},'EdgeColor','none');
    end
   
    % Setting and drawing end-effector if it exists
    ee_enabled = S.value{'enable_ee'};
    if ee_enabled %if the robot has end-effector
        ee_n = nl + 1;
        End_effector = LD(nl+2).Ve; %get the end-effector vertices for
        % patch the end-effector is the immediate item after the base
        EE_vert = (T_m{ee_n} * End_effector')';
        EE_patch = patch('faces', LD(nl+2).Fa, 'vertices', EE_vert(:,1:3));
        set(EE_patch, 'facec', RP.color{nl+2});% set base color and draw
        set(EE_patch, 'EdgeColor','none');% set edge color to none  
    end
    
    
%         % store trail in appdata 
        if trail       %trail is true
            x_trail = getappdata(0,'xtrail');
            y_trail = getappdata(0,'ytrail');
            z_trail = getappdata(0,'ztrail');
            
            if trailOnPlane %show trail that is on a plane only
                if (abs(p_xyz(trailPlane) - trailPlaneDist) < 0.2)
                    xdata = [x_trail p_xyz(1)];             %0.2: tolerance
                    ydata = [y_trail p_xyz(2)];
                    zdata = [z_trail p_xyz(3)];
                    
                    setappdata(0,'xtrail',xdata);
                    setappdata(0,'ytrail',ydata);
                    setappdata(0,'ztrail',zdata);
                    %
                    set(Tr,'xdata',xdata,'ydata',ydata,'zdata',zdata);

                end
                    
            else
                
                %
                xdata = [x_trail p_xyz(1)];
                ydata = [y_trail p_xyz(2)];
                zdata = [z_trail p_xyz(3)];
                %
                setappdata(0,'xtrail',xdata); % used for trail tracking.
                setappdata(0,'ytrail',ydata); % used for trail tracking.
                setappdata(0,'ztrail',zdata); % used for trail tracking.
                %
                set(Tr,'xdata',xdata,'ydata',ydata,'zdata',zdata);
            end
        end
        
        if show_link_frame
            MF_Plot_Links_frame(T_m);
        elseif show_cg_frame
            MF_Plot_CG_frames(T_m, true, q_row);
        end
        
        drawnow
        if save_video
            F(i) = getframe;    %get frame if save video is set to true
            
%             %save images each 5 frames (in jpeg)
%             if i==1 || rem(i,17) == 0
%                 Image = frame2im(F(i));
%                 imagename = strcat('image', num2str(cn), '-', num2str(i),'.jpg');
%                 imwrite(Image, imagename);
%             end
        end
        
        %Pause loop if step was quicker than time per frame (make animation
        %more accurate with the time imposed by the user)
        st = toc;         %step time
        if st < tpf
            pause(tpf - st);
        end
  end

if save_video
    %convert F frames to avi video
    randomName = num2str(horzcat(ceil(rand(1)*1e5)));
    videoname = strcat('command', num2str(cn),'-',randomName,'.avi');
    try
        movie2avi(F, videoname, 'quality', 75, 'fps', S.value{'fps'});
    end
end
end