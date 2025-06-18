function row_real = realdata(row_with_NaN)
% 去除 NaN 並回傳非 NaN 元素（column vector）
row_real = row_with_NaN(~isnan(row_with_NaN));
row_real = row_real(:);
end
