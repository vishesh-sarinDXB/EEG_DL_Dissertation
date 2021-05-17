% Example code
close all
clear 
clc

load('train_data')
load('class_train')
load('test_data')
load('class_test')
Fs = 256;
WindowSize = 2*Fs;
r = 3;

pred_label = OPTICAL_plus(train_data,class_train,test_data,class_test,Fs,WindowSize,3);

Accuracy = mean(pred_label==class_test')*100
