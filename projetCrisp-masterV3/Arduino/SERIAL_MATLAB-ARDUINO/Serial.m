clear all;
close all;
clc;

%%
s = serial('COM6');

%%
fopen(s);

%%
fwrite(s,'1')
%fgets(s);