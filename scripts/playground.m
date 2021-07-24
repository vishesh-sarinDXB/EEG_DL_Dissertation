load('../data/processed/sevenThirty/s08.mat') % load the actual class of the sample data
addpath('./optical')

% [~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
%                Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
%                F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
%                Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
%                OPTICAL(mi,real,class_mi, class_real, 50, 20);
% 
% 


ind = crossvalind('Kfold', class_mi, 10); % generate indices to divide 

varTypes = cell(1, 14);
varTypes(:) = {'double'};

varNames = ["train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

T = table('Size', [10 14], 'VariableTypes', varTypes, 'VariableNames', varNames);
% 
lstm = cell(10);
svm = cell(10);
% lstm = [];
% svm = [];

for fold = 1 : 10
    
    test = (ind == fold); 
    test_ind = find(test == 1);
    train = ~test;
    train_ind = find(train == 1);
    
    Train_data = mi(:,:,train_ind);
    Target_Train = class_mi(train_ind);
    Test_data = mi(:,:,test_ind);
    Target_Test = class_mi(test_ind);
    
    [FF_Test, y2_Test, ~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
               OPTICAL(Train_data,Test_data,Target_Train, Target_Test, 50, 20);

    T(fold, :) = {train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train};
           
    lstm{fold} = lstmNnet;
    svm{fold} = svmCLF;
end

