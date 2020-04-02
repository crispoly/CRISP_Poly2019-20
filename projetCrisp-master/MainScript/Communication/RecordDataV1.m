function []=RecordDataV1(ToRecordMap,ToRecord)
% Utilise  les fonctions "get..." qui sont disponibles dans le sous-dossier "Communications"

for i=1:size(ToRecord,2)
    
if ToRecord(i)=="On"
    if ToRecordMap(i)=="Acceleration"
        [ a ] = get_a();
    else
        if ToRecordMap(i)=="Vitesse"
          [ v ] = get_v();
        end
    
    end
end

end


end