%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-I: COLLISION CHECK <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will check if the end-effector will collide
% with an object. The object must be described as a parametric equation.
% Refer to section 4 of documentation for details.
%==========================================================================
function [collision_detected] = PF_Collision_Check (varargin)


for i=1:nargin
    if strcmp(varargin{i}, 'p')
        p = varargin{i+1};
    elseif strcmp(varargin{i}, 'p')
        q = varargin{i+1};
    end
end

% [x, y, z] = deal(P_XYZ(1), P_XYZ(2),P_XYZ(3));
%Change this function for actually calculating and check collision.
collision_detected = false;

end
