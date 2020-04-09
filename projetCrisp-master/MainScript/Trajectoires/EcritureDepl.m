% % % % % global q x a7 d7
% % % % % global RobotC06
% % % % % global fichierq_ID
% % % % % global app
% % % % % %x= x y z, R P Y
% % % % % %q= q1 , ... , q7
% % % % % fid_DATA=fopen("Tour.dat","r");
% % % % % DATA=table2array(readtable("Tour.dat"));
% % % % % DATA=[DATA(2:end,1:6) , DATA(2:end,8:end)];
% % % % % % DATA=q1 , q2, q3, ... q6, x, y, z, R, P , Y
% % % % % for i=1:size(DATA,1)
% % % % %    q(1:6)=DATA(i,1:6); 
% % % % %    CineDirect(app);
% % % % %    update_qx(app)
% % % % % end
% % % % % 
% % % % % % CineInverse(app)
% % % % % 
% % % % % % Conversion des angles Roll-Pitch-Yaw et position en matrice
% % % % % % spatiale NOAP dans le format SE3
% % % % % NOAP = SE3.rpy(x(6),x(5),x(4));
% % % % % NOAP.t = x(1:3);
% % % % % NOAP.t = NOAP.t - d7*NOAP.a - a7*NOAP.n;
% % % % % q = RobotC06.ikcon(NOAP,q(1:6));
% % % % % % à Modifier pour position seulement       
% % % % % fprintf(fichierq_ID,'%2.10f \t %2.10f \t %2.10f \t %2.10f \t%2.10f \t%2.10f\n',q(1),q(2),q(3),q(4),q(5),q(6));

%% Spline sans arrêt entre les points
fid_DATA=fopen("Tour.dat","r");
DATA=table2array(readtable("Tour.dat"));
time_between_moves=DATA(1,1);
time_stop_between=DATA(1,1);
DATA=[DATA(2:end,1:6)];% , DATA(2:end,8:end)];
fid_ADAMS=fopen("TourADAMS.txt","w");


temps=linspace(0,time_between_moves*size(DATA,1),size(DATA,1))';
for k=1:size(DATA,2)
fprintf(fid_ADAMS,'DDL num %i ----------------------------- \n',k);
% ppol=spline(temps,DATA(:,k));
ppol = csape(temps,DATA(:,k),'clamped',[0 0]);
dataoutput=zeros(1,10000);
time_interpol=linspace(0,temps(end),length(dataoutput));
last_ind=1;
for i=1:length(ppol.breaks)-1
    ind=find(min(abs(ppol.breaks(i+1)-time_interpol))==abs(ppol.breaks(i+1)-time_interpol));
    timeblock=time_interpol(last_ind:ind);
    a=ppol.coefs(i,1);
    b=ppol.coefs(i,2);
    c=ppol.coefs(i,3);
    d=ppol.coefs(i,4);
    tdel=timeblock(1);
    dataoutput(last_ind:ind)=a*(timeblock-timeblock(1)).^3 +b*(timeblock-timeblock(1)).^2 +c*(timeblock-timeblock(1)) +d;
    last_ind=ind;
    % Ecriture de la fonction pour ADAMS en utilisant STEP pour séparer le
    % polynome piece
    % fprintf(fid_ADAMS,'%2.10f*(time-%2.10f)^3 + \t 2.10f*(time-%2.10f)^2 + \t 2.10f*(time-%2.10f) + \t %2.10f + \n',a,tdel,b,tdel,c,tdel,d);
    
        
    if i==length(ppol.breaks)-1
%         fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*((%2.10f)*(time-%2.10f)^3 + (%2.10f)*(time-%2.10f)^2 + (%2.10f)*(time-%2.10f) + (%2.10f))  \n',ppol.breaks(i),ppol.breaks(i)+0.003,ppol.breaks(i+1),ppol.breaks(i+1)+0.003,a,tdel,b,tdel,c,tdel,d);
            fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))   \n',ppol.breaks(i),ppol.breaks(i)+0.003,ppol.breaks(i+1),ppol.breaks(i+1)+0.003,tdel,d,c,b,a);
    else
            fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))  +\n',ppol.breaks(i),ppol.breaks(i)+0.003,ppol.breaks(i+1),ppol.breaks(i+1)+0.003,tdel,d,c,b,a);
    end
end
plot(time_interpol,dataoutput);
fprintf(fid_ADAMS,'---------------------------------------- \n\n');
end

%% Spline avec arrêt entre les points
fid_DATA=fopen("Trajectoire_Test.dat","r");
DATA=table2array(readtable("Trajectoire_Test.dat"));
time_between_moves=DATA(1,1)*4;
time_stop_between=DATA(1,1);
DATA=[DATA(2:end,1:6)];% , DATA(2:end,8:end)];
fid_ADAMS=fopen("TourADAMS.txt","w");


temps=linspace(0,(time_between_moves+time_stop_between)*size(DATA,1),size(DATA,1))';

previous_time=0;
actual_time=0;

for k=1:size(DATA,2)
fprintf(fid_ADAMS,'DDL num %i ----------------------------- \n',k);
% ppol=spline(temps,DATA(:,k));
 for h=1:size(DATA,1)-1
    previous_time=actual_time;
    actual_time=actual_time+time_between_moves;
    
    time_between_vect=linspace(previous_time,actual_time,2);
    ppol = csape(time_between_vect,DATA(h:h+1,k),'clamped',[0 0]);

    a=ppol.coefs(1);
    b=ppol.coefs(2);
    c=ppol.coefs(3);
    d=ppol.coefs(4);
    
    vfinale=DATA(h+1,k);
    % Ecriture de la fonction pour ADAMS en utilisant STEP pour séparer le
    % polynome piece
    if h==1
        fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0) +\n',DATA(1,k),previous_time,previous_time+0.003,actual_time,actual_time+0.003);
        previous_time=actual_time;
        actual_time=actual_time+time_stop_between;        
    end
    
    if h==size(DATA,1)-1
    fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))  + \n',previous_time,previous_time+0.003,actual_time,actual_time+0.003,previous_time,d,c,b,a);
    previous_time=actual_time;
    actual_time=actual_time+time_stop_between;
    fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0) \n',vfinale,previous_time,previous_time+0.003,actual_time,actual_time+0.003);
        
    else
    fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))  + \n',previous_time,previous_time+0.003,actual_time,actual_time+0.003,previous_time,d,c,b,a);
    previous_time=actual_time;
    actual_time=actual_time+time_stop_between;
    fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0) + \n',vfinale,previous_time,previous_time+0.003,actual_time,actual_time+0.003);
    end

 end
    previous_time=0;
    actual_time=0;

fprintf(fid_ADAMS,'---------------------------------------- \n\n');
end
%% Spline avec arrêt entre les points Version modifiée pour moteurs
fid_DATA=fopen("Tour.dat","r");
DATA=table2array(readtable("Tour.dat"));
time_between_moves=DATA(1,1)*4;
time_stop_between=DATA(1,1);
DATA=[DATA(2:end,1:6)];% , DATA(2:end,8:end)];
fid_ADAMS=fopen("TourADAMS2.txt","w");


temps=linspace(0,(time_between_moves+time_stop_between)*size(DATA,1),size(DATA,1))';

previous_time=0;
actual_time=0;

for k=1:size(DATA,2)
fprintf(fid_ADAMS,'DDL num %i ----------------------------- \n',k);
% ppol=spline(temps,DATA(:,k));
% dataoutput=zeros(1,100*size(DATA,1)-1);
 for h=1:size(DATA,1)-1
    previous_time=actual_time;
    actual_time=actual_time+time_between_moves;
    
    time_between_vect=linspace(previous_time,actual_time,2);
    ppol = csape(time_between_vect,DATA(h:h+1,k),'clamped',[0 0]);
vect=linspace(previous_time,actual_time,1000);
    a=ppol.coefs(1);
    b=ppol.coefs(2);
    c=ppol.coefs(3);
    d=ppol.coefs(4);
    dataoutput=a*(vect-previous_time).^3 +b*(vect-previous_time).^2 +c*(vect-previous_time) +d;
    
    vfinale=DATA(h+1,k);
    % Ecriture de la fonction pour ADAMS en utilisant STEP pour séparer le
    % polynome piece

    
    if h==size(DATA,1)-1
    fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))\n +',previous_time,previous_time+0.003,actual_time,actual_time+0.003,previous_time,d,c,b,a);
    previous_time=actual_time;
    actual_time=actual_time+time_stop_between;
    fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)\n',vfinale,previous_time,previous_time+0.003,actual_time,actual_time+0.003);
        
    else
%     if h==1
%         fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)\n +',DATA(1,k),previous_time,previous_time+0.003,actual_time,actual_time+0.003);
%         previous_time=actual_time;
%         actual_time=actual_time+time_stop_between;        
%     end        
    fprintf(fid_ADAMS,'STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0)*(POLY(time,%2.10e,%2.10e,%2.10e,%2.10e,%2.10e))  + \n',previous_time,previous_time+0.003,actual_time,actual_time+0.003,previous_time,d,c,b,a);
    previous_time=actual_time;
    actual_time=actual_time+time_stop_between;
    fprintf(fid_ADAMS,'%2.10e * STEP(time,%2.10f,0,%2.10f,1)*STEP(time,%2.10f,1.0,%2.10f,0.0) + \n',vfinale,previous_time,previous_time+0.003,actual_time,actual_time+0.003);
    end

 end
    previous_time=0;
    actual_time=0;

fprintf(fid_ADAMS,'---------------------------------------- \n\n');
end
