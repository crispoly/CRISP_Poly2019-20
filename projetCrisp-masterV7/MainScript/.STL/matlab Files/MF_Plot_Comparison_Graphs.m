%==========================================================================
% >>>>>>>>>>>>>> FUNCTION MF-17: PLOT COMPARISON GRAPHS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.

% DESCRIPTION: This function will plot the 4 graphs: position, velocity,
% acceleration and torque (each graph will have the n joints)
% Refer to section 6.4.1 for details. 
%==========================================================================
function MF_Plot_Comparison_Graphs(cn)
%cn: command number (cn can be an array w/ all command numbers in history)
%mode: layout of the plots, mode = 1: each plot in a new figure; 2: 
%% Loading structures;
H = evalin('base', 'H');          %Load History (from base workspace)

%% Assembling data to plot
time = zeros(length(0));
q_ideal = [];
q_cs = [];


for ii = 1:cn
    time(ii) = H(cn(ii)).time(end);
    q_ideal = [q_ideal; H(cn(ii)).q];  %ideal joint variable values
    q_cs =  [q_cs; H(cn(ii)).qc];      %real joint variable (control result)
end
n = size(q_ideal,2);
time = linspace(0,sum(time),length(q_ideal));

% cn = 1;
% for testing the function
% clc
% close all
% 
% time = linspace(0,300,500);
% q_ideal = sin(linspace(-pi,pi,500)'*linspace(1,6,6));
% q_cs = sin(linspace(-pi+0.25,pi+0.25,500)'*linspace(1,6,6));
% 
% n = size(q_ideal,2);

%% Plotting data
figure
set(gcf,'color','white');           %Set figure background to white
set(0,'defaultTextInterpreter','latex'); %Use Latex interpreter for symbols
lw = 0.5;     %Plot Line width 
plot_c = 2;   %Define plot layout in the figure (2 columns)
plot_r = n/plot_c;   %Define plot layout in the figure (4 rows)


%1 - Plotting Theta over time for each joint
for idx = 1:n
    subplot(plot_r, plot_c, idx);
    hold on
    grid on
    try
        plot(time, q_ideal(:,idx), 'k', ...
            'LineWidth',lw);
        
        plot(time, q_cs(:,idx), 'k-.',...
            'LineWidth',lw,...
            'MarkerSize', 5);
%         plot(time, q_cs(:,idx),'LineWidth',lw,'Colour', 'k');
        lenged_txt = {strcat('$\theta' , num2str(idx),'$ ideal'), ...
                      strcat('$\theta' , num2str(idx),'$ real')};
        legend(lenged_txt,'interpreter','latex');
    end
title('Joint displacement');
xlabel('$t [s]$','interpreter','latex');
ylabel('$\theta(t) [^ \circ]$','interpreter','latex');

end
end
