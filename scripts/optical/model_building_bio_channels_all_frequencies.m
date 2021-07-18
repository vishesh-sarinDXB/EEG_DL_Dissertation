data_processed_dir = '../../data/processed/';
filePattern = fullfile(data_processed_dir, '*.mat');
data_processed_dir = dir(filePattern);

varTypes = cell(1, 14);
varTypes(:) = {'double'};

varNames = ["train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

T = table('Size', [52 14], 'VariableTypes', varTypes, 'VariableNames', varNames);

% Only using channels that aren't related to occipital, temporal, or
% parietal lobes. Allowing channels that are in between one of these and
% other lobes.
idx_bio_channels = [1:14, 17:19, 32:51, 54:56];

for k = 1 : length(data_processed_dir)
    
    fullFileName = fullfile(data_processed_dir(k).folder, data_processed_dir(k).name);
    load(fullFileName);
    
    mi = mi(idx_bio_channels, :, :);
    real = real(idx_bio_channels, :, :);
    
    [predicted_class, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
               OPTICAL(mi,real,class_mi, class_real, 50, 20);
    
    T(k, :) = {train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train};
    
    if ~exist('../../models/bio_channels_frequencies/', 'dir')
        mkdir ../../models/bio_channels_frequencies/
    end
    
    models_dir =  dir('../../models/bio_channels_frequencies/');
    
    fullFileName = fullfile(models_dir(1).folder, data_processed_dir(k).name);
    
    save(fullFileName, 'lstmNnet', 'svmCLF');
    
end

if ~exist('../../summary/', 'dir')
    mkdir ../../summary/
end

T = fillmissing(T, 'constant', 0);

writetable(T, '../../summary/bio_channels_frequencies.csv');