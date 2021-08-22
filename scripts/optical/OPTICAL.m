function [predicted_class, lstmNnet, ... 
                   svmCLF, train_accuracy, test_accuracy, ...
                   Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
                   F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
                   Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
                             OPTICAL(train_data, ...
                                     test_data, ...
                                     class_train, ...
                                     class_test, ...
                                     window_size, ...
                                     percentage_overlap, ...
                                     varargin)
%%
% The code can be used for research purpose only. Any work resulting from 
% the use of this code should cite our original paper "Brain wave 
% classification using long short-term memory network based OPTICAL 
% predictor" published in Scientific Reports in June, 2019

%**************************************************************************
%  The OPTICAL predictor
%**************************************************************************
%   train_data: consists of the filtered samples (trials) of size ch x t x n
%   where ch is the number of channels data, t is the number of sample
%   points and n is the number of samples (trials)
%   test_data: same size as train_data with different number of trials
%   class_train and class_test contain the actual target class for train
%   and test data
%   window_size: size of the window for applying sliding window to obtain 
%   feature matrix for the LSTM network as mentioned in the paper
%   percentage_overlap: is the amount of overlap of window_size in percentage 
%   optional (varargin): optionally, the initial_learn_rate_range and
%   L2_regularization_range can be specified

if nargin==1
    initial_learn_rate_range = varargin(1);
elseif nargin == 2
    initial_learn_rate_range = varargin(1);
    L2_regularization_range = varargin(2);
else % set default range
    initial_learn_rate_range = [1e-3 1e-1]; 
    L2_regularization_range = [1e-5 1e-3];
end

% optimVars = [
% optimizableVariable('InitialLearnRate',initial_learn_rate_range,'Transform','log')
% optimizableVariable('L2Regularization',L2_regularization_range,'Transform','log')
% ];    
        
original_window_size = size(train_data,2);
overlap = round(percentage_overlap/100*window_size);
number_of_windows = floor((original_window_size - window_size)/overlap);

for i = 1:length(class_train)
    for j = 1:number_of_windows
        Train_data1(:,:,(i-1)*number_of_windows+j) = train_data(:,(j-1)*overlap+1:(j-1)*overlap+window_size,i);
        Target_Train1((i-1)*number_of_windows+j) = class_train(i);
    end
end

for i = 1:length(class_test)
    for j = 1:number_of_windows
        Test_data1(:,:,(i-1)*number_of_windows+j) = test_data(:,(j-1)*overlap+1:(j-1)*overlap+window_size,i);
        Target_Test1((i-1)*number_of_windows+j) = class_test(i);
    end
end

[Z, Wcsp] = CSP(Train_data1,Target_Train1',3);
[Z1, Wcsp1] = CSP(train_data,class_train',3);

clear F
clear F1

for i = 1:1:size(Z,3)
    var1 = var(Z(:,:,i)');
    F(i,:) = log(var1);%./log(sum(var1));
end

for i = 1:1:size(Z1,3)
    var1 = var(Z1(:,:,i)');
    F1(i,:) = log(var1./sum(var1));
end

clear Z_Test
clear Z1_Test
clear F_Test
clear F1_Test

for i = 1:1:size(Target_Test1,2)
    Z_Test(:,:,i) = Wcsp*Test_data1(:,:,i); % Z - csp transformed data
    var1 = var(Z_Test(:,:,i)');
    F_Test(i,:) = log(var1);   
end

for i = 1:1:length(class_test)
    Z1_Test(:,:,i) = Wcsp1*real(test_data(:,:,i)); % Z - csp transformed data
    var1 = var(Z1_Test(:,:,i)');
    F1_Test(i,:) = log(var1./sum(var1));
end

F(isnan(F)) = 1E-3;
F1(isnan(F1)) = 1E-3;

[y2, Wlda2] = LDA(F1,class_train',2);
y2_Test = Wlda2'*F1_Test';

for i = 1:length(class_train)
    FF_Train{i,1} = F((i-1)*number_of_windows+1:i*number_of_windows,:)';
end

for i = 1:length(class_test)
    FF_Test{i,1} = F_Test((i-1)*number_of_windows+1:i*number_of_windows,:)';
end

% fun = @(x)valErrorFun(x, FF_Train, class_train);

% results = bayesopt(fun,optimVars,...
% 'IsObjectiveDeterministic',true,...
% 'MaxObj',25,...
% ...% 'MinWorkerUtilization', 7,... %might need to comment out
% 'MaxTime',5*60,...
% 'UseParallel',true);
close all

inputSize = size(F,2);
% This following parameters can be changed to your own network size, 
% however, the same needs to be done in valErrorFun as these parameters 
% needs to be same
numHiddenUnits1 = 100; 
numHiddenUnits2 = 20; 
maxEpochs = 200;
[~, ~, MiniBatchSize] = size(train_data);
        
numResponses = 1;
layers = [ ...
sequenceInputLayer(inputSize)
lstmLayer(numHiddenUnits1,'OutputMode','sequence')
lstmLayer(numHiddenUnits2,'OutputMode','last')
fullyConnectedLayer(numResponses)
regressionLayer];

options = trainingOptions('sgdm', ...
'ExecutionEnvironment','cpu', ...
'LearnRateSchedule','piecewise',...
...% 'InitialLearnRate',results.XAtMinObjective.InitialLearnRate ,...
...% 'L2Regularization',results.XAtMinObjective.L2Regularization,...
'MaxEpochs',maxEpochs, ...
'MiniBatchSize',MiniBatchSize, ...
...% 'Shuffle', 'every-epoch', ...
'GradientThreshold',1, ...
'Verbose',0);

lstmNnet = trainNetwork(FF_Train,class_train',layers,options);

y2 = real(y2);
y2_Test = real(y2_Test);

p1 = predict(lstmNnet,FF_Train,'MiniBatchSize',1);
svmCLF=fitcsvm([p1 y2],class_train','Solver','L1QP');
predicted_class_train = predict(svmCLF,[p1 y2]);
predicted_class_train = predicted_class_train';

p2 = predict(lstmNnet,FF_Test,'MiniBatchSize',1);
predicted_class = predict(svmCLF,[p2 y2_Test']);
predicted_class = predicted_class';

% save('net.mat', 'net');

TP_class1 = sum((predicted_class == 1) & (class_test == 1));
TP_class2 = sum((predicted_class == 2) & (class_test == 2));

TN_class1 = TP_class2;
TN_class2 = TP_class1;

FP_class1 = sum(predicted_class == 1) - TP_class1;
FP_class2 = sum(predicted_class == 2) - TP_class2;

FN_class1 = sum(class_test == 1 & predicted_class ~= 1);
FN_class2 = sum(class_test == 2 & predicted_class ~= 2);

Precision_class1 = ((TP_class1) / (TP_class1 + FP_class1));
Precision_class2 = ((TP_class2) / (TP_class2 + FP_class2));

Recall_class1 = ((TP_class1) / (TP_class1 + FN_class1));
Recall_class2 = ((TP_class2) / (TP_class2 + FN_class2));

F1_class1 = 2*((Precision_class1 * Recall_class1)/(Precision_class1 + Recall_class1));
F1_class2 = 2*((Precision_class2 * Recall_class2)/(Precision_class2 + Recall_class2));

%train

TP_class1_train = sum((predicted_class_train == 1) & (class_train == 1));
TP_class2_train = sum((predicted_class_train == 2) & (class_train == 2));

%         TN_class1 = TP_class2;
%         TN_class2 = TP_class1;

FP_class1_train = sum(predicted_class_train == 1) - TP_class1_train;
FP_class2_train = sum(predicted_class_train == 2) - TP_class2_train;

FN_class1_train = sum(class_train == 1 & predicted_class_train ~= 1);
FN_class2_train = sum(class_train == 2 & predicted_class_train ~= 2);

Precision_class1_train = ((TP_class1_train) / (TP_class1_train + FP_class1_train));
Precision_class2_train = ((TP_class2_train) / (TP_class2_train + FP_class2_train));

Recall_class1_train = ((TP_class1_train) / (TP_class1_train + FN_class1_train));
Recall_class2_train = ((TP_class2_train) / (TP_class2_train + FN_class2_train));

F1_class1_train = 2*((Precision_class1_train * Recall_class1_train)/(Precision_class1_train + Recall_class1_train));
F1_class2_train = 2*((Precision_class2_train * Recall_class2_train)/(Precision_class2_train + Recall_class2_train));

% Precision_class1, Precision_class2, Recall_class1, Recall_class2,
% F1_class1, F1_class2, Precision_class1_train, Precision_class2_train,
% Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train

MC_class1 = (FP_class1 + FN_class1) / (TP_class1 + TN_class1 + FP_class1 + FN_class1);
L = loss(svmCLF, [p1 y2], class_train);

train_accuracy = mean(class_train == predicted_class_train);
test_accuracy = mean(class_test == predicted_class);
fprintf('Accuracy on train data is %5.2f%%',train_accuracy)
fprintf('\nAccuracy on test data is %5.2f%%',test_accuracy)
fprintf('\nMC on test data is %5.2f%%',MC_class1)
fprintf('\nloss on train data is %5.2f%%',L)
fprintf('\n')
