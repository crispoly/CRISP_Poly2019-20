%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION SF-14: DYNAMIC SIMULATION <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - June 05th, 2016.

% DESCRIPTION: This function will read the expressions in Torque Table and
% create a table of torque and time that is passed as input to the primary
% function Forward_Dynamics. Refer to section 4 of documentation for
% details.
%==========================================================================
function SF_Dynamic_Simulation()
%% Loading variables
try
    TT = evalin('base', 'TT');    % Load Torque Table (from base workspace)
catch
	return
end
RP = evalin('base', 'RP');        % Load Robot Parameters
S = evalin('base', 'S');          % Load Settings (from base workspace)
H = evalin('base', 'H');          % Load Settings (from base workspace)

cn = S.value{'cn'};
n = S.value{'dof'};

if cn == 1  
    q0 = S.value{'home_q'};
    dq0 = zeros(1,n);
else
    q0 = H(cn - 1).q(end,:);
    dq0 = H(cn - 1).dq(end,:);
end

ctrl_rate = S.value{'ctrl_rate'}; % Get control rate

%% 
torquei{n} = [];    %preallocating torque
for i=1:size(TT,1)
    if ~isnumeric(TT{i, 1}{:})
        try
            joint = str2num(TT{i, 1}{:});
            
        end
    else
        joint = TT{i, 1}{:};
    end
    
    if ~isnumeric(TT{i,3}{:})
        time = str2num(TT{i,3}{:});
    else
        time = TT{i,3}{:};
    end
    expression = TT{i,2}{:};
        
    sp = ceil(time * ctrl_rate);    % Computing step points (sp)
        
    tv = linspace(0,time,sp)';
    
    
    %converting the string expression to symbolic
    expression = sym(expression); 
    torquevar = symvar(expression);
    
    if isempty(torquevar)
        torquei{joint} = double(ones(sp,1).*expression);
    else
        %convert symbolic expr. to symb. function
        expression = symfun(expression, torquevar); 
        %solving for tv entries
        torquei{joint} = [torquei{joint};double(expression(tv))]; 
    end
end
nrows = zeros(1,6);
for i=1:n
    nrows(i) = size(torquei{i},1);
end
tq = zeros(max(nrows),n);
tv = linspace(0, (max(nrows)/ctrl_rate), max(nrows)); 
for i = 1:n
    tq(1:size(torquei{i},1), i) = torquei{i};
end

% Call the primary function
[tv, q, dq] = PF_Forward_Dynamics(max(tv), tq, deg2rad(q0), deg2rad(dq0));
q = rad2deg(q);     dq = rad2deg(dq);     
sp = size(q,1);
tm = [zeros(1,n); tv * ones(1, n)];
ddq = diff([zeros(1,n); dq])./diff(tm);
ddq(1,:) = 0;

qc = []; dqc = []; ddqc = [];

%% Save outputs into the History structure
MF_Save_Structures('H', 'q', q, 'dq', dq, 'ddq', ddq, 'qc', qc, ...
    'dqc', dqc, 'ddqc', ddqc, 'sp', sp, 'time',tv, 'tq', tq);
%%
% Animate command
%     Note: First the user will see the command animation on the screen and
%     then the motion is performed in the robot. For motion and animation
%     occuring at the same time, amend this code using Multithreading
MF_Animate_Commands(cn, 'full')


% Drive Servos (Send command to robot it connected)
simulation_only = S.value{'simul_only'};
if ~simulation_only
    id = S.value{'robotnum'};
    pauset = S.value{'servo_pause'};
    baudnum = S.value{'baudnum'};
    portnum = S.value{'portnum'};
    %Drive servos if NOT in simulate mode.
    PF_Driving_Actuators(id, q, dq, pauset, portnum, baudnum);
end

% Update Message box.
MF_Update_Message(13, 'notice');

% Update Transformation Matrix, sliders and other ui components
MF_Update_Cn(); %update command number
MF_Update_UI_Controls();
end