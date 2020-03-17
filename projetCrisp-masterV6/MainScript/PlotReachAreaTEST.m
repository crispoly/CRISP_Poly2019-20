% Plot Reach area
global RobotC
Q = [];
n = 5; qmin =[]; qmax = [];
qmin(1) = -pi/2;
qmax(1) = pi/2;
qmin(2) = pi/4;
qmax(2) = pi/2+pi/4;
qmin(3) = -pi;
qmax(3) = pi;
qmin(4) = pi/4;
qmax(4) = pi/2;
qmin(5) = -pi;
qmax(5) = pi;
qmin(6) = pi/2;
qmax(6) = -pi/2;

for i=1:6
Q = [Q, linspace(qmin(i), qmax(i),n)'];
end
Q = [Q, zeros(n,1)];
ReachA = [];
for i=1:n
    for j=1:n
        for k=1:n
            for l=1:n
                for m=1:n
                    for o=1:n
                    ReachA = [ReachA; Q(i,1), Q(j,2), Q(k,3), Q(l,4) Q(m,5), Q(o,6), 0];
                    end
                end
            end
        end
    end
end
fKine = {};
p = [];
for i=1:size(ReachA,1)
    fKine{i} = RobotC.fkine(ReachA(i,:));
    p = [p, fKine{i}.t];
end
clf()
            hold on
            view(3) 
            axis([-800,1500,-1400,1500,-800,1000])
            view([180 -270 180])
            plotp(p)
            RobotC.plot([0 pi/2 0 0 0 0 0])
            hold off