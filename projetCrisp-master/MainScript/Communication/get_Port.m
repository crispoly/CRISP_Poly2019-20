function portValue = get_Port()
% Lire le fichier PORTFILE.txt pour acqu�rir la valeur du port de
% connection s�rial avec USB
fid=fopen('PORTFILE.txt','r');
portValue = fgetl(fid);
fclose(fid);
end

