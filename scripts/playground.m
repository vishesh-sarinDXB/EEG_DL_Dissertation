load('../data/processed/s06.mat')
addpath('./optical')

[predicted_class, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
               OPTICAL(mi,real,class_mi, class_real, 50, 20);
           
       

% standardizeMissing(allchannelsfrequencies, {nan, 0})
% 
% var1 = [1, 2, 3, nan]';
% 
% var2 = [3, 4, 5, 6]';
% 
% var3 = [2, 3, nan, 2]';
% 
% T = table(var1, var2, var3)
% 
% T = fillmissing(T, 'constant', 0)