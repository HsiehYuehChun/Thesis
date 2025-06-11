clc
clear
cd 'D:\AIP\完整版6'
load('D:\AIP\完整版6\cvm.mat')
FN = 1352;
for sample = 1:FN
cvf{:,sample} = cvm(1,sample);
end
save('cvf.mat', 'cvf','-v7.3');
%%
%clc
%clear
cd 'D:\AIP\完整版6'
%load('D:\AIP\完整版6\ndm.mat')
FN = 338;
for sample = 1:FN
ndf3{:,sample} = ndm(1,sample);
end
%save('ndf3.mat', 'ndf3','-v7.3');
%%
%clc
%clear
%load('D:\AIP\完整版6\cvf.mat')
%FN = 1352;
%最大的迴圈負責寫入所有檔案
for sample = 1:FN

%從樣本裡讀取時間戳記
W = size(cvf{:,sample}.k(:,1));
YDstring{sample}(:) = string(table2array(cvf{:,sample}.k(:,1)));
utcstring{sample}(:) = string(table2array(cvf{:,sample}.k(:,2)));

[year{sample}(:),monthdate{sample}(:)] = strtok(YDstring{sample}(:),'/');
year{:,sample} = str2double(year{sample}(:));
[month{sample}(:),date{sample}(:)] = strtok(monthdate{sample}(:),'/');
month{:,sample} = str2double(month{sample}(:));
[date{sample}(:)] = strtok(date{sample}(:),'/');
date{:,sample} = str2double(date{sample}(:));

[hour{sample}(:),minutesecond{sample}(:)] = strtok(utcstring{sample}(:),':');
hour{:,sample} = str2double(hour{sample}(:));
[minute{sample}(:),second{sample}(:)] = strtok(minutesecond{sample}(:),':');
minute{:,sample} = str2double(minute{sample}(:));
[second{sample}(:)] = strtok(second{sample}(:),':');
second{:,sample} = str2double(second{sample}(:));

%計算 UTCsecond
utcs{sample}(:) = hour{sample}(:)*3600 + minute{sample}(:)*60 + second{sample}(:);

%從時間戳記裡得到的參數來計算 Date of Year
ZEROO = zeros(W);
ONESS = ones(W);
datevector{:,sample} = [year{:,sample} month{:,sample} date{:,sample} ZEROO ZEROO ZEROO];
dv0{:,sample} = [year{:,sample} ONESS ONESS ZEROO ZEROO ZEROO];
DOY{:,sample} = datenum(datevector{:,sample}) - datenum(dv0{:,sample}) + 1;

%從樣本裡提取不同列的資料(速度)
vroll{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,6))));
vpitch{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,7))));
vyaw{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,8))));
vlat{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,3))));
vlon{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,4))));
vz{:,sample} = str2double(string(table2array(cvf{:,sample}.k(:,21))));
end
%結束後整數據(NaNcleaner)
save('vz.mat', 'vz','-v7.3');
save('vlon.mat', 'vlon','-v7.3');
save('vlat.mat', 'vlat','-v7.3');
save('vpitch.mat', 'vpitch','-v7.3');
save('vyaw.mat', 'vyaw','-v7.3');
save('vroll.mat', 'vroll','-v7.3');
save('year.mat', 'year','-v7.3');
save('DOY.mat', 'DOY','-v7.3');
save('utcs.mat', 'utcs','-v7.3');
save('month.mat', 'month','-v7.3');
save('date.mat', 'date','-v7.3');
save('hour.mat', 'hour','-v7.3');
save('minute.mat', 'minute','-v7.3');
save('second.mat', 'second','-v7.3');
%%
%clc
%clear
%load('D:\AIP\完整版6\ndf3.mat')
%FN = 1352;
for sample = 1:338
%從樣本裡提取不同列的資料(密度)
nroll3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,6))));
npitch3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,7))));
nyaw3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,8))));
nlat3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,3))));
nlon3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,4))));
nd3{:,sample} = str2double(string(table2array(ndf3{:,sample}.r(:,12)))); 
end
%結束後整數據(NaNcleaner)
save('nd3.mat', 'nd3','-v7.3');
save('nlat3.mat', 'nlat3','-v7.3');
save('nlon3.mat', 'nlon3','-v7.3');
save('npitch3.mat', 'npitch3','-v7.3');
save('nyaw3.mat', 'nyaw3','-v7.3');
save('nroll3.mat', 'nroll3','-v7.3');