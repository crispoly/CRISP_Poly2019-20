% Inverse Dynamics by Recursive Newton-Euler
function [tau] = PF_Inverse_Dynamics(a1, a2, a3, a4, a5)
a1 = deg2rad(a1);   a2 = deg2rad(a2); a3 = deg2rad(a3);



RP = evalin('base', 'RP');    %Load Robot Parameters (from base workspace)
S = evalin('base', 'S');      %Load Settings (from base workspace)
a = RP.a/1000;  d = RP.d/1000;  alpha = RP.alpha;%alpha in degree
rcg = cellfun(@transpose,RP.r_cm,'UniformOutput',false);
for i=1:length(rcg); rcg(i) = {rcg{1} / 1000}; end

 n = S.value{'dof'};
 
G = RP.gear_ratio;          %get gear ratio
Jm = RP.Jm;                 %get motor inertia
B = RP.viscous_friction;    %Viscous friction
Tc = RP.coulomb_friction;   %Coulomb Friction

% G = ones(1,n)';%RP.gear_ratio;  %get gear ratio
% Jm = zeros(1,n)';%RP.Jm;         %get motor inertia
% B = zeros(1,n)';%RP.viscous_friction;%Viscous friction
% Tc = zeros(1,n)';%RP.coulomb_friction;%Coulomb Friction

m = RP.mass;
Ixx = RP.Ixx';
Ixy = RP.Ixy';
Ixz = RP.Ixz';
Iyy = RP.Iyy';
Iyz = RP.Iyz';
Izz = RP.Izz';

% Assembling the Inertia matrix for each link
I(1:n) = {zeros(3,3)};
for i=1:n
    I{i} = [Ixx(i), -Ixy(i), -Ixz(i);
           -Ixy(i),  Iyy(i), -Iyz(i);
           -Ixz(i), -Iyz(i),  Izz(i)];
end



    z0 = [0;0;1];
    grav = S.value{'gravity'};   % default gravity from the object
    fext = zeros(6, 1);
   
    

    if size(a1, 2) == 3*n
        Q = a1(:,1:n);
        Qd = a1(:,n+1:2*n);
        Qdd = a1(:,2*n+1:3*n);
        np = size(Q,1);
        if nargin >= 2, 
            grav = a2(:);
        end
        if nargin == 3
            fext = a3;
        end
    else
        np = size(a1,1);
        Q = a1;
        Qd = a2;
        Qdd = a3;
        if size(a1,2) ~= n || size(Qd,2) ~= n || size(Qdd,2) ~= n || ...
            size(Qd,1) ~= np || size(Qdd,1) ~= np
            error('bad data');
        end
        if nargin >= 4, 
            grav = a4(:);
        end
        if nargin == 5
            fext = a5;
        end
    end
    
        tau = zeros(np,n);

    for p=1:np
        q = Q(p,:).';
        qd = Qd(p,:).';
        qdd = Qdd(p,:).';
    
        Fm = [];
        Nm = [];
        pstarm = [];
        Rm = [];
        
        % rotate base velocity and acceleration into L1 frame
        Rb = eye(3);%t2r(robot.base)';
        w = Rb*zeros(3,1);
        wd = Rb*zeros(3,1);
        vd = Rb*grav(:);

        
    % init some variables, compute the link rotation matrices
    %
        for j=1:n
            [~, Tj] = PF_Forward_Kinematics(rad2deg(q(j)), d(j), a(j), alpha(j));
%             link.A(q(j));

            % O_{j-1} to O_j in {j}, negative inverse of link xform
            pstar = [a(j); d(j)*sind(alpha(j)); d(j)*cosd(alpha(j))];

            pstarm(:,j) = pstar;
            Rm{j} = Tj{1}(1:3, 1:3);
        end

    %
    %  the forward recursion
    %
        for j=1:n

            Rt = Rm{j}.';    % transpose!!
            pstar = pstarm(:,j);
            r = rcg{j}';

            %
            % statement order is important here
            %
            
            % revolute axis
            wd = Rt*(wd + z0*qdd(j) + ...
                cross(w,z0*qd(j)));
            w = Rt*(w + z0*qd(j));
            %v = cross(w,pstar) + Rt*v;
            vd = cross(wd,pstar) + ...
                cross(w, cross(w,pstar)) +Rt*vd;


            %whos
            vhat = cross(wd,r.') + cross(w,cross(w,r.')) + vd;
            F = m(j)*vhat;
            N = I{j}*wd + cross(w, I{j} * w);
            Fm = [Fm F];
            Nm = [Nm N];
        end

    %
    %  the backward recursion
    %

        fext = fext(:);
        f = fext(1:3);      % force/moments on end of arm
        nn = fext(4:6);

        for j=n:-1:1
            pstar = pstarm(:,j);
            
            %
            % order of these statements is important, since both
            % nn and f are functions of previous f.
            %
            if j == n
                R = eye(3,3);
            else
                R = Rm{j+1};
            end
            r = rcg{j}';
            nn = R*(nn + cross(R.'*pstar,f)) + ...
                cross(pstar+r.',Fm(:,j)) + ...
                Nm(:,j);
            f = R*f + Fm(:,j);


            R = Rm{j};

            % revolute
            t = nn.'*(R.'*z0) + G(j)^2 * Jm(j)*qdd(j) - ...
                friction(B(j), G(j), Tc(j), qd(j));
            tau(p,j) = t;

        end
        % this last bit needs work/testing
        R = Rm{1};
        nn = R*(nn);
        f = R*f;
        wbase = [f; nn];
    end
end


function  tau = friction(B, G, Tc, qd)
    %Link.friction Joint friction force
    %
    % F = L.friction(QD) is the joint friction force/torque for link velocity QD.
    %
    % Notes::
    % - The returned friction value is referred to the output of the gearbox.
    % - The friction parameters in the Link object are referred to the motor.
    % - Motor viscous friction is scaled up by G^2.
    % - Motor Coulomb friction is scaled up by G.
    % - The appropriate Coulomb friction value to use in the non-symmetric case
    %   depends on the sign of the joint velocity, not the motor velocity.

    if size(Tc, 2) == 1 
        Tc = ones(1,2).*Tc(1);
    end

    tau = B * abs(G) * qd;

    if qd > 0
        tau = tau + Tc(1);
    elseif qd < 0
        tau = tau + Tc(2);
    end
    tau = -abs(G) * tau;     % friction opposes motion
end % friction()