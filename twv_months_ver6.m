% 同時對不同月份以及隱藏層量進行訓練
% 改變計算correlation coefficients(CC)的方法：同時比對各經緯的中位數與最大值
% 這個版本在歸一化target值時 將部份極值壓低 嘗試提高訓練成效
% ex:超過(5~8*10^3)的NS皆令為1, 以下的值照常歸一化(最終定為5500)
% 對vertical drift的值取log10(將數值較小的區域特徵放大)
% output對target CC夠高的演算法進行儲存
% 同時標記: 月份_層數_中位數CC值_最大值CC值
% 
%--------------------------------------------------------------------------
% 設置
% Input: VLAT VLON F107 VZ
% Target: NS
% With feedforwardnet
%         ↓
%        Output
%--------------------------------------------------------------------------
% 使用結果(part 1：中位數CC)
% (初始測試值)NS門檻值設為5*10^3在所有月份皆能取得CC大於0.5的成效
% NS門檻值設為5.5*10^3 以下 在所有月份皆能取得CC大於0.5的成效(In the end)
% NS門檻值設為6~5.8*10^3只有在4月無法取得CC大於0.5的成效
% NS門檻值設為6.5*10^3在3~4月無法取得CC大於0.5的成效
% NS門檻值設為8*10^3在2~4月無法取得CC大於0.5的成效
% 對於訓練層數過高的演算法會容易在太平洋及非洲地區產生output脫序(異常高的outliers)
% (part 2：最大值CC)
% 搭配中位數的CC 在所有月份各自都能取得0.5以上的中位數/最大值CC 但各月份的訓練表現不盡相同
% 最大值CC有時會比中位數CC大


%--------------------------------------------------------------------------
clc
clear
JK = 1;
while JK == 1
    for M = 1:12
        %匯入後段資料(驗證用)
        cd 'D:\AIP\平行宇宙'
        eval(['load VLAT__',num2str(M)]);
        eval(['load VLON__',num2str(M)]);
        eval(['load NS__',num2str(M)]);
        eval(['load VZ__',num2str(M)]);
        eval(['load F107__',num2str(M)]);
        %
        eval(['VLAT__',num2str(M),' = VLAT_',num2str(M)]);
        eval(['VLON__',num2str(M),' = VLON_',num2str(M)]);
        eval(['VZ__',num2str(M),' = VZ_',num2str(M)]);
        eval(['F107__',num2str(M),' = F107_',num2str(M)]);
        eval(['NS__',num2str(M),' = NS_',num2str(M)]);
        
        %先對付極值(>5.5*10^3)
        eval(['NSPre = NS__',num2str(M)]);
        PL = length(NSPre);
            for PLL = 1:PL
                if NSPre(PLL) > 5.5*10^3
                    NSPre(PLL) = 5.5*10^3 ;
                end
            end
        % normalize to 0~1
        NSPre = rescale(NSPre);
        %
        cd 'D:\AIP\完整版6'
        %載入前段資料的檔案(訓練用)
        eval(['load VLAT_',num2str(M)]);
        eval(['load VLON_',num2str(M)]);
        eval(['load NS_',num2str(M)]);
        eval(['load VZ_',num2str(M)]);
        eval(['load F107_',num2str(M)]);
        %先對付極值(>5.5*10^3)
        eval(['NStem = NS_',num2str(M)]);
        L = length(NStem);
            for LL = 1:L
                if NStem(LL) > 5.5*10^3
                    NStem(LL) = 5.5*10^3 ;
                end
            end
        % normalize to 0~1
        NStem = rescale(NStem);
        %載入完做NS網格統計整理
        %先建容器 (每個月都會重置)
        CTNer1 = NaN(91,359,50); %裝訓練資料
        CTNer2 = NaN(91,359,50); %裝預測資料
        FLAT_Lat = NaN(91,359);
        FLAT_Lon = NaN(91,359);
        FLAT_LatPre = NaN(91,359);
        FLAT_LonPre = NaN(91,359);
        Size = length(NStem);
        SizeP = length(NSPre);
            %根據對應的經緯度填入資料(訓練資料集)
            for R1 = 1:Size
                eval(['R2 = VLAT_',num2str(M),'(R1);']);
                eval(['R3 = VLON_',num2str(M),'(R1);']);
                for line = 1:91
                    for column = 1:359
                        if R2 == line-46
                            if R3 == column-180
                                % data of NSTD mid in each gird
                                F = find_1st_NaN(CTNer1(line,column,:));
                                CTNer1(line,column,F) = NStem(R1);
                                % data of latitude in corresponding gird
                                FLAT_Lat(line,column) = line-46;
                                % data of longitude in corresponding gird
                                FLAT_Lon(line,column) = column-180;
                            end
                        end
                    end
                end
            end
            %(驗證資料集)
            for R4 = 1:SizeP
                eval(['R5 = VLAT__',num2str(M),'(R4);']);
                eval(['R6 = VLON__',num2str(M),'(R4);']);
                for line = 1:91
                    for column = 1:359
                        if R5 == line-46
                            if R6 == column-180
                                % data of NSTD mid in each gird
                                F = find_1st_NaN(CTNer1(line,column,:));
                                CTNer2(line,column,F) = NSPre(R4);
                                % data of latitude in corresponding gird
                                FLAT_LatPre(line,column) = line-46;
                                % data of longitude in corresponding gird
                                FLAT_LonPre(line,column) = column-180;
                            end
                        end
                    end
                end
            end
        NS_Mid = NaN(91,359);
        NS_MidPre = NaN(91,359);
            for line = 1:91
                for column = 1:359
                    NS_Mid(line,column) = median(CTNer1(line,column,:),'omitnan');
                    NS_MidPre(line,column) = median(CTNer2(line,column,:),'omitnan');
                end
            end
        NS_Mid = realdata(reshape(NS_Mid,[1,91*359]));
        FLAT_Lat = realdata(reshape(FLAT_Lat,[1,91*359]));
        FLAT_Lon = realdata(reshape(FLAT_Lon,[1,91*359]));
        NS_MidPre = realdata(reshape(NS_MidPre,[1,91*359]));
        FLAT_LatPre = realdata(reshape(FLAT_LatPre,[1,91*359]));
        FLAT_LonPre = realdata(reshape(FLAT_LonPre,[1,91*359]));
        %NS網格統計資料的中位數隨經緯分布的colorbar設定
        [NScarbon,ns] = sort(NS_Mid);
        LON1 = FLAT_Lon(ns);
        LAT1 = FLAT_Lat(ns);
        NNS = NS_Mid(ns);
        Ncmp = jet(numel(NNS));
        
        % 訓練資料集前處理
        % normalize
        eval(['VLAT = rescale(VLAT_',num2str(M),',-1,1);']);
        eval(['VLON = rescale(VLON_',num2str(M),',-1,1);']);
        %不歸一化但對垂直流速的值取log10
        eval(['VZ = VZ_',num2str(M),';']);
        for LL = 1:L
            VZ(LL) = log10(VZ(LL));
                if  isreal(VZ(LL))
                else
                    VZ(LL) = -real(VZ(LL));
                end
        end
        eval(['F107 = F107_',num2str(M),';']);
        %
        % 驗證資料集前處理
        % normalize
        eval(['VLATPre = rescale(VLAT__',num2str(M),',-1,1);']);
        eval(['VLONPre = rescale(VLON__',num2str(M),',-1,1);']);
        %不歸一化但對垂直流速的值取log10
        eval(['VZPre = VZ__',num2str(M),';']);
        for PLL = 1:PL
            VZPre(PLL) = log10(VZPre(PLL));
                if  isreal(VZPre(PLL))
                else
                    VZPre(PLL) = -real(VZPre(PLL));
                end
        end
        eval(['F107Pre = F107__',num2str(M),';']);
        %根據不同層數來訓練模型 (三個隱藏層+比較CC+繪圖)
        for HL1 = 2:20
            for HL2 = 2:20
                CTNer3 = NaN(91,359,50); %裝output資料
                %建立模型
                net = feedforwardnet([HL1,HL2]);
                %初始化權重&偏差
                net = init(net);
                %設定輸出範圍
                net.output.range = [0 1];
                %試試最後一層放對數雙曲轉移函數的效果
                net.layers{1}.transferFcn = 'logsig';
                %設定終止訓練的條件
                net.trainParam.lr = 0.00001;
                net.trainParam.max_fail = 6;
                %input = VLAT  VLON  VZ  F10.7
                input = [VLAT;VLON;VZ];
                %target = NS;
                target = NStem;
                % Delay為0的批次訓練
                net = train(net,input,target);
                %測量該月的資料長度為LLL
                eval(['LLL = length(NS_',num2str(M),')']);
                output = net(input(:,1:LLL));
                %view(net)
                    
                    for R1 = 1:Size
                        eval(['R2 = VLAT_',num2str(M),'(R1);']);
                        eval(['R3 = VLON_',num2str(M),'(R1);']);
                        for line = 1:91
                            for column = 1:359
                                if R2 == line-46
                                    if R3 == column-180
                                        % data of output in each gird
                                        F = find_1st_NaN(CTNer3(line,column,:));
                                        CTNer3(line,column,F) = output(R1);
                                    end
                                end
                            end
                        end
                    end
                OP_Mid = NaN(91,359);
                    for line = 1:91
                        for column = 1:359
                            OP_Mid(line,column) = median(CTNer3(line,column,:),'omitnan');
                        end
                    end
                OP_Mid = realdata(reshape(OP_Mid,[1,91*359]));
                %訓練結果 OP 隨經緯分布的colorbar設定
                [OPcarbon,op]=sort(OP_Mid);
                LON2 = FLAT_Lon(op);
                LAT2 = FLAT_Lat(op);
                OOP = output(op);
                opcmp=jet(numel(OOP));
                %
                %輸入後段資料查看預測成效
                Predict_input = [VLATPre;VLONPre;VZPre];
                Prediction = net(Predict_input(:,1:PL));
                CTNer4 = NaN(91,359,50); %裝預測資料(計算經緯度中位數)
                    for R4 = 1:PL
                        eval(['R5 = VLAT__',num2str(M),'(R4);']);
                        eval(['R6 = VLON__',num2str(M),'(R4);']);
                        for line = 1:91
                            for column = 1:359
                                if R5 == line-46
                                    if R6 == column-180
                                        % data of output in each gird
                                        F = find_1st_NaN(CTNer4(line,column,:));
                                        CTNer4(line,column,F) = Prediction(R4);
                                    end
                                end
                            end
                        end
                    end
                Predic_Mid = NaN(91,359);
                for line = 1:91
                    for column = 1:359
                        Predic_Mid(line,column) = median(CTNer4(line,column,:),'omitnan');
                    end
                end
                Predic_Mid = realdata(reshape(Predic_Mid,[1,91*359]));
            % 訓練成效畫圖(比對原始資料) 
            %figure(M)
            %subplot(2,1,1)
            %scatter3(LON1,LAT1,NNS,60,Ncmp,'.');
            %hold on 
            %load coast
            %plot(long, lat)
            %xlim([-180 180]);
            %ylim([-90 90]);
            %zlim([-500 30000]);
            %title('All Data Scattering')
            %colorbar
        
            %subplot(2,1,2)
            %scatter3(LON2,LAT2,OOP,60,opcmp,'.');
            %hold on
            %load coast
            %plot(long, lat)
            %xlim([-180 180]);
            %ylim([-90 90]);
            %zlim([-500 30000]); 
            %title('Training Data Scattering')
            %colorbar
            
            %計算correlation coefficients
            eval(['CORCOEF_',num2str(M),'_',num2str(HL1),' = corrcoef(NS_Mid,OP_Mid)']);
            eval(['CORCOEF2_',num2str(M),'_',num2str(HL1),' = corrcoef(NStem,output)']);
            eval(['CORCOEF3_',num2str(M),'_',num2str(HL1),' = corrcoef(NS_MidPre,Predic_Mid)']);
            eval(['CORCOEF4_',num2str(M),'_',num2str(HL1),' = corrcoef(NSPre,Prediction)']);

            
            eval(['C1 = CORCOEF_',num2str(M),'_',num2str(HL1),'(2,1)']);
            eval(['C2 = CORCOEF2_',num2str(M),'_',num2str(HL1),'(2,1)']);
            eval(['C3 = CORCOEF3_',num2str(M),'_',num2str(HL1),'(2,1)']);
            eval(['C4 = CORCOEF4_',num2str(M),'_',num2str(HL1),'(2,1)']);

            
            %Spearman's rank correalation coefficient
            [RC,RT,RP] = spear(NSPre',Prediction');
       
            %判斷門檻值決定是否儲存
                %if RC > 0.535
                    %save(['D:\\AIP\\完整版6\NetFinal\2層\\net_Month-',num2str(M),'_HL1-',num2str(HL1),'_HL2-',num2str(HL2),'_',num2str(C1),'_',num2str(C2),'_',num2str(C4),'_RC-',num2str(RC),'.mat'],'net')
                %elseif C1 > 0.73
                    %if C2 > 0.5
                       %演算法輸出：net_月份_一層Neural數_二層Neural數_中位數CC_全值CC_預測中位數CC_預測全值CC
                       %save(['D:\\AIP\\完整版6\Net\\net_',num2str(M),'_',num2str(HL1),'_',num2str(C1),'_',num2str(C2),'_',num2str(C3),'_',num2str(C4),'.mat'],'net')
                    %end
                %end
    %-----------------------------------------------------------
    %figure(M)
    %set(gca, 'FontSize', 18)
    %grid on
    %hold on
    %scatter3(HL1,HL2,C1,'K*')
    %xlabel('Neuron Number in Hidden Layer 1')
    %ylabel('Neuron Number in Hidden Layer 2')
    %zlabel('Correlation')
    %title('Correlation Coefficient of Median in Each Degree')
    %
    %------------------------------------------------------------------
    %figure(100*M)
    %set(gca, 'FontSize', 18)
    %grid on
    %hold on
    %plot(HL1,C4,'K*','MarkerSize',3)
    %plot(HL1,RC,'R.','MarkerSize',8)
    %xlabel('Size of Hidden Layer 1')
    %ylabel('Correlation')
    %title('. Predictive Correlation')
    %-----------------------------------------------------------
    figure(M)
    set(gca, 'FontSize', 18)
    grid on
    hold on
    scatter3(HL1,HL2,C4,15,'K*')
    scatter3(HL1,HL2,RC,50,'R.')
    xlabel('Neuron Number in Hidden Layer 1')
    ylabel('Neuron Number in Hidden Layer 2')
    zlabel('Correlation')
    title('. Predictive Correlation')
    %----------------------------------------------------------
    %
    %figure(M)
    %set(gca, 'FontSize', 18)
    %grid on
    %hold on
    %plot(HL1,C4,'K*')
    %hold on
    %plot(HL1,RC,'R.')
    %xlabel('Size of Hidden Layer 1')
    %ylabel('Correlation')
    %xlim([2 20])
    %ylim([0.02 0.54])
    %zlabel('Correlation')
    %title('Prediction (Rank) Correlation Coefficient of Each Data Point')  
    %
    %figure(M*10)
    %set(gca, 'FontSize', 18)
    %grid on
    %hold on
    %plot(HL1,RT,'G*')
    %hold on
    
    %plot(HL1,RP,'K.')
    %xlabel('Size of Hidden Layer 1')
    %title('Corresponding P-Value and T-Ratio of Rank Correalation Coefficient')
    %
    %figure(992)
    %set(gca, 'FontSize', 18)
    %grid on
    %hold on
    %scatter3(C4,RC,C3,0.1,'R.')
    %xlabel('Pearson Correlation')
    %ylabel('Spearman Rank Correlation')
    %zlabel('Median Correlation')
    %title('Prediction (Rank) Correlation Coefficient of Each Data Point') 
    
    %if RC > 0.51
        %if C4 > 0.455
            %if C5 > 0.55
                %figure(HL1)
                %set(gca, 'FontSize', 18)
                %grid on
                %plot(NSPre,Prediction,'.')
                %xlabel('Input Data')
                %ylabel('Prediction')
                %xlim([0 1])
                %ylim([0 1])
            %end
        %end
    %end
    
            end
        end
    end
    continue
end
    