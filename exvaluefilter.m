%���{���o��0�I�Mnumber density�L�p�P�L�j���I(�p��1000�P�j��500000���o��)
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

%�������ƾ�(NaNcleaner)