%==========================================================================
% >>>>>>>> FUNCTION PF-C.8: PARAMETRISED TRAJECTORY W/ CST LIN VEL <<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. This function makes use of MATLAB ability to
% work with symbolic variables and functions to create a path based on the
% expression inputted.
% Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Parametrised_clv_Traj(pex, pey, pez, ...
                                                          vl, fvv, orient)
% pex, pey, pez: parametric equation in x y and z respectively
% lv: linear velocity
% fvv: final variable value: Because the parametric equation is in function
% of time it is needed a final value to determine where the parametric
% curve will stop in space. For the C.10 where the user input is time and
% not a constant linear velocity, this value (fvv) is the final time, here
% is used only to know where the curve stops, and the time is computed
% using the linear velocity

%% LOAD FILES
S = evalin('base', 'S');          %Load Settings (from base workspace)
H = evalin('base', 'H');          %Load History (from base workspace)

cn = S.value{'cn'};  %get the command number from Settings structure
fps = S.value{'fps'}; %get the number of frames per second

if cn == 1
    q0 = S.value{'home_q'};     %get current theta angles
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
pex = sym(pex); %converting the string expression to symbolic
pey = sym(pey);
pez = sym(pez);

xv = symvar(pex);
yv = symvar(pey);
zv = symvar(pez);
if  ~isempty(xv)
    pex = symfun(pex, xv);   %convert symbolic expr. to symb. function
    dpex = diff(pex, symvar(pex));%taking the derivative of the param eq.
else
    dpex = 0;
end

if  ~isempty(yv)
    pey = symfun(pey, yv);
    dpey = diff(pey, yv);
else
    dpey = 0;
end

if  ~isempty(zv)
    pez = symfun(pez, zv); 
    dpez = diff(pez, symvar(pez));
else
    dpez = 0;
end
try
    %Parametric curve length
    S = int(sqrt(dpex^2 + dpey^2 + dpez^2), fvv(1), fvv(2));
    S = double(S);
    
    ti = S / vl; %Computing trajectory time
catch
    ti = abs(fvv(2) - fvv(1));   %If not possible to compute S, set fvv as time
end
sp = ceil(ti * fps);    % Computing step points (sp)
% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';    %time vector used for plots

%time vector used for solving the parametric equation
tvfpe = linspace(0, fvv(2), sp)'; 
%% Generate the trajectory
xp = []; yp = []; zp = [];

if ~isempty(xv)
    xp = [xp; double(pex(tvfpe))]; %solving for tv entries
else
    xp = [xp; pex * ones(sp, 1)];
end

if ~isempty(yv)
    yp = [yp; double(pey(tvfpe))];
else
    yp = [yp; pey * ones(sp, 1)];
end

if ~isempty(zv)
    zp = [zp; double(pez(tvfpe))];
else
    zp = [zp; pez * ones(sp, 1)];
end    

p = double([xp, yp, zp, ones(sp, 1) * orient]); %positions and orientations

s = [1 1 1];
if any(orient == 0)
    s = [0 0 0];    %then the orientation is not specified in IK
end
q = PF_Inverse_Kinematics(p, q0, s);

tm = [zeros(1,n); tv * ones(1, n)];
dq = diff([zeros(1,n); q])./diff(tm);
dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
ddq(isnan(ddq)) = 0; %ddq(end, :) = 0;
end
