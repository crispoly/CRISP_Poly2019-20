function answer = MVP(port,slave,type,valeure)

%Move a la position absolue
n = int32(valeure); %Valeur!!

%Type
%0 Absolue
%1 Relatif
%2 COORD coordinate

%Target addr,Instruction,Type,#motor tjrs 0
byte(1:4) = uint8([slave,4,type,0]);

byte(5)= uint8(bitand(bitshift(n,-24),255) );
byte(6)= uint8(bitand(bitshift(n,-16),255) );
byte(7)= uint8(bitand(bitshift(n,-8),255) );
byte(8)= uint8(bitand(n,255) );
byte(9)=uint8(bitand(sum(byte(1:8)),255) );

%open com port for data transfer
fid = serial(port,'BaudRate',9600, 'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none');
fopen (fid);

%send command
fwrite(fid,byte);
pause(1);

%get answer
answer = fread(fid, 9, 'uint8');

%close com port connection
fclose(fid);

end

