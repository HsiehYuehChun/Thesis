%此程式能將沒有NaN的軌道資料用smooth函數擬合並且算出原始資料和平滑資料之間的差
%後續把資料填入網格的步驟不需要分軌道，但是做平滑需要將各個軌道分開 計算完差異後就能不管軌道了

for sample = 1:FN
    if sample == 1174
    else
%尋找每個軌道的始末『作為資料點的index』
orbitstart{sample} = [];   %記錄軌道開始於資料中第幾點
orbitend{sample} = [];     %記錄軌道結束於資料中第幾點

%『作為orbitstart/end的index』
startN{sample}(1) = 1;
endN{sample}(1) = 1;

%利用N~(N+1)來找有沒有跨軌道 
Y1 = length(nlat{sample})-1;           %加速程式的小技巧(把東西提到迴圈外)
for p1 = 1:Y1
    if p1 == 1
        orbitstart{sample}(startN{sample}(1)) = p1;
        startN{sample}(1) = startN{sample}(1) + 1;          %每次填入index要記得幫計數器加 1
    elseif nlat{sample}(p1) > nlat{sample}(p1+1)
        orbitend{sample}(endN{sample}(1)) = p1;
        endN{sample}(1) = endN{sample}(1) + 1;              %每次填入index要記得幫計數器加 1
        orbitstart{sample}(startN{sample}(1)) = p1 + 1;
        startN{sample}(1) = startN{sample}(1) + 1;          %每次填入index要記得幫計數器加 1
    end
end
orbitend{sample}( endN{sample}(1) ) = length(nlat{sample});   %資料終點也會是軌道終點
endN{sample}(1) = endN{sample}(1) + 1;                      %每次填入index要記得幫計數器加 1

%處理lattitude錯誤
Y2 = endN{sample}(1)-1;      %計數器原本加的1要扣掉
for p2 = 1:Y2
    if orbitstart{sample}(p2) == orbitend{sample}(p2)
        nd{sample}(orbitstart{sample}(p2)) = NaN;
        nlat{sample}(orbitstart{sample}(p2)) = NaN;
        nlon{sample}(orbitstart{sample}(p2)) = NaN;
        npitch{sample}(orbitstart{sample}(p2)) = NaN;
        nyaw{sample}(orbitstart{sample}(p2)) = NaN;
        nroll{sample}(orbitstart{sample}(p2)) = NaN;
        orbitstart{sample}(p2) = NaN;
        orbitend{sample}(p2) = NaN;
    end
end
orbitstart{sample} = realdata(orbitstart{sample}(:));
orbitend{sample} = realdata(orbitend{sample}(:));


%開始頭痛的地方 
%創 NaN container
Y3 = length(orbitstart{sample}(:));
nlatrow{sample} = NaN(2000,Y3);
ndrow{sample} = NaN(2000,Y3);
SG{sample} = NaN(2000,Y3);

for p3 = 1:Y3
    %將各個軌道獨立分行 一個軌道一行 總共(Y3)行
    nlatrow{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = nlat{sample}(orbitstart{sample}(p3):orbitend{sample}(p3));
    ndrow{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = nd{sample}(orbitstart{sample}(p3):orbitend{sample}(p3));
    %平滑擬合(span50)
    SG{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = smooth( nlatrow{sample}(1:( orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) , ndrow{sample}(1:( orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) , 50 );
end
%SG除了消除NaN也要消除0值
 SG{sample} = realdata(SG{sample});
 SG{sample} = not0data(SG{sample});
 
 nd{sample} = realdata(nd{sample});
 nlat{sample} = realdata(nlat{sample});
 nlon{sample} = realdata(nlon{sample});
 npitch{sample} = realdata(npitch{sample});
 nyaw{sample} = realdata(nyaw{sample});
 nroll{sample} = realdata(nroll{sample});
 
 Y4 = length(nd{sample}(:));
 for p4 = 1:Y4
     %計算差異(相減)
     diff{sample}(p4,1) = nd{sample}(p4) - SG{sample}(p4);
 end
    end
end
save('nd.mat', 'nd','-v7.3');
save('nlat.mat', 'nlat','-v7.3');
save('nlon.mat', 'nlon','-v7.3');
save('vz.mat', 'vz','-v7.3');
save('vlon.mat', 'vlon','-v7.3');
save('vlat.mat', 'vlat','-v7.3');
save('diff.mat', 'diff','-v7.3');
save('year.mat', 'year','-v7.3');
save('utcs.mat', 'utcs','-v7.3');
save('month.mat', 'month','-v7.3');
save('date.mat', 'date','-v7.3');
save('hour.mat', 'hour','-v7.3');
save('minute.mat', 'minute','-v7.3');
save('second.mat', 'second','-v7.3');

%figure(9)
%scatter(nlatrow,ndrow,2)
%xlabel('Latitude deg')
%ylabel('Number density #/c.c.')
%title('Fixed data in Certain Orbit')
%hold on


%figure(10)
%scatter(nlatrow,S,2)
%xlabel('Latitude deg')
%ylabel('Number density #/c.c.')
%title('Smoothed data in Certain Orbit')


%figure(11)
%plot(diff)
%xlabel('latitude deg')
%ylabel('number density #/c.c.')
%title('Difference Between Fixed and Smoothed data in Certain Orbit')
