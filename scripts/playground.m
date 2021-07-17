% cD = cell(1, 3);
% cD(:) = {'double'};
% 
% T = table('Size', [52 14], 'VariableTypes', cD);
% 
% nums = {1, 2, 3};
% 
% T(1, :) = nums
% 
% if ~exist('../summary/processed/', 'dir')
%     mkdir ../summary/processed/
% end 

data_processed_dir = '../data/processed/';
filePattern = fullfile(data_processed_dir, '*.mat');
data_processed_dir = dir(filePattern);

% if ~exist('../data/processed/', 'dir')
%     mkdir ../data/processed/
% end

data_processed_dir = dir('../data/processed/');

varTypes = cell(1, 15);
varTypes(:) = {'double'};

varNames = ["predicted_class", "train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

T = table('Size', [52 15], 'VariableTypes', varTypes, 'VariableNames', varNames);

for k = 1 : length(data_processed_dir)
    
    fullFileName = fullfile(data_processed_dir(k).folder, data_processed_dir(k).name);
    disp(fullFileName);
    
end