%此程式要將所有NaN的資料同步 並且使用realdata副程式一併濾除
for sample = 1:FN
   %主要看有NaN的nd和vz資料 先把同個時間戳記的nd/vz系列資料以NaN取代
   %而後全部濾除
   
   %先巡nd
   R1 = size(nd{sample}(:));
   for r1 = 1:R1
       if isnan(nd{sample}(r1))
           nroll{sample}(r1) = NaN;
           npitch{sample}(r1) = NaN;
           nyaw{sample}(r1) = NaN;
           nlat{sample}(r1) = NaN;
           nlon{sample}(r1) = NaN;
       end   
   end

   %再巡vz
   R4 = size(vz{sample}(:));
   for r4 = 1:R4
       if isnan(vz{sample}(r4))
           vroll{sample}(r4) = NaN;
           vpitch{sample}(r4) = NaN;
           vyaw{sample}(r4) = NaN;
           vlat{sample}(r4) = NaN;
           vlon{sample}(r4) = NaN;
           year{sample}(r4) = NaN;
           month{sample}(r4) = NaN;
           date{sample}(r4) = NaN;
           DOY{sample}(r4) = NaN;
           hour{sample}(r4) = NaN;
           minute{sample}(r4) = NaN;
           second{sample}(r4) = NaN;
           utcs{sample}(r4) = NaN;
       end
   end
   

%濾掉NaN
nd{sample} = realdata(nd{sample}(:));
nroll{sample} = realdata(nroll{sample}(:));
npitch{sample} = realdata(npitch{sample}(:));
nyaw{sample} = realdata(nyaw{sample}(:));
nlat{sample} = realdata(nlat{sample}(:));
nlon{sample} = realdata(nlon{sample}(:));

vz{sample} = realdata(vz{sample}(:));
vroll{sample} = realdata(vroll{sample}(:));
vpitch{sample} = realdata(vpitch{sample}(:));
vyaw{sample} = realdata(vyaw{sample}(:));
vlat{sample} = realdata(vlat{sample}(:));
vlon{sample} = realdata(vlon{sample}(:));
year{sample} = realdata(year{sample}(:));
month{sample} = realdata(month{sample}(:));
date{sample} = realdata(date{sample}(:));
DOY{sample} = realdata(DOY{sample}(:));
hour{sample} = realdata(hour{sample}(:));
minute{sample} = realdata(minute{sample}(:));
second{sample} = realdata(second{sample}(:));
utcs{sample} = realdata(utcs{sample}(:));  
end