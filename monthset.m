%將整筆資料按照月份分成12個部分(每個部分粗估可能需要60000的容器存放)
%一個月分執行一個迴圈loop 減少RAM負擔
clc
clear
%先載入所有資料
load('VLATseries.mat');
load('VLONseries.mat');
load('monthseries.mat');
%load('F107series.mat');
load('NSseries.mat');
load('VZseries.mat');

%根據月份去分段落
%再根據單筆資料的長度去設定迴圈長度

L = length(monthseries);
for M = 1:12
    eval(['VLAT_',num2str(M),'=','[]',';']);
    eval(['VLON_',num2str(M),'=','[]',';']);
    %eval(['F107_',num2str(M),'=','[]',';']);
    eval(['NS_',num2str(M),'=','[]',';']);
    eval(['VZ_',num2str(M),'=','[]',';']);
    
    counter = 1;
    for l = 1:L
        if monthseries(l) == M
            eval(['VLAT_',num2str(M),'(counter)','=','VLATseries(l)',';']);
            eval(['VLON_',num2str(M),'(counter)','=','VLONseries(l)',';']);
            %eval(['F107_',num2str(M),'(counter)','=','F107series(l)',';']);
            eval(['NS_',num2str(M),'(counter)','=','NSseries(l)',';']);
            eval(['VZ_',num2str(M),'(counter)','=','VZseries(l)',';']);
            counter = counter + 1;
        end
    end
% save('FLAT_Lon.mat', 'FLAT_Lon','-v7.3');
%     (filename, ['events_' num2str(yr)]);
%
%filenameF1 = ['VLAT_' num2str(M) '.mat']; 
%F1 = eval(['VLAT_',num2str(M)]);
%save (filenameF1,F1)
    save(['VLAT_',num2str(M),'.mat'],['VLAT_',num2str(M)])
    save(['VLON_',num2str(M),'.mat'],['VLON_',num2str(M)])
    %save(['F107_',num2str(M),'.mat'],['F107_',num2str(M)])
    save(['NS_',num2str(M),'.mat'],['NS_',num2str(M)])
    save(['VZ_',num2str(M),'.mat'],['VZ_',num2str(M)])


end
