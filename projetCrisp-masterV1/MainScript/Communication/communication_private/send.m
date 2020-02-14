function answer = send(bus, datagram)
%This function sends the datagram and reads the answer (Used by Commbot)

%send command
fwrite(bus, datagram);

%get answer
answer = fread(bus, 9, 'uint8'); %Lecture de la réponse du contrôleur

end
