%此程式濾除0點和number density過小與過大的點(小於1000與大於500000皆濾除)
for sample = 1:FN
   U1 =  size(nd{sample}(:));
   for o = 1:U1
       U2 = nd{sample}(o);
       if U2 < 1000
           nd{sample}(o) = NaN;
       elseif U2 > 500000
           nd{sample}(o) = NaN;
       end
   end
end

%結束後整數據(NaNcleaner)