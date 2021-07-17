data_processed_dir = '../../data/processed/';
filePattern = fullfile(data_processed_dir, '*.mat');
data_processed_dir = dir(filePattern);

% if ~exist('../data/processed/', 'dir')
%     mkdir ../data/processed/
% end

% data_processed_dir = dir('../../data/processed/');

varTypes = cell(1, 15);
varTypes(:) = {'double'};

varNames = ["predicted_class", "train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

T = table('Size', [52 15], 'VariableTypes', varTypes, 'VariableNames', varNames);

for k = 1 : length(data_processed_dir)
    
    fullFileName = fullfile(data_processed_dir(k).folder, data_processed_dir(k).name);
    load(fullFileName);
    
    [predicted_class, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
               OPTICAL(mi,real,class_mi, class_real, 50, 20);
    
    T(k, :) = {predicted_class, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train};
    
    if ~exist('../../models/all_channels_frequencies/', 'dir')
        mkdir ../../models/all_channels_frequencies/
    end
    
    models_dir =  dir('../../models/all_channels_frequencies/');
    
    fullFileName = fullfile(models_dir(1).folder, data_dir(k).name);
    
    save(fullFileName, 'lstmNnet', 'svmCLF');
    
end

if ~exist('../../summary/', 'dir')
    mkdir ../../summary/
end

writetable(T, '../../summary/all_channels_frequencies.csv');

% 
% load('../../data/processed/s01.mat') % load sample data
% % load('class_mi') % load the actual class of the sample data
% ind = crossvalind('Kfold',class_mi,10); % generate indices to divide 
% % % sample data into train and test data
% % 
% % % Select 1st set as test data and remaining sets as test data
% num = 1; 
% % 
% test = (ind == num); 
% test_ind = find(test == 1);
% train = ~test;
% train_ind = find(train == 1);
% % 
% Train_data = mi(:,:,train_ind);
% Target_Train = class_mi(train_ind);
% Test_data = mi(:,:,test_ind);
% Target_Test = class_mi(test_ind);

% predicted_class = OPTICAL(mi,real,class_mi, class_real, 50, 20);


% predicted_class = OPTICAL(mi,real,class_mi, class_real, 50, 20);