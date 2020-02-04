function [] = set_Port(portValue)
% Écrire dans le fichier PORTFILE.txt pour donner la valeur du port de
% connection sérial avec USB
fid=fopen('PORTFILE.txt','w');
fwrite(fid, portValue) ;                         % Save to file.
fclose(fid);
end
