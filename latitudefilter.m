%此程式濾除緯度過高時量測到的資料

%最大的迴圈負責寫入所有檔案
for sample = 1: FN
% nd part
    E1 = length(nd{sample}(:));
    for e1 = 1:E1
        if abs(nlat{sample}(e1))>45
            nd{sample}(e1) = NaN;
        end
    
    end

% vz part 
    E2 = length(vz{sample}(:));
    for e2 = 1:E2
        if abs(vlat{sample}(e2))>45
            vz{sample}(e2) = NaN;
        end
    end
end
