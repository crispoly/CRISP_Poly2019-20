%%% Initialisation des Variables et des constantes du systeme
close all;
clear all;
clc;
load('globalVal.mat'); % Charger les valeurs globales du bras
global COMport;

COMport = input('Entrer votre port (ex: COM1): ','s');

fid = serial(COMport,'BaudRate',115200, 'DataBits', 8, 'Parity', 'none','StopBits', 1, 'FlowControl', 'none');
fopen (fid);

%%% Calibration

