clc
clear
load('year.mat')
load('month.mat')
load('date.mat')
load('hour.mat')
load('minute.mat')
load('second.mat')
%預先計算檔案數量並填入FN
FN = 1352;

for sample = 1:FN
    JD{sample}(:) = juliandate( [ year{sample}(:) , month{sample}(:) , date{sample}(:) , hour{sample}(:) , minute{sample}(:) , second{sample}(:) ] );
end
save('JD.mat', 'JD','-v7.3');