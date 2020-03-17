%==========================================================================
% >>>>>>>>>>>> FUNCTION MF-10: LOADING PROGRAM TABLE <<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will load the parameters table when the button
% edit robot parameter in settings tab is pressed.
% Refer to section 4 of documentation for details. 
%==========================================================================
function MF_Load_Program_table(P)
% Loading variables
HD = evalin('base', 'HD');   %Load handles from base workspace
Pcell = table2cell(P);   %table converted to cell
%% Converting to string (cts: converted table to string)
for row = 1:size(P,1)
    for col=1:size(P,2)
        if isnumeric(Pcell{row,col})
            Ptable(row, col) = {num2str(Pcell{row, col})};
        else
            if iscell(Pcell{row, col})
                Ptable(row, col) = {''};
%                 length(Pcell{row,col})
                for i = 1:length(Pcell{row,col})
                    if isnumeric(Pcell{row,col}{i})
                        Ptable{row, col} = [Ptable{row, col},' ', ...
                                              num2str(Pcell{row, col}{i})];
                    elseif ~isempty(Pcell{row,col}{i})
                        Ptable{row, col} = [Ptable{row, col},' ', ...
                                                       Pcell{row, col}{i}];
                    end
                end
            else
                Ptable(row, col) = {num2str(Pcell{row, col})};
            end
        end
    end
end

set(HD.program_table,'Data',Ptable); %Display in the table.    
end