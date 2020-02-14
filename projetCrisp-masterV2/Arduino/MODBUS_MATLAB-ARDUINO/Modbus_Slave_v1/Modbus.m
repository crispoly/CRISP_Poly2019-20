%%
m = modbus('serialrtu','COM6')      %%COM6 pour usb to TTL, COM3 pour simple arduino

%% Read pour les capteurs
% 1er argument: l'objet modbus
% 2e argument : 'coils'
% 3e argument: Starting address
% 4e argument : Nb de coils a lire
% 5e argument: LE SLAVE ID
read(m,'coils',1,8,2)


%% Write
% 1er argument: l'objet modbus
% 2e argument : Type
% 3e argument: Starting address
% 4e argument : Valeure
% 5e argument: Slave id
% 6e argument: Precision si ncessaire
write(m,'coils',0,1,2)

%% writeRead pour les controleurs ... PAS ENCORE FONCTIONNEL POUR ARDUINO
% 1er argument: l'objet modbus
% 2e argument : Addresse d'ecriture
% 3e argument: valeure
% 4e argument : Addresse de lecture
% 5e argument: Readcount Nb de trucs lu
% 6e argument: Server ID (Slave id)

writeRead(m,0,1,0,8,2)