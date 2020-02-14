global map enabled_ddl
enabled_ddl = [0 1 0 0 0 0];
map = get_memmapfile();
init_commfile();
motorID = uint8(0);
DATA = []; Datagrams = [];
fileID = fopen('../TMCMBinaryFiles/MainProgramCRISP.bin');
DATA = fread(fileID);
fclose(fileID);
NumberOfLine = size(DATA,1)/8 + 4;
Datagrams = uint8(zeros(NumberOfLine,9));

fileID2 = fopen('ParametresControleurs.bin','r');
MatrixRead = fread(fileID, [6, 7], 'uint32');
fclose(fileID2);

% Enter download Mode
decalage = 0;
for motorID = 1:6
    if enabled_ddl(motorID)
        % Enter DownloadMode
        Datagrams(1+(NumberOfLine*decalage),1) = motorID+1; 
        Datagrams(1+(NumberOfLine*decalage),2) = 132;
        Datagrams(1+(NumberOfLine*decalage),9) = uint8(sum(Datagrams(1,[1:8]))); % checksum should not overflow
        % Loading of commands from DATA
        for i = 1 : NumberOfLine - 4
            Datagrams(i+1+(NumberOfLine*decalage),1) = motorID+1;
            Datagram = [motorID+1; DATA([(i-1)*8+1:(i-1)*8+7]); 0];
            if Datagram(2) == 5 % Commande SAP
                switch Datagram(3) 
                    case 177 % Start Current
                        Datagram = create_dg(motorID+1, 177, 0, 0, MatrixRead(motorID, 1));
                    case 4  % Max Velocity
                        Datagram = create_dg(motorID+1, 4, 0, 0, MatrixRead(motorID, 2));
                    case 172 % CoupleP
                        Datagram = create_dg(motorID+1, 172, 0, 0, MatrixRead(motorID, 3));
                    case 173 % CoupleI
                        Datagram = create_dg(motorID+1, 173, 0, 0, MatrixRead(motorID, 4));
                    case 234 % VelocityP
                        Datagram = create_dg(motorID+1, 234, 0, 0, MatrixRead(motorID, 5));
                    case 235 % VelocityI
                        Datagram = create_dg(motorID+1, 235, 0, 0, MatrixRead(motorID, 6));
                    case 230 % PositionP
                        Datagram = create_dg(motorID+1, 230, 0, 0, MatrixRead(motorID, 7));
                end
            end
            Datagrams(i+1+(NumberOfLine*decalage),[1:8]) = Datagram(1:8);
            Datagrams(i+1+(NumberOfLine*decalage),9) = bitand(sum(Datagrams(i+1,[1:8])),uint32(255)); % Checksum with overflow (prevent saturation)
        end
        % Opcode 0 send to the module 
        Datagrams(NumberOfLine - 2 +(NumberOfLine*decalage),1) = motorID+1; 
        Datagrams(NumberOfLine - 2 + (NumberOfLine*decalage),9) = sum(Datagrams(NumberOfLine - 2 + (NumberOfLine*decalage),[1:8])); % checksum should not overflow
        % Quit download Mode
        Datagrams(NumberOfLine - 1 + (NumberOfLine*decalage),1) =  motorID+1; 
        Datagrams(NumberOfLine - 1 + (NumberOfLine*decalage),2) = 133;
        Datagrams(NumberOfLine - 1 + (NumberOfLine*decalage),9) = sum(Datagrams(NumberOfLine - 1 + (NumberOfLine*decalage),[1:8])); % checksum should not overflow
        % Run Program from memory at address 0 
        Datagrams(NumberOfLine + (NumberOfLine*decalage),1) =  motorID+1; 
        Datagrams(NumberOfLine + (NumberOfLine*decalage),2) = 129;
        Datagrams(NumberOfLine + (NumberOfLine*decalage),9) = sum(Datagrams(NumberOfLine + (NumberOfLine*decalage),[1:8])); % checksum should not overflow
        decalage = decalage +1 ;
    end
end

% pause();
% 
%   for i = 1 : size(Datagrams,1)
%       send_other(Datagrams(i,:));
%   end