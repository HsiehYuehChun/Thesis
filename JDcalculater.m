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
    % 使用 MATLAB 內建的 juliandate 函數進行轉換
    JD{sample}(:) = juliandate( [ year{sample}(:) , month{sample}(:) , date{sample}(:) , hour{sample}(:) , minute{sample}(:) , second{sample}(:) ] );
end
% 將轉換後的儒略日結果儲存到 JD.mat 檔案，使用 -v7.3 格式以支援大型資料
save('JD.mat', 'JD','-v7.3');
