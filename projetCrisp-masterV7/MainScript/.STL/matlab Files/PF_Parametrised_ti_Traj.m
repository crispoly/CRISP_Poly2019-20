%==========================================================================
% >>>>>>>> FUNCTION PF-C.11: PARAMETRISED TRAJECTORY W/ TIME INPUT <<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will generate the trajectory for each joint 
% based on the user's input. This function makes use of MATLAB ability to
% work with symbolic variables and functions to create a path based on the
% expression inputted.
% Refer to section 4 of documentation for details.
%==========================================================================
function [q, dq, ddq, tv, sp] = PF_Parametrised_ti_Traj(pex, pey, pez, deltat, orient)
% pex, pey, pez: parametric equation in x y and z respectively
% lv: linear velocity
% deltat: delta time: Because the parametric equation is in function of
% time it is needed an initial and final value to determine where the
% parametric curve starts and stops in space.
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

%converting the string expression to symbolic
pex = sym(pex); 
pey = sym(pey);
pez = sym(pez);

if size(deltat, 2) == 1
    ti = deltat;
else
    ti = abs(deltat(2) - deltat(1));
end

sp = ceil(ti * fps);    % Computing step points (sp)
% Time vector from 0 to final time, with sp rows
tv = linspace(0,ti,sp)';
%% Generate the trajectory
xp = []; yp = []; zp = [];

xv = symvar(pex);
yv = symvar(pey);
zv = symvar(pez);
if ~isempty(xv)
    pex = symfun(pex, xv);      %convert symbolic expr. to symb. function
    xp = [xp; double(pex(tv))]; %solving for tv entries
else
    xp = [xp; pex * ones(sp, 1)];
end

if ~isempty(yv)
    pey = symfun(pey, yv);   %convert symbolic expr. to symb. function
    yp = [yp; double(pey(tv))];
else
    yp = [yp; pey * ones(sp, 1)];
end

if ~isempty(zv)
    pez = symfun(pez, zv);   %convert symbolic expr. to symb. function
    zp = [zp; double(pez(tv))];
else
    zp = [zp; pez * ones(sp, 1)];
end    

s = [1 1 1];
if any(orient == 0)
    s = [0 0 0];    %then the orientation is not specified in IK
end


p = double([xp, yp, zp, ones(sp, 1) * orient]);   %positions and orientations

q = PF_Inverse_Kinematics(p, q0, s);

% if norm(deltap(1:3))
%     
% end
tm = [zeros(1,n); tv * ones(1, n)];
dq = diff([zeros(1,n); q])./diff(tm);
% dq(1,:) = 0; dq(end,:) = 0;
ddq = diff([zeros(1,n); dq])./diff(tm);
% ddq(1,:) = 0; %ddq(end, :) = 0;
end
