%���{����N�S��NaN���y�D��ƥ�smooth������X�åB��X��l��ƩM���Ƹ�Ƥ������t
%������ƶ�J���檺�B�J���ݭn���y�D�A���O�����ƻݭn�N�U�ӭy�D���} �p�⧹�t����N�ण�ޭy�D�F

for sample = 1:FN
    if sample == 1174
    else
%�M��C�ӭy�D���l���y�@������I��index�z
orbitstart{sample} = [];   %�O���y�D�}�l���Ƥ��ĴX�I
orbitend{sample} = [];     %�O���y�D�������Ƥ��ĴX�I

%�y�@��orbitstart/end��index�z
startN{sample}(1) = 1;
endN{sample}(1) = 1;

%�Q��N~(N+1)�ӧ䦳�S����y�D 
Y1 = length(nlat{sample})-1;           %�[�t�{�����p�ޥ�(��F�责��j��~)
for p1 = 1:Y1
    if p1 == 1
        orbitstart{sample}(startN{sample}(1)) = p1;
        startN{sample}(1) = startN{sample}(1) + 1;          %�C����Jindex�n�O�o���p�ƾ��[ 1
    elseif nlat{sample}(p1) > nlat{sample}(p1+1)
        orbitend{sample}(endN{sample}(1)) = p1;
        endN{sample}(1) = endN{sample}(1) + 1;              %�C����Jindex�n�O�o���p�ƾ��[ 1
        orbitstart{sample}(startN{sample}(1)) = p1 + 1;
        startN{sample}(1) = startN{sample}(1) + 1;          %�C����Jindex�n�O�o���p�ƾ��[ 1
    end
end
orbitend{sample}( endN{sample}(1) ) = length(nlat{sample});   %��Ʋ��I�]�|�O�y�D���I
endN{sample}(1) = endN{sample}(1) + 1;                      %�C����Jindex�n�O�o���p�ƾ��[ 1

%�B�zlattitude���~
Y2 = endN{sample}(1)-1;      %�p�ƾ��쥻�[��1�n����
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


%�}�l�Y�h���a�� 
%�� NaN container
Y3 = length(orbitstart{sample}(:));
nlatrow{sample} = NaN(2000,Y3);
ndrow{sample} = NaN(2000,Y3);
SG{sample} = NaN(2000,Y3);

for p3 = 1:Y3
    %�N�U�ӭy�D�W�ߤ��� �@�ӭy�D�@�� �`�@(Y3)��
    nlatrow{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = nlat{sample}(orbitstart{sample}(p3):orbitend{sample}(p3));
    ndrow{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = nd{sample}(orbitstart{sample}(p3):orbitend{sample}(p3));
    %�������X(span50)
    SG{sample}( 1 : (orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) = smooth( nlatrow{sample}(1:( orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) , ndrow{sample}(1:( orbitend{sample}(p3) - orbitstart{sample}(p3) + 1 ) , p3 ) , 50 );
end
%SG���F����NaN�]�n����0��
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
     %�p��t��(�۴�)
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
