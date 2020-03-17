clf;
% Vertices; Faces and size
V = []; F = []; S = [];
% Initialisation
% Download de la base du pectoral
[v1, f1, n1, name1] = stlRead("./M10-ASS-101A-00.STL");
v1 = [v1, ones(size(v1,1),1)];
%v1 = TRANSZ(320.8)*ROTX(pi)*TRANSX(-132.8)*TRANSY(-151.52)*v1';
v1 = v1*TRANSY(-151.52)'*TRANSX(-132.8)'*ROTX(pi)'*TRANSZ(320.8)'*ROTZ(pi)';
V = [V;v1]; % avec derniere ligne de 1
F = [F;f1];
S = [S; size(v1,1)];
%TEST Visualisation piece de la base du pectoral: 
% TR = triangulation(f1,v1(:,1:3));
% trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
% light('Position',[-1 0 0],'Style','local')

% Download de l'epaule
[v2, f2, n2, name2] = stlRead("./M10-ASS-202_REV05.STL");
v2 = [v2, ones(size(v2,1),1)];
v2 = v2*TRANSY(-75.406)'*TRANSX(-126.14)'*TRANSZ(-172.32)'*ROTX(pi)'*ROTZ(-pi/2)';
V = [V;v2];  % avec derniere ligne de 1
F = [F;f2+S(1)];
S = [S; size(v2,1)];
% %TEST Visualisation piece pectoral: 
% TR = triangulation(f2,v2(:,1:3));
% trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
% light('Position',[-1 0 0],'Style','local')

% Download du lien de l'épaule
[v3, f3, n3, name3] = stlRead("./M10-ASS-501.STL");
v3 = [v3, ones(size(v3,1),1)];
v3 = v3*TRANSX(-77.144)'*TRANSZ(-142.35)'*TRANSY(-72.04)'*ROTY(pi/2)';%'*ROTX(pi)'*ROTZ(pi/2)';
V = [V;v3];  % avec derniere ligne de 1
F = [F;f3+S(1)+S(2)];
S = [S; size(v3,1)];
% %TEST Visualisation piece pectoral: 
% TR = triangulation(f3,v3(:,1:3));
% trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
% light('Position',[-1 0 0],'Style','local')

% fonction plot 
% INPUT : avec q = [q(1) q(2)] (un lien)
n = 20;
%Q =[linspace(-pi/4,pi/4,n)',  linspace(pi/4,3*pi/4,n)'];
%for i=1:n
    clf();
%    q = Q(i,:);
q = [pi/4 pi/4];
     Transform2 = ROTZ(q(1))'*TRANSZ(187.8)';
    Transform3 = ROTZ(-q(2))'*ROTY(-pi/2)'*TRANSZ(69.32)'*TRANSY(52.62)';%
     Vplot = [V(1:S(1),:);V(S(1)+1:S(1)+S(2),:)*Transform2; V(S(1)+S(2)+1:S(1)+S(2)+S(3),:)*Transform3*Transform2];

    TR = triangulation(F,Vplot(:,1:3));
    trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
    xlim([-300 300])
    ylim([-300 300])
    zlim([0 600])
    light('Position',[-100 0 0],'Style','local')
    light('Position',[500 500 500],'Style','local')
    view([-1 -1.5 1])
    pause(0.01)
% end
