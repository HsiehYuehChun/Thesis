clc
clear
% F10.7 data came from https://lasp.colorado.edu/lisird/data/penticton_radio_flux/
load('D:\AIP\完整版6\JD.mat')
%第二批資料共有950組檔案
FN = 1352;
% 從官方下載的 penticton_radio_flux.xlsx 中讀取 F10.7 太陽通量資料
% JDseries 是原始時間序列（Julian Date），F107series 是對應的 F10.7 值
JDseries = xlsread('penticton_radio_flux.xlsx',1,'A2:A4618');
F107series = xlsread('penticton_radio_flux.xlsx',1,'B2:B4618');
%看一下總共有幾對資料
SeriesSize = length(JDseries);
%每一組資料做一次
for sample = 1:FN
    %該組資料的資料長度
    D = length(JD{sample});
    
    %掃描資料
    for d = 1:D
        %掃描表格的資料序列
        for dd = 1:(SeriesSize-1)
            if JD{sample}(d)>JDseries(dd)
                F107{sample}(d) = F107series(dd) + ( F107series(dd+1)-F107series(dd) )*( JD{sample}(d)-JDseries(dd) )/( JDseries(dd+1)-JDseries(dd) );
            end
        end
    end
end
save('F107.mat', 'F107','-v7.3');
