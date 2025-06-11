%此程式會直接濾除大於前後2點數據兩倍標準差的點

%使用前先濾一次0值(全部子資料一起濾除)
%再濾一次NaN(確保所有子資料大小一樣)


%最大的迴圈負責寫入所有檔案
for sample = 1:FN
    
%濾除標準差的倍數
for times = [0.000005]

S = size(nd{sample}(:))-2; %取4個點做標準差 只針對s計算    
for s = 1:S
    
%if迴圈內的指令皆為判斷式
    if s <= 2  %若s1為2以下的數字(必為軌道開始)
         
    elseif nlat{sample}(s) > nlat{sample}(s+2)        %s1到s1+2之間跨軌道 且s1>2(逕行忽略)
    
    elseif nlat{sample}(s-2) > nlat{sample}(s)        %s1-2到s1之間跨軌道 且s1>2(逕行忽略)
          
    else   %大部分情況 前後2點都沒有跨軌道
        %運算/判斷式
          ndseq = [nd{sample}(s-2) nd{sample}(s-1) nd{sample}(s+1) nd{sample}(s+2)];
          SD = std(ndseq);
               if abs( nd{sample}(s) - ( nd{sample}(s-1) + nd{sample}(s+1) )/2 ) > SD*times
                   nd{sample}(s) = NaN;
               end
    end
end
end
end
%結束後整數據(NaNcleaner)