function [valError,cons,fileName] = valErrorFun(x, data, Target)
    ind_x = crossvalind('Kfold',Target,5);
    for num = 1:5
        FF_Train = data(ind_x~=num,:);
        Target_Train = Target(ind_x~=num);
        FF_Test = data(ind_x==num,:);
        Target_Test = Target(ind_x==num);

        inputSize = size(FF_Train{1},1)
        numHiddenUnits1 = 100;
        numHiddenUnits2 = 20; 
        maxEpochs = 100;
        MiniBatchSize = 20;

        options = trainingOptions('sgdm', ...
        'ExecutionEnvironment','cpu', ...
        'LearnRateSchedule','piecewise',...
        'InitialLearnRate',x.InitialLearnRate,...
        'L2Regularization',x.L2Regularization,...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',MiniBatchSize, ...
        'GradientThreshold',1, ...
        'Verbose',0);

        numResponses = 1;
        layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits1,'OutputMode','sequence')
        lstmLayer(numHiddenUnits2,'OutputMode','last')
        fullyConnectedLayer(numResponses)
        regressionLayer];%change this last layer to get probabilities perhaps? So ROC is feasible

        net = trainNetwork(FF_Train,Target_Train',layers,options);
        p11 = predict(net,FF_Train,'MiniBatchSize',MiniBatchSize);
        p1 = double(p11);
        p22 = predict(net,FF_Test,'MiniBatchSize',1);
        p2 = double(p22);
        
        model = fitcsvm(p1,Target_Train','Solver','L1QP');
        pred = predict(model,p2);
        Error(num) = 1 - mean(pred == Target_Test');
        
        TP_class1 = sum((pred == 1) & (Target_test == 1));
        TP_class2 = sum((pred == 2) & (Target_test == 2));
        
%         TN_class1 = TP_class2;
%         TN_class2 = TP_class1;
        
        FP_class1 = sum(pred == 1) - TP_class1;
        FP_class2 = sum(pred == 2) - TP_class2;
        
        FN_class1 = sum(Target_test == 2 & ~pred == 2);
        FN_class2 = sum(Target_test == 1 & ~pred == 1);
        
        Precision_class1(num) = 1 - ((TP_class1) / (TP_class1 + FP_class1));
        Precision_class2(num) = 1 - ((TP_class2) / (TP_class2 + FP_class2));
        
        Recall_class1(num) = 1 - ((TP_class1) / (TP_class1 + FN_class1));
        Recall_class2(num) = 1 - ((TP_class2) / (TP_class2 + FN_class2));
        
        F1_class1(num) = 2*((Precision_class1 * Recall_class1)/(Precision_class1 + Recall_class1));
        F1_class2(num) = 2*((Precision_class2 * Recall_class2)/(Precision_class2 + Recall_class2));
        
        pred = pred - 1;
        Target_test = Target_test - 1;
        
        
        
    end
    
    valError = mean(Error);
end
