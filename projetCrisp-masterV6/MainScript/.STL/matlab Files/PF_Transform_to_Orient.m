% *************** NÃO É UTILIZADA - VERIFICAR ********************



function rpy = PF_Transform_to_Orient(T, varargin)
	
    opt.deg = true;
    opt.zyx = false;

	s = size(T);
	if length(s) > 2
		rpy = zeros(s(3), 3);
		for i=1:s(3)
			rpy(i,:) = PF_Transform_to_Orient(T(:,:,i), varargin{:});
		end
		return
	end
	rpy = zeros(1,3);

    if ~opt.zyx
        % XYZ order
        if abs(T(3,3)) < eps && abs(T(2,3)) < eps
            % singularity
            rpy(1) = 0;  % roll is zero
            rpy(2) = atan2(T(1,3), T(3,3));  % pitch
            rpy(3) = atan2(T(2,1), T(2,2));  % yaw is sum of roll+yaw
        else
            rpy(1) = atan2(-T(2,3), T(3,3));        % roll
            % compute sin/cos of roll angle
            sr = sin(rpy(1));
            cr = cos(rpy(1));
            rpy(2) = atan2(T(1,3), cr * T(3,3) - sr * T(2,3));  % pitch
            rpy(3) = atan2(-T(1,2), T(1,1));        % yaw
        end
    else
        % old ZYX order (as per Paul book)
        if abs(T(1,1)) < eps && abs(T(2,1)) < eps
            % singularity
            rpy(1) = 0;     % roll is zero
            rpy(2) = atan2(-T(3,1), T(1,1));  % pitch
            rpy(3) = atan2(-T(2,3), T(2,2));  % yaw is difference yaw-roll
        else
            rpy(1) = atan2(T(2,1), T(1,1));
            sp = sin(rpy(1));
            cp = cos(rpy(1));
            rpy(2) = atan2(-T(3,1), cp * T(1,1) + sp * T(2,1));
            rpy(3) = atan2(sp * T(1,3) - cp * T(2,3), cp*T(2,2) - sp*T(1,2));
        end
    end
    if opt.deg
        rpy = rpy * 180/pi;
    end