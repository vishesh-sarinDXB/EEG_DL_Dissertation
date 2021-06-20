load('../../data/processed/s01.mat') % load sample data
% load('class_mi') % load the actual class of the sample data
ind = crossvalind('Kfold',class_mi,10); % generate indices to divide 
% % sample data into train and test data
% 
% % Select 1st set as test data and remaining sets as test data
num = 1; 
% 
test = (ind == num); 
test_ind = find(test == 1);
train = ~test;
train_ind = find(train == 1);
% 
Train_data = mi(:,:,train_ind);
Target_Train = class_mi(train_ind);
Test_data = mi(:,:,test_ind);
Target_Test = class_mi(test_ind);

predicted_class = OPTICAL(Train_data,Test_data,Target_Train, Target_Test, 50, 20);


% predicted_class = OPTICAL(mi,real,class_mi, class_real, 50, 20);