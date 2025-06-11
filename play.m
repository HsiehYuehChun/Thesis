%%
%run loadfile.m
%run NaNcleaner.m
%run exvaluefilter.m
%run NaNcleaner.m
%run FBstdfilter_2point.m
%run NaNcleaner.m
%%
%run FBstdfilter_3point.m
%run NaNcleaner.m
%run latitudefilter.m
%run NaNcleaner.m
%run attitudefilter_fix.m  %部分姿態資料不穩定導致過濾掉部分重點觀察區域的資料(已修正)
%run NaNcleaner.m
%run smoothdata_perorbit.m
%%
%run JDcalculater.m
%run F107calculator.m
%%
%run meshNplot.m
%%
run series_transform.m
run monthset.m
