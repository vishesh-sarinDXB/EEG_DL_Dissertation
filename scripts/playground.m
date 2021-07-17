load('../data/processed/s51.mat')
addpath('./optical/');


    [predicted_class, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
               Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
               F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
               Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
               OPTICAL(mi,real,class_mi, class_real, 50, 20);