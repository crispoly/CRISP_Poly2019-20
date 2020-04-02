%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION MF-16: PLOT GRAPHS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will plot the 4 graphs: position, velocity,
% acceleration and torque (each graph will have the n joints)
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Plot_Graphs(cn)
%cn: command number (cn can be an array w/ all command numbers in history)
%mode: layout of the plots, mode = 1: each plot in a new figure; 2: 
%% Loading structures;
H = evalin('base', 'H');          %Load History (from base workspace)

%% Assembling data to plot
time = zeros(length(0));
theta = [];
theta_dot = [];
theta_ddot = [];
torque = [];
for idx = 1:length(cn)
    time(idx) = H(cn(idx)).time(end);
    theta = [theta; H(cn(idx)).q];
    theta_dot = [theta_dot; H(cn(idx)).dq];
    theta_ddot = [theta_ddot; H(cn(idx)).ddq];
    torque = [torque; H(cn(idx)).tq];
end
n = size(theta,2);
time = linspace(0,sum(time),length(theta));

%If the user didn't enable torque computation in Settings (make a 0 array)
if size(torque, 1) ~= size(time, 2)
    plot_torque = false;
else
    plot_torque = true;
end
%% Plotting data
figure
set(gcf,'color','white');           %Set figure background to white
set(0,'defaultTextInterpreter','latex'); %Use Latex interpreter for symbols
lw = 0.5;     %Plot Line width 
plot_r = 3;   %Define plot layout in the figure (4 rows)
plot_c = 1;   %Define plot layout in the figure (1 column)

%1 - Plotting Theta over time for each joint
subplot(plot_r,plot_c,1);
hold on
grid on
for i = 1:n
    try
        plot(time, theta(:,i),'LineWidth',lw);
        lenged_txt{i} = strcat('$\theta' , num2str(i),'$');
    end
end
title('Joint displacement');
xlabel('$t [s]$','interpreter','latex');
ylabel('$\theta(t) [^ \circ]$','interpreter','latex');
legend(lenged_txt,'interpreter','latex');

%2- Plotting Angular Velocity (dtheta/dt) over time for each joint
subplot(plot_r,plot_c,2); 
hold on
grid on
for i = 1:n
    try
        plot(time, theta_dot(:,i),'LineWidth',lw);
        lenged_txt{i} = strcat('$\dot\theta' , num2str(i),'$');
    end
end
title('Joint velocity');
xlabel('$t [s]$','interpreter','latex');
ylabel('$\dot\theta(t) [^ \circ /s]$','interpreter','latex');
legend(lenged_txt,'interpreter','latex');


%3 - Plotting Angular Acceleraion (ddtheta/dt^2) over time for each joint
subplot(plot_r,plot_c,3); 
hold on
grid on
for i = 1:n
    try
        plot(time, theta_ddot(:,i),'LineWidth',lw);
        lenged_txt{i} = strcat('$\ddot\theta' , num2str(i),'$');
    end
end
title('Joint acceleration');
xlabel('$t [s]$','interpreter','latex');
ylabel('$\ddot\theta(t) [^ \circ /s^{2}]$','interpreter','latex');
legend(lenged_txt,'interpreter','latex');

%4 - Plotting Torque over time for each joint
% subplot(plot_r,plot_c,4); 
if plot_torque
    figure
    set(gcf,'color','white');           %Set figure background to white
    hold on
    grid on
    for i = 1:n
        try
            plot(time, torque(:,i),'LineWidth',lw);
            lenged_txt{i} = strcat('$\tau' , num2str(i),'$');
        end
    end
    title('Joint Torque');
    xlabel('$t [s]$','interpreter','latex');
    ylabel('$\tau(t) [Nm]$','interpreter','latex');
    legend(lenged_txt,'interpreter','latex');
end
end
