function [error] = fitnessFunctionLSTM_par(particle,Training_data,Target_Training)

%disp(particle')
Fs = 512/2;
WindowSize = size(Training_data,2);

order = round(particle(3));
if order < 0.5
    order = order + 1;
end

[AA,BB] = butter(order,[particle(1),particle(2)]/(Fs/2));
% d1=fdesign.decimator(1,'bandpass','fst1,fp1,fp2,fst2,ast1,ap,ast2',particle(2)- particle(1),particle(2),particle(3),particle(3) + particle(4),70,5,70,100); % s2 best
% Hd1 = design(d1,'equiripple');
% disp('filtered')

%Train_data = zeros(size(Training_data));
% length(Target_Training)
parfor i=1:length(Target_Training)
    temp = filter(AA,BB,Training_data(:,:,i)')';
%     sum(sum(isnan(temp)))
    temp(isnan(temp))= 1E-3;
%     Training_data(:,:,i) = filter(AA,BB,Training_data(:,:,i)')';
    Training_data(:,:,i) = temp;
end
% disp('filtered 2')
% Training_data(:,:,sum(sum(isnan(Training_data)))>0) = 1E-6;
% Training_data(:,:,sum(sum(isinf(Training_data)))>0) = 1E-6;

Training_data = Training_data(:,:,sum(sum(isnan(Training_data)))==0);
Target_Training = Target_Training(sum(sum(isnan(Training_data)))==0);
TL = length(Target_Training);
TD = size(Training_data);
if TL==0
    error = 100;
    return;
end
% a = sum(sum(sum(isinf(Training_data))))
% Training_data = Training_data(:,:,sum(sum(isinf(Training_data)))==0);

kf = 5;
index = crossvalind('Kfold',Target_Training,kf);
WS = 128;
OL = 24;
Nwpt = (WindowSize-WS)/OL;

parfor num = 1:kf  
    %num
    test = (index == num); 
    test_indices = find(test == 1);
    train = ~test;
    train_indices = find(train == 1);
    
    Train_data{num} = Training_data(:,:,train_indices);
    Test_data{num} = Training_data(:,:,test_indices);
    Target_Train{num} = Target_Training(train_indices);
    Target_Test{num} = Target_Training(test_indices);

    for i = 1:length(Target_Train{num})
        for j = 1:Nwpt
            Train_data1{num}(:,:,(i-1)*Nwpt+j) = Train_data{num}(:,(j-1)*OL+1:(j-1)*OL+WS,i);
            Target_Train1{num}((i-1)*Nwpt+j) = Target_Train{num}(i);
        end
    end

    for i = 1:length(Target_Test{num})
        for j = 1:Nwpt
            Test_data1{num}(:,:,(i-1)*Nwpt+j) = Test_data{num}(:,(j-1)*OL+1:(j-1)*OL+WS,i);
            Target_Test1{num}((i-1)*Nwpt+j) = Target_Test{num}(i);
        end
    end
end
   
parfor num = 1:kf
%     clear Z
%     clear Z1
% disp('W1')
    [Z, Wcsp{num}] = CSP(Train_data1{num},Target_Train1{num}',3);
    [Z1, Wcsp1{num}] = CSP(Train_data{num},Target_Train{num}',3);
% disp('W2')
%     clear F
%     clear F1

    for i = 1:1:size(Z,3)
        var1 = var(Z(:,:,i)');
        F{num}(i,:) = log(var1);%./log(sum(var1));
    end

    for i = 1:1:size(Z1,3)
        var1 = var(Z1(:,:,i)');
        F1{num}(i,:) = log(var1./sum(var1));
    end
end
clear Z
clear Z1
% disp('W3')
%     clear Z_Test
%     clear Z1_Test
%     clear F_Test
%     clear F1_Test
for num = 1:kf
    for i = 1:1:size(Target_Test1{num},2)
        Z_Test{num}(:,:,i) = Wcsp{num}*Test_data1{num}(:,:,i); % Z - csp transformed data
        var1 = var(Z_Test{num}(:,:,i)');
        F_Test{num}(i,:) = log(var1);   
    end

    for i = 1:1:length(Target_Test{num})
        Z1_Test{num}(:,:,i) = Wcsp1{num}*real(Test_data{num}(:,:,i)); % Z - csp transformed data
        var1 = var(Z1_Test{num}(:,:,i)');
        F1_Test{num}(i,:) = log(var1./sum(var1));
    end
    
	clear Z_Test
    clear Z1_Test

    F{num}(isnan(F{num})) = 1E-3;
    F1{num}(isnan(F1{num})) = 1E-3;
    F_Test{num}(isnan(F_Test{num})) = 1E-3;
    F1_Test{num}(isnan(F1_Test{num})) = 1E-3;

    [y2{num}, Wlda2{num}] = LDA(F1{num},Target_Train{num}',2);
    y2_Test{num} = Wlda2{num}'*F1_Test{num}';

    for i = 1:length(Target_Train{num})
        FF_Train{num}{i,1} = F{num}((i-1)*Nwpt+1:i*Nwpt,:)';
    end

    for i = 1:length(Target_Test{num})
        FF_Test{num}{i,1} = F_Test{num}((i-1)*Nwpt+1:i*Nwpt,:)';
    end
end
len = size(F{num},2);
clear Wlda
clear Wcsp
clear Wcsp1
clear F
clear F1
clear F_Test
clear F1_Test

% disp('W4')
parfor num = 1:kf

    inputSize = len;
    numHiddenUnits = 100;
    numClasses = 2;
    maxEpochs = 100;
    miniBatchSize = 18;

    layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
%         lstmLayer(18,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
% 
    options = trainingOptions('sgdm', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',0);


    numResponses = 1;
    layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    lstmLayer(18,'OutputMode','last')
    fullyConnectedLayer(numResponses)
    regressionLayer];
    
%     disp('W5')
    net = trainNetwork(FF_Train{num},Target_Train{num}',layers,options);
%     disp('W6')
    
    p1 = predict(net,FF_Train{num},'MiniBatchSize',miniBatchSize);
%     sum(sum(isnan([p1 y2{num}])))
    MODEL=fitcsvm([p1 y2{num}],Target_Train{num}','Solver','L1QP');
    p2 = predict(net,FF_Test{num},'MiniBatchSize',1);
    yfit = predict(MODEL,[p2 y2_Test{num}']);
    Acc(num) = mean(yfit == Target_Test{num}')*100 ;
%     disp('W7')
	
end
clear net
clear p1
clear MODEL
clear p2
clear var1
clear FF_Test
clear FF_Train
clear y2
clear y2_Test

error = 100 - mean(Acc);
