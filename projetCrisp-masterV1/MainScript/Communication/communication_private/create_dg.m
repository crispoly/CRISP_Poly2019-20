function datagram = create_dg(slave,instruction,type,bank,value)

% This function generate datagram

datagram = zeros(1,9)  ;
datagram = uint8(datagram) ;
n = int32(value) ; %Valeur!!

%Target addr,Instruction,Type,bank
datagram(1:4) = uint8([slave,instruction,type,bank]);

datagram(5)= uint8(bitand(bitshift(n,-24),255) );
datagram(6)= uint8(bitand(bitshift(n,-16),255) );
datagram(7)= uint8(bitand(bitshift(n,-8),255) );
datagram(8)= uint8(bitand(n,255) );
datagram(9)=uint8(bitand(sum(datagram(1:8)),255) );


end

