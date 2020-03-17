clf;
% Vertices; Faces and size
V = []; F = []; S = [];
%Initialisation
% Download de la base du pectoral
[v1, f1, n1, name1] = stlRead("./M10-ASS-101A-00.STL");
v1 = [v1, ones(size(v1,1),1)];
v1 = TRANSZ(320.8)*ROTX(pi)*TRANSX(-132.8)*TRANSY(-151.52)*v1';
v1 = v1(1:3,:);
V = [V,v1]; 
F = [F;f1];
S = [S; size(v1,2)];
% %TEST Visualisation piece de la base du pectoral: 
% TR = triangulation(f1,v1');
% trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
% light('Position',[-1 0 0],'Style','local')

%Dow
[v2, f2, n2, name2] = stlRead("./M10-ASS-202_REV05.STL");
v2 = [v2, ones(size(v2,1),1)];
v2 = ROTX(pi)*TRANSZ(-172.32)*TRANSX(-126.14)*TRANSY(-75.406)*v2';
v2 = v2(1:3,:);
V = [V,v2]; 
F = [F;f2];
S = [S; size(v2,2)];
% %TEST Visualisation piece pectoral: 
TR = triangulation(f2,v2');
trisurf(TR,'edgecolor', 'none', 'facecolor', [0.5 0.5 0.5]);
light('Position',[-1 0 0],'Style','local')

% a initialisation



