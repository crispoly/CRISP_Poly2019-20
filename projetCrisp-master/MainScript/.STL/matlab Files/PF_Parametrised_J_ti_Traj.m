%==========================================================================
% >>>>> FUNCTION PF-C.10: PARAMETRISED JOINT TRAJECTORY W/ TIME INPUT <<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for the joint
% selected based on the user's input. This function makes use of MATLAB
% ability to work with symbolic variables and functions to create a path
% based on the expression inputted. The expression generates a joint curve
% not a cartesian curve like the others, so the inverse kinematics function
% is not used here. Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Parametrised_J_ti_Traj(pej, jn, deltat)
% pej: joint parametric equation
% jn = joint number to apply the parametrisation
% deltat: delta time: Because the parametric equation is in function of
% time it is needed an initial and final value to determine where the
% parametric curve starts and stops in space.

%PS: The inputs check is made in the Secondary function that calls this one
%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
fps = S.value{'fps'}; %get the number of frames per second

if cn == 1
    q0 = S.value{'home_q'};           %get current theta angles
else
    q0 = H(cn - 1).q(end,:);    %get current theta angles
end

n = size(q0, 2);

pej = sym(pej); %converting the string expression to symbolic

if size(deltat, 2) == 1
    ti = deltat;
else
    ti = abs(deltat(2) - deltat(1));
end

sp = ceil(ti * fps);    % Computing step points (sp)
% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';
%% Generate the trajectory
qp = [];
jv = symvar(pej);   
if ~isempty(jv)
    pej = symfun(pej, jv);      %convert symbolic expr. to symb. function
    qp = [qp; double(pej(tv))]; %solving for tv entries
else
    qp = [qp; pej * ones(sp, 1)];
end
  
% all joints will remain q0 but the joint jn
q = (q0' * ones(1, sp))'; %making a matrix with the q0 values
q(:, jn) = qp;%Replacing column jn with the results of the parametrisation


tm = [zeros(1,n); tv * ones(1, n)];
dq = diff([zeros(1,n); q])./diff(tm);
% dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
% ddq(1,:) = 0; %ddq(end, :) = 0;

end
