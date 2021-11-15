raw_data = '/home/swagmaster/EEG_DL_Dissertation/data/raw/ftp.cngb.org/pub/gigadb/pub/10.5524/100001_101000/100295/mat_data/';

% All channels, start epoch 0.5 seconds after cue (2.5 seconds after start
% of trial) and epoch lasts 2 seconds. Fourth order, band pass butterworth
% filter, between 7 and 30 Hz. 
preprocessing_gigaDB(raw_data, 'sevenThirty', 0.5, 2.5, 64, 2, 7, 30)

% All channels, start epoch 0.5 seconds after cue (2.5 seconds after start
% of trial) and epoch lasts 2 seconds. Fourth order, band pass butterworth
% filter, between 8 and 14 Hz. 
preprocessing_gigaDB(raw_data, 'eightFourteen', 0.5, 2.5, 64, 2, 8, 14)

preprocessing_gigaDB(raw_data, 'oneFourtyFive', 0.5, 2.5, 64, 2, 1, 45)