% Structure du fichier DATA des paramères modifiables des contrôleurs TMCM
% Matrice de uint32 6x7
% Linge : Contrôleurs 1 à 6
% Colonne: StartCurrent MaxVelocity CoupleP CoupleI VelocityP VelocityI PositionP 
DATADefautLigne = uint32([4000 600 550 200 5000 100 20]);
Matrix = [];
for i = 1:6
    Matrix = [Matrix; DATADefautLigne];
end

fileID = fopen('ParametresControleurs.bin','w');
fwrite(fileID, Matrix,'uint32');
fclose(fileID);

fileID = fopen('ParametresControleurs.bin','r');
MatrixReadTest = fread(fileID, [6, 7], 'uint32');
fclose(fileID);
