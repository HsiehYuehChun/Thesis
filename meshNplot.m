%先用過姿態過濾器和標準差過濾器再用此程式(使用diff資料)
%load vlat vlon vz nlat nlon diff month/DOY F107 (FN = 1111)
clc
clear
load('diff.mat')
load('month.mat')
load('vlat.mat')
load('vlon.mat')
load('vz.mat')
load('nlat.mat')
load('nlon.mat')
%load('F107.mat')
FN = 1352;
%最大的迴圈負責填入所有資料
for sample = 1:FN 
%built up a container
NmeshNaN{sample} = NaN(91,361,18);  %從南緯(-)45度到北緯(+)45度(要再確認每一筆資料的情況)
                                    %從西經(-)180度到東經(+)180度(一樣要再確認)
VmeshNaN{sample} = NaN(91,361,18);  %從南緯(-)45度到北緯(+)45度(要再確認每一筆資料的情況)
                                    %從西經(-)180度到東經(+)180度(一樣要再確認)
monthmeshNaN{sample} = NaN(91,361,18);
%F107meshNaN{sample} = NaN(91,361,18);                                   

%一筆一筆資料餵 同時用判斷式分類資料 存入container
%差異值----------------------------------------------------------------------------
U1 = length(diff{sample}(:));
for u1 = 1:U1
    for la = -45:1:45          %用這個迴圈去判斷存入位置(NmeshNaN)
        %先將特例列出(頭尾行皆存入這筆資料)
        U11 = nlon{sample}(u1);
        if U11<-179.5 && U11>179.5
            if (la-0.5) < nlat{sample}(u1) && nlat{sample}(u1) < (la+0.5)
                F = find_1st_NaN(NmeshNaN{sample}(la+46,1,:));
                NmeshNaN{sample}(la+46,1,F) = diff{sample}(u1);
                F = find_1st_NaN(NmeshNaN{sample}(la+46,361,:));
                NmeshNaN{sample}(la+46,361,F) = diff{sample}(u1);
            end
        else
            %大部分情況
            for lo = -179:1:179
                U12 = nlat{sample}(u1);
                if (la-0.5) < U12 && U12 < (la+0.5)
                   if (lo-0.5) < nlon{sample}(u1) && nlon{sample}(u1) < (lo+0.5)
                       F = find_1st_NaN(NmeshNaN{sample}(la+46,lo+181,:));
                      NmeshNaN{sample}(la+46,lo+181,F) = diff{sample}(u1);
                   end
                end
            end
        end        
    end
end
% remains parameters---------------------------------------------------------------------------
U2 = length(vz{sample}(:));
for u2 = 1:U2
    for la = -45:1:45          %用這個迴圈去判斷存入位置(VmeshNaN)
        %先將特例列出(頭尾行皆存入這筆資料)
        U21 = vlon{sample}(u2);
        if U21<-179.5 && U21>179.5
            if (la-0.5) < vlat{sample}(u2) && vlat{sample}(u2) < (la+0.5)
                %西經180度
                F = find_1st_NaN(VmeshNaN{sample}(la+46,1,:));
                VmeshNaN{sample}(la+46,1,F) = vz{sample}(u2);
                F = find_1st_NaN(monthmeshNaN{sample}(la+46,1,:));
                monthmeshNaN{sample}(la+46,1,F) = month{sample}(u2);
%                F = find_1st_NaN(F107meshNaN{sample}(la+46,1,:));
%                F107meshNaN{sample}(la+46,1,F) = F107{sample}(u2);
                
                %東經180度
                F = find_1st_NaN(VmeshNaN{sample}(la+46,361,:));
                VmeshNaN{sample}(la+46,361,F) = vz{sample}(u2);
                F = find_1st_NaN(monthmeshNaN{sample}(la+46,361,:));
                monthmeshNaN{sample}(la+46,361,F) = month{sample}(u2);
%                F = find_1st_NaN(F107meshNaN{sample}(la+46,361,:));
%                F107meshNaN{sample}(la+46,361,F) = F107{sample}(u2);                
            end
        else
            %大部分情況
            for lo = -179:1:179
                  U22 = vlat{sample}(u2);
                if (la-0.5) < U22 && U22 < (la+0.5)
                   if (lo-0.5) < vlon{sample}(u2) && vlon{sample}(u2) < (lo+0.5)
                       F = find_1st_NaN(VmeshNaN{sample}(la+46,lo+181,:));
                       VmeshNaN{sample}(la+46,lo+181,F) = vz{sample}(u2);
                       F = find_1st_NaN(monthmeshNaN{sample}(la+46,lo+181,:));
                       monthmeshNaN{sample}(la+46,lo+181,F) = month{sample}(u2);
%                       F = find_1st_NaN(F107meshNaN{sample}(la+46,lo+181,:));
%                       F107meshNaN{sample}(la+46,lo+181,F) = F107{sample}(u2);
                   end
                end
            end
        end        
    end
end

% calculate standard deviation

for line = 1:91
    for column = 1:361
         NSTD{sample}(line,column) = nanstd(NmeshNaN{sample}(line,column,:));
         %可能只有一個數據點 標準差只會等於0 且資料過少沒有代表性 對於訓練資料沒有幫助(或是一堆同值資料)
         %也可以直接從陣列大小去判斷 若資料點少於五個這筆資料也不具代表性
         if  size(NmeshNaN{sample}(line,column,:)) < 4 
             NSTD{sample}(line,column) = NaN;
         elseif NSTD{sample}(line,column) == 0
             NSTD{sample}(line,column) = NaN;
         end            
    end
end

% making series
NScellseries{sample} = NaN(1000,1);
VZcellseries{sample} = NaN(1000,1);
VLATcellseries{sample} = NaN(1000,1);
VLONcellseries{sample} = NaN(1000,1);
monthcellseries{sample} = NaN(1000,1);
F107cellseries{sample} = NaN(1000,1);
% 特別注意邊界只需取一次 
for line = 1:91
    for column = 1:360
        VMED{sample}(line,column) = median(VmeshNaN{sample}(line,column,:),'omitnan');
        LAT{sample}(line,column) = line - 46;
        LON{sample}(line,column) = column - 181;
        montharray{sample}(line,column) = median(monthmeshNaN{sample}(line,column,:),'omitnan');
%        F107avg{sample}(line,column) = mean(F107meshNaN{sample}(line,column,:),'omitnan');
%        
        if isnan(VMED{sample}(line,column)) || isnan(NSTD{sample}(line,column))
        else
            F = find_1st_NaN(NScellseries{sample}(:));
            NScellseries{sample}(F) = NSTD{sample}(line,column);
            F = find_1st_NaN(VZcellseries{sample}(:));
            VZcellseries{sample}(F) = VMED{sample}(line,column);
            F = find_1st_NaN(VLATcellseries{sample}(:));
            VLATcellseries{sample}(F) = LAT{sample}(line,column);
            F = find_1st_NaN(VLONcellseries{sample}(:));
            VLONcellseries{sample}(F) = LON{sample}(line,column);
            F = find_1st_NaN(monthcellseries{sample}(:));
            monthcellseries{sample}(F) = montharray{sample}(line,column);
%            F = find_1st_NaN(F107cellseries{sample}(:));
%            F107cellseries{sample}(F) = F107avg{sample}(line,column);
        end
    end
end
end
%save('Nmesh.mat', 'Nmesh','-v7.3');
%save('Vmesh.mat', 'Vmesh','-v7.3');
save('NSTD.mat', 'NSTD','-v7.3');
save('VMED.mat', 'VMED','-v7.3');
%Sam = 100;
%建立網格繪圖
%[X,Y] = meshgrid(-180:1:180,-45:1:45);
%figure(7)
%mesh(X,Y,NSTD{Sam})
%hold on
%load coast
%plot(long,lat,'g')