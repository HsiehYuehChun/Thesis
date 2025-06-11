function [row_real] = realdata(row_with_NaN)
counting = 1;
row_real = [];
TF = isnan(row_with_NaN(:));
a = length(row_with_NaN(:));
for i = 1:a
   if TF(i) == 0
      row_real(counting) = row_with_NaN(i);
      counting = counting + 1;
   end
end
row_real = row_real(:);
end