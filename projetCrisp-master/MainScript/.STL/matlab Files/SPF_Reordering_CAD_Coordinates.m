%==========================================================================
% >>>>>>>>>>> FUNCTION SPF-4: ORDERING TABLE OF COORDINATES <<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 2.0 - March 30th, 2016.
 
% DESCRIPTION: This function will reorder the table of points from CAD,
% that is used in commands tab (Trajectory: modelled by table)
% Refer to section 4 of documentation for details. 
%==========================================================================

%DESCRIÇÃO:
% UM PERCURSO PODE SER DESENHADO EM UM SOFTWARE DE DESENHO COMO
%O AUTOCAD, QUE PODE SER GERADO UMA TABELA DE PONTOS(VER PROCEDIMENTO
%ABAIXO). A ORDEM DOS PONTOS NESSA TABELA NÃO SAEM CORRETAS, E COMO A ORDEM
%DOS PONTOS É IMPORTANTE PARA UMA TRAJETÓRIA, É NECESS�?RIO REORGANIZAR OS
%PONTOS UTILIZANDO O ALGOR�?TIMO ABAIXO.
% O ALGOR�?TMO SUBTRAI O PONTO INICIAL (ESCOLHIDO PELO USU�?RIO) DA TABELA DE
% PONTOS DEPOIS É ENCONTRADO O MÓDULO DESSA SUBTRAÇÃO DE VETORES, O MENOR
% MÓDULO É O PONTO POSTERIOR AO PONTO INICIAL, ESTE PONTO É ADICIONADO À
% UMA NOVA TABELA E APAGADO DA TABELA ANTIGA, O PROCESSO É REPETIDO ATÉ QUE
% TODOS OS PONTOS ESTEJAM REORGANIZADOS.
%**************************************************************************
% PROCEDIMENTO PARA CONVERTER UM TEXTO EM UMA TABELA DE PONTOS (NO AUTOCAD):
% OBS.: SERVE PARA TRAJETÓRIAS DESENHADAS TAMBÉM.
% - ABRA UM ARQUIVO NOVO DO AUTOCAD;
% - ESCREVA UM TEXTO (COM A FONTE DESEJADA);
% - DEFINA O TAMANHO DO TEXTO USANDO O COMANDO SCALE;
% - USE O COMANDO TXTEXP PARA EXPLODIR O TEXTO EM LINHAS;
% - USE O COMANDO EXPLODE PARA EXPLODIR AINDA MAIS AS LINHAS QUE
% PERMANECEREM JUNTAS;
% - APAGUE AS LINHAS DESNECESS�?RIAS (DEIXE APENAS O CONTORNO DE CADA LETRA)
% - USE O COMANDO JOIN PARA JUNTAR TODAS AS LINHAS DE UMA LETRA (CADA LETRA
% DEVE SER UM OBJETO SÓ). AS VEZES É NECESS�?RIO REPETIR O COMANDO V�?RIAS
% VEZES PARA TORNAR A LETRA EM UM OBJETO SÓ;
% - USE O COMANDO DIVIDE PARA DIVIDIR CADA LETRA EM PONTOS (DIGITE A
% QUANTIDADE DESEJADA DE PONTOS PARA CADA LETRA);
% - POSICIONE AS LETRAS PRÓXIMO DA ORIGEM (COORDENADA 0,0) DO ARQUIVO;
% - CLIQUE NO BOTÃO TABLE;
% - SELECIONE A OPCAO: From object data in the drawing (Data Extraction);
% - CLIQUE EM OK E DEPOIS EM NEXT;
% - DIGITE UM NOME PARA SALVAR O DESENHO ATUAL EM .DXE, CLIQUE EM SALVAR;
% - CLIQUE EM NEXT;
% - SELECIONE A OPÇÃO POINT E DESMARQUE AS DEMAIS, CLIQUE EM NEXT;
% - NA CAIXA DE OPÇÕES DO LADO DIREITO MARQUE APENAS GEOMETRY E DESMARQUE
% AS DEMAIS;
% - A LISTA DO LADO ESQUERDO VAI SER FILTRADA, SELECIONE Position X e
% Position Y, CLIQUE EM NEXT
% - CLIQUE EM NEXT NOVAMENTE;
% - MARQUE AS DUAS OP��ESS: Insert data extraction into drawing e Output
% data to external file;
% - CLIQUE EM NEXT DUAS VEZES E DEPOIS EM FINISH;
% - CLIQUE EM NA TELA DE DESENHO PARA FIXAR A TABELA COM OS PONTOS.
% - COPIE A TABELA DE PONTOS GERADOS EM EXCEL EM UMA VARI�?VEL DO MATLAB.
%==========================================================================
function SPF_Reordering_CAD_Coordinates(start, T)
% T: table with points from CAD file (excel)
% start: starting coordinate vector [x, y, z];
% start = [594, 765, 0];

% T = evalin('base', 'TP'); 
p = T;  %points
% p = p{:,:};
pnew = zeros(size(p)); %preallocating new organized matrix

pc = start; %set current position equal to start position

for i = 1:size(p,1)
    dist = [];  %cleaning dist matrix
    for j = 1:size(p,1)
        dist(j) = norm(pc - p(j,:));
    end

    min_idx = find(dist == min(dist), 1); %find which point is the closest
    pnew(i,:) = p(min_idx, :); %copying that row to the new matrix
    pc = p(min_idx, :);    %set the closest point as the current point
    p(min_idx,:) = [];  %clear that row in the table of points;
end


%converting to table
% TP = table(pnew);
TP = pnew;
assignin('base', 'TP', TP); 
MF_Update_Message(18, 'notice');
MF_Table_Coord_figure();    %reload table

% saving to excel file
% writetable(T,'ORGANIZED_TABLE.xlsx','WriteVariableNames',false)

    
    
    
