clc; clear all; close all;
%%
    if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
    end
                       
%%
s = serial('COM5','BaudRate',115200);

fopen(s);
com1=['08'; '06'; '00'; '00'; '00'; '00'; '89'; '53'; '00'];
com2=['08'; '06'; '00'; '00'; '00'; '01'; '48'; '93'; '00'];
com3=['08'; '06'; '00'; '00'; '00'; '02'; '08'; '92'; '00'];
com4=['08'; '06'; '00'; '00'; '00'; '03'; 'C9'; '52'; '00'];
request = uint8(hex2dec(com1));
fwrite(s, request); %start in de
 fclose(s)