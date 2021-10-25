function OPTICALexperiment(processed_dir, experiment_name, channels)

data_processed_dir = processed_dir;%'../../data/processed/';
filePattern = fullfile(data_processed_dir, '*.mat');
data_processed_dir = dir(filePattern);

varTypes = cell(1, 14);
varTypes(:) = {'double'};

varNames = ["train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

T = table('Size', [52 14], 'VariableTypes', varTypes, 'VariableNames', varNames);

idx_channels = channels;

for k = 1 : length(data_processed_dir)
    
    fullFileName = fullfile(data_processed_dir(k).folder, data_processed_dir(k).name);
    load(fullFileName);
    
    if(~isequal(channels, [1:64]))
        mi = mi(idx_channels, :, :);
        real = real(idx_channels, :, :);
    end
    
    [~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train, info] = ...
               OPTICAL(mi,real,class_mi, class_real, 256, 20);
    
    T(k, :) = {train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train};
    
    models_dir_cat = strcat('../../models/', experiment_name);
           
    if ~exist(models_dir_cat', 'dir')
        mkdir(models_dir_cat)
    end
    
    models_dir =  dir(models_dir_cat);
    
    fullFileName = fullfile(models_dir(1).folder, data_processed_dir(k).name);
    
    save(fullFileName, 'lstmNnet', 'svmCLF', 'info');
    
end

if ~exist('../../summary/', 'dir')
    mkdir ../../summary/
end

T = fillmissing(T, 'constant', 0);

summaryFullFileName = strcat('../../summary/', experiment_name, '.csv');

writetable(T, summaryFullFileName);