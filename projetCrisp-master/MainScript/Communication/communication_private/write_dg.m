function [ ] = write_dg( map, field, dg, c )
%write_dg Fonction pour �crire s�curitairement un dg dans le memmap
%   Le premier byte est un byte d'�tat: il doit �tre � z�ro avant
%   l'utilisation. On doit d'abord le chang�, puis �crire le datagram et
%   finalement le remettre � z�ro.
%
%   map: memmapfile object
%   field: ex 'pos_1'
%   dg: datagram
%   c: 'c' ou 1 pour une commande et 'r' ou 2 pour une r�ponse

busy = 1;

% switch c
%     case 'c'
%         c = 1;
%     case 'r'
%         c = 2;
%     case 1
%     case 2
%     otherwise
%         error('c Invalide dans write_dg');
% end

% while map.data(1).(field)(c,1) ~= 0
%     fprintf('writing bussyyyy\n');
% end    
    
    
map.data(1).(field{1})(c,1) = busy;
if c == 1   %Clear answer if command
    write_dg(map, field, uint8(zeros(1,9)), 2);
end
map.data(1).(field{1})(c,2:10) = dg;
map.data(1).(field{1})(c,1) = 0;



end

