function OPTICALexperimentCV(processed_dir, experiment_name, channels)

data_processed_dir = processed_dir;%'../../data/processed/';
filePattern = fullfile(data_processed_dir, '*.mat');
data_processed_dir = dir(filePattern);

varTypes = cell(1, 14);
varTypes(:) = {'double'};

varNames = ["train_accuracy", "test_accuracy", ...
               "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
               "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
               "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];

idx_channels = channels;

for k = 1 : length(data_processed_dir)
    
    fullFileName = fullfile(data_processed_dir(k).folder, data_processed_dir(k).name);
    load(fullFileName);
    
    if(~isequal(channels, [1:64]))
        mi = mi(idx_channels, :, :);
        real = real(idx_channels, :, :);
    end
    
    ind = crossvalind('Kfold', class_mi, 10);     

    T = table('Size', [10 14], 'VariableTypes', varTypes, 'VariableNames', varNames);
    
    lstm = cell(10);
    svm = cell(10);
    
    class_mi = class_mi - 1;
    
    vec = 1:length(class_mi);
    vec = vec(randperm(length(vec)));
    
    class_mi = class_mi(vec);
    mi = mi(:, :, vec);
    
    for fold = 1 : 10

        test = (ind == fold); 
        test_ind = find(test == 1);
        train = ~test;
        train_ind = find(train == 1);

        Train_data = mi(:,:,train_ind);
        Target_Train = class_mi(train_ind);
        Test_data = mi(:,:,test_ind);
        Target_Test = class_mi(test_ind);

        [~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
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
    
    models_dir_cat = strcat('../../models/mi_cv/', experiment_name);
           
    if ~exist(models_dir_cat', 'dir')
        mkdir(models_dir_cat)
    end
    
    models_dir =  dir(models_dir_cat);
    
    fullFileName = fullfile(models_dir(1).folder, data_processed_dir(k).name);
    
    save(fullFileName, 'lstm', 'svm', 'ind');
    
    summary_dir_cat = strcat('../../summary/mi_cv/', experiment_name, '/');
    
    if ~exist(summary_dir_cat, 'dir')
        mkdir(summary_dir_cat)
    end

    T = fillmissing(T, 'constant', 0);

    summaryFullFileName = strcat(summary_dir_cat, data_processed_dir(k).name, '.csv');

    writetable(T, summaryFullFileName);
    
end