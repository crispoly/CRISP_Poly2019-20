function portValue = get_Port()
% Lire le fichier PORTFILE.txt pour acquérir la valeur du port de
% connection sérial avec USB
fid=fopen('PORTFILE.txt','r');
portValue = fgetl(fid);
fclose(fid);
end

