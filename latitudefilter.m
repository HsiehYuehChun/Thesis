%���{���o���n�׹L���ɶq���쪺���

%�̤j���j��t�d�g�J�Ҧ��ɮ�
for sample = 1: FN
% nd part
    E1 = length(nd{sample}(:));
    for e1 = 1:E1
        if abs(nlat{sample}(e1))>45
            nd{sample}(e1) = NaN;
        end
    
    end

% vz part 
    E2 = length(vz{sample}(:));
    for e2 = 1:E2
        if abs(vlat{sample}(e2))>45
            vz{sample}(e2) = NaN;
        end
    end
end
