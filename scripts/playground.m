% load('../data/processed/s06.mat')
% addpath('./optical')
% 
% [predicted_class, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
%                Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
%                F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
%                Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
%                OPTICAL(mi,real,class_mi, class_real, 50, 20);
%            

% if (~isequal([1:64], [1:63]))
%     disp('Testing')
% end

dir_var = 'somedir3///';
dir_var = strcat('./somedir1/', dir_var);
% 
mkdir(dir_var)
% 
% function playground()
% disp('testing')



% 
% if ~exist('./somedir/somedir2/', 'dir')
%     mkdir ./somedir/somedir2/
% end
% 
% if ~exist('./somedir/somedir3/', 'dir')
%     mkdir ./somedir/somedir3/
% end

% data_processed_dir = dir('../../data/processed/');

% idx = [1:14, 17:19, 32:51, 54:56];
% 
% idx2 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 18 19 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 54 55 56]
% 
% test = mi(idx, :, :);
% test2 = mi(1:40, :, :);
% test3 = mi(idx2, :, :);
% 
% tf1 = isequal(test, test2)
% 
% tf2 = isequal(test, test3)


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