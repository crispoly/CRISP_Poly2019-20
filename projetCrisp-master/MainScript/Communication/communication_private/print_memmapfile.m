function [ ] = print_memmapfile( map, fields )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if ~exist('fields','var')
    fields = fieldnames(map.data(1));
else
    fields = cellstr(fields);
end

n = length(fields);
for i = 1:n
    field = fields(i);
    fprintf('%s\n', field{1});
    dg = read_dg(map,field,1);
    fprintf('%d %d %d %d %d %d %d %d %d\n',dg(1),dg(2),dg(3),dg(4),dg(5),dg(6),dg(7),dg(8),dg(9));
    dg = read_dg(map,field,2);
    fprintf('%d %d %d %d %d %d %d %d %d\n',dg(1),dg(2),dg(3),dg(4),dg(5),dg(6),dg(7),dg(8),dg(9));
end
end

