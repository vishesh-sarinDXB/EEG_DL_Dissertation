% Example code
close all
clear 
clc

% load('train_data')
% load('class_train')
% load('test_data')
% load('class_test')

load('../../data/processed/sevenThirty/s08.mat')

Fs = 512;
WindowSize = 2*Fs;
r = 3;

pred_label = OPTICAL_plus(mi,class_mi,real,class_real,Fs,WindowSize,3);

Accuracy = mean(pred_label==class_test')*100
