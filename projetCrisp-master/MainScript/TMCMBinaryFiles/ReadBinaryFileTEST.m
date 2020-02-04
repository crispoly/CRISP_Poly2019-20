global map enabled_ddl
map = get_memmapfile();
enabled_ddl = [1 1 0 0 0 0];
init_commfile();
motorID = uint8(2);
fileID = fopen('../TMCMBinaryFiles/hamza4.bin');
DATA = fread(fileID);
Datagrams = uint8(zeros(size(DATA,1)/8+3,9));
% Enter download Mode 
Datagrams(1,1) = motorID+1; 
Datagrams(1,2) = 132;
Datagrams(1,9) = uint8(sum(Datagrams(1,[1:8]))); % checksum should not overflow
% Loading of commands from DATA
for i = 1 : size(DATA,1)/8
    Datagrams(i+1,1) = motorID+1;
    Datagrams(i+1,[2:8]) = DATA([(i-1)*8+1:(i-1)*8+7]);
    Datagrams(i+1,9) = bitand(sum(Datagrams(i+1,[1:8])),uint32(255)); % Checksum with overflow (prevent saturation)
end
% Opcode 0 send to the module 
Datagrams(end-1,1) = motorID+1; 
Datagrams(end-1,9) = sum(Datagrams(end-1,[1:8])); % checksum should not overflow
% Quit download Mode
Datagrams(end,1) = motorID+1; 
Datagrams(end,2) = 133;

Datagrams(end,9) = sum(Datagrams(end,[1:8])); % checksum should not overflow
pause();

for i = 1 : size(Datagrams,1)
    send_other(Datagrams(i,:));
end