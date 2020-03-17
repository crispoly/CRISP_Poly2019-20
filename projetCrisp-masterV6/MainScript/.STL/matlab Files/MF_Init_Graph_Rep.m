%==========================================================================
% >>>>>>>>> FUNCTION MF-2: INITIALISE GRAPHICAL REPRESENTATION <<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will .... The robot must be saved in STL. The
% position and orientation saved is the position that will be displayed as
% initial in the Simulation Window. Refer to section 6.4.1 for details.
%==========================================================================
function MF_Init_Graph_Rep()

%% Loading structures and collecting variables
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)
RP = evalin('base', 'RP');        %Load Settings (from base workspace)
LD = evalin('base', 'LD'); %LD contain all the face and vertices points
AF = evalin('base', 'AF'); % Load figure

HD = evalin('base', 'HD');          %Load Settings (from base workspace)

robot_offset = S.value{'ground_offset'};
cn = S.value{'cn'};
if cn > 1
    q0 = H(cn - 1).q(end,:);%get home joint position from History(last cmd)
else
    q0 = S.value{'home_q'}; %get home joint position from SETTINGS
end

nl = S.value{'dof'}-1;    %get the number of links (dof-1)
d = RP.d'; a = RP.a'; alpha = RP.alpha';  %get D-H parameters
%% Setting the axes area
%   Making the Robot Representation the current figure
%   This figure was created in: MF_Creating_RR_GUI()
%     figure(RR_fig); 
    
    %light('Position',[-1 0 0]);
 try
	figure(AF); 
    clf('reset');
catch
    return;
 end

    hold on;
    grid('on');
    light                               %Add a default light

    % Clearing the trail
    setappdata(0,'xtrail',[]); % used for trail tracking.
    setappdata(0,'ytrail', []); % used for trail tracking.
    setappdata(0,'ztrail',[]); % used for trail tracking.
    Tr = plot3(0,0,0,'r', 'LineWidth',2); %'Color', [0.5 0 0.5]); % holder for trail paths
    set(Tr,'xdata',[],'ydata',[],'zdata',[]);
        
        
    %Get maximum reach distance
    max_r = S.value{'max_reach_p'};
    ax_size = max_r+200;                %set the axes dimensions
% 	axes('XLim',[-ax_size ax_size],'YLim',[-ax_size ax_size],'ZLim',[-0 ax_size]);
    daspect([1 1 1])                    %Setting the aspect ratio
    view(135,25)                        %Adjust the view orientation.
    xlabel('X'),ylabel('Y'),zlabel('Z');
    %set the axes dimensions
    axis([-ax_size ax_size -ax_size ax_size -robot_offset (ax_size + RP.d(1))]);

    %Boundary lines
%     line1 = plot3([-ax_size,ax_size],[-ax_size,-ax_size],[-0,-0],'k');
%     line2 = plot3([-ax_size,-ax_size],[-ax_size,ax_size],[-0,-0],'k');
%     line3 = plot3([-ax_size,-ax_size],[-ax_size,-ax_size],[-0,ax_size],'k');
%     line4 = plot3([-ax_size, -ax_size],[ax_size,ax_size],[-0,ax_size],'k');
%     line5 = plot3([-ax_size, ax_size],[-ax_size,-ax_size],[ax_size,ax_size],'k');
%     line6 = plot3([-ax_size,-ax_size],[-ax_size,ax_size],[ax_size,ax_size],'k');
%     GR.boundary = [line1, line2, line3, line4, line5, line6];
    
    
    
    
    Base_vert = LD(nl+1).Ve;   %get the base vertices for patch
                        %the base is the immediate item after the joints
      % Setting and drawing base
    Base_patch = patch('faces', LD(nl+1).Fa, 'vertices', Base_vert(:,1:3));
    set(Base_patch, 'facec', [.8,.8,.8]);% set base color and draw
    set(Base_patch, 'EdgeColor','none');% set edge color to none   
    
%     ***************************************************
    [~, T_m] = PF_Forward_Kinematics(q0, d, a, alpha);

    for j = 1:nl %number of links (dof-1)
        L_vert = (T_m{j} * LD(j).Ve')';
        L_patch = patch('faces', LD(j).Fa, 'vertices', L_vert(:,1:3));
        set(L_patch, 'facec', RP.color{j},'EdgeColor','none');% set link color and draw
%         set(L_patch, );% set edge color to none
    end    
    
%         Setting and drawing end-effector if it exists
    if S.value{'enable_ee'}   %if the robot has end-effector
        ee_n = nl + 1;
        End_effector = LD(nl+2).Ve; %get the end-effector vertices for
%         patch the end-effector is the immediate item after the base
        ee_vert = (T_m{ee_n} * End_effector')';
        ee_patch = patch('faces', LD(nl+2).Fa, 'vertices', ee_vert(:,1:3));
        set(ee_patch, 'facec', RP.color{nl+2});% set base color and draw
        set(ee_patch, 'EdgeColor','none');% set edge color to none  
    end
end
