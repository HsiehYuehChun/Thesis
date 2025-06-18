function [row_real] = realdata(row_with_NaN)
% realdata - 將包含 NaN 的資料列（row_with_NaN）中的非 NaN 值提取出來
% 輸入：
%   row_with_NaN - 一列或一欄資料，可能包含 NaN 值
% 輸出：
%   row_real - 移除 NaN 後的資料（以 column vector 回傳）

% 初始化計數器，用來記錄有效值的位置
counting = 1;

% 建立空矩陣，用來儲存非 NaN 的資料
row_real = [];

% 使用 isnan() 找出每個元素是否為 NaN，結果為邏輯陣列（1 為 NaN，0 為正常值）
TF = isnan(row_with_NaN(:));

% 計算輸入資料的總元素數量（強制轉為 column vector）
a = length(row_with_NaN(:));

% 逐一檢查每個元素
for i = 1:a
    % 如果不是 NaN（即 TF(i) 為 0）
    if TF(i) == 0
        % 將該值加入 row_real
        row_real(counting) = row_with_NaN(i);
        % 增加計數器
        counting = counting + 1;
    end
end

% 確保輸出為 column vector 格式
row_real = row_real(:);
end
