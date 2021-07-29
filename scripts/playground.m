fs = 5000;                     

t = 0:1/fs:0.1;                 
f1 = 10;                       
f2 = 50;

sin1 = sin(2*pi*f1*t);       
sin2 = sin(2*pi*f2*t);

x1 = [sin1 sin2 sin1 sin2];    
x2 = [sin2 sin1 sin2 sin1];

n_channels = 64;

eeg_1 = ones(length(x1),n_channels);       
eeg_2 = ones(length(x1),n_channels);

eeg_1 = eeg_1.*x1';
eeg_2 = eeg_2.*x2';

eeg_1 = eeg_1./([1:32 32:-1:1]).^2; 
eeg_2 = eeg_2./([1:32 32:-1:1]).^2; 

n_trials = 100;
n_channels = 64;
n_coeff = 256;
n_time = length(t);

X1 = zeros(n_trials, n_time, n_coeff, n_channels);
X2 = zeros(n_trials, n_time, n_coeff, n_channels);

for i = 1:n_trials
    for chan = 1:n_channels
        
        temp_1 = eeg_1(:,chan);
        temp_2 = eeg_2(:,chan);
        
        [s1, w1, t1] = spectrogram(temp_1,100,0,[],fs,'yaxis','centered');
        [s2, w2, t2] = spectrogram(temp_2,100,0,[],fs,'yaxis','centered');
        
        X1(i,:,:,chan) = abs(s1)' + rand([n_time, n_coeff]);
        X2(i,:,:,chan) = abs(s2)' + rand([n_time, n_coeff]);

    end
end

X = [X1; X2];
y = [zeros(100,1); ones(100,1)];



% load('../data/processed/sevenThirty/s08.mat') % load the actual class of the sample data
% addpath('./optical')
% 
% % [~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
% %                Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
% %                F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
% %                Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
% %                OPTICAL(mi,real,class_mi, class_real, 50, 20);
% % 
% % 
% 
% 
% ind = crossvalind('Kfold', class_mi, 10); % generate indices to divide 
% 
% varTypes = cell(1, 14);
% varTypes(:) = {'double'};
% 
% varNames = ["train_accuracy", "test_accuracy", ...
%                "Precision_class1", "Precision_class2", "Recall_class1", "Recall_class2", ...
%                "F1_class1", "F1_class2", "Precision_class1_train", "Precision_class2_train", ...
%                "Recall_class1_train", "Recall_class2_train", "F1_class1_train", "F1_class2_train"];
% 
% T = table('Size', [10 14], 'VariableTypes', varTypes, 'VariableNames', varNames);
% % 
% lstm = cell(10);
% svm = cell(10);
% % lstm = [];
% % svm = [];
% 
% for fold = 1 : 10
%     
%     test = (ind == fold); 
%     test_ind = find(test == 1);
%     train = ~test;
%     train_ind = find(train == 1);
%     
%     Train_data = mi(:,:,train_ind);
%     Target_Train = class_mi(train_ind);
%     Test_data = mi(:,:,test_ind);
%     Target_Test = class_mi(test_ind);
%     
%     [FF_Test, y2_Test, ~, lstmNnet, svmCLF, train_accuracy, test_accuracy, ...
%                Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
%                F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
%                Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train] = ...
%                OPTICAL(Train_data,Test_data,Target_Train, Target_Test, 50, 20);
% 
%     T(fold, :) = {train_accuracy, test_accuracy, ...
%                Precision_class1, Precision_class2, Recall_class1, Recall_class2, ...
%                F1_class1, F1_class2, Precision_class1_train, Precision_class2_train, ...
%                Recall_class1_train, Recall_class2_train, F1_class1_train, F1_class2_train};
%            
%     lstm{fold} = lstmNnet;
%     svm{fold} = svmCLF;
% end
% 
