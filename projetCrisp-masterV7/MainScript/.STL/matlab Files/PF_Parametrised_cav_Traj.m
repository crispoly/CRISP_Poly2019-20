%==========================================================================
% >>>>>>>> FUNCTION PF-C.9: PARAMETRISED TRAJECTORY W/ CST ANG VEL <<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. This function makes use of MATLAB ability to
% work with symbolic variables and functions to create a path based on the
% expression inputted.
% Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Parametrised_cav_Traj(pej, jn, va, fvv)
% pej: joint parametric equation
% jn = joint number to apply the parametrisation
% va: angular velocity

% fvv: final variable value: Because the parametric equation is in function
% of time it is needed a final value to determine where the parametric
% curve will stop in space.
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

%make a vector of time if passed a scalar
if size(fvv, 2) == 1
    fvv(2) = fvv;
    fvv(1) = 0;
end

n = size(q0, 2);

%Computing S
pej = sym(pej); %converting the string expression to symbolic
jv = symvar(pej);

if  ~isempty(jv)
    pej = symfun(pej, jv);      %convert symbolic expr. to symb. function
    dpej = diff(pej, jv); %taking the derivative of the parametric eq.
else
    dpej = 0;
end

try
    %Parametric curve length
    S = int(sqrt(1+dpej^2), fvv(1), fvv(2));
    S = double(S);
    ti = S / va; %Computing trajectory time
catch
    ti = abs(fvv(2) - fvv(1));   %If not possible to compute S, set fvv as time
end

sp = ceil(ti * fps);    % Computing step points (sp)
% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';
%% Generate the trajectory
qp = [];
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
dq = zeros(sp, n);  %preallocate dq
dq(q~=0) = va;  %substitute va in dq where the position is not 0
% dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
ddq(isinf(ddq)) = 0;
ddq(isnan(ddq)) = 0;
% ddq(1,:) = 0; %ddq(end, :) = 0;
end
