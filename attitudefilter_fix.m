%���{���o���ìP���A��{���ήɶq���쪺���

%�̤j���j��t�d�g�J�Ҧ��ɮ�
for sample = 1: FN
    
%
% n part %

% pitch
T1 = median(npitch{sample}(:));
TT1 = size(nd{sample}(:));
for i1 = 1:TT1
    if abs(npitch{sample}(i1) - T1) > 0.05
        nd{sample}(i1) = NaN;
    end
end

%
% v part %

% pitch
T2 = median(vpitch{sample}(:));
TT2 = size(vz{sample}(:));
for i2 = 1:TT2
    if abs(vpitch{sample}(i2) - T2) > 0.12
        vz{sample}(i2) = NaN;
    end
end

% roll
T3 = median(vroll{sample}(:));
TT3 = size(vz{sample}(:));
for i3 = 1:TT3
    if abs(vroll{sample}(i3) - T3) > 0.12
        vz{sample}(i3) = NaN;
    end
end
end

%�������ƾ�(NaNcleaner)