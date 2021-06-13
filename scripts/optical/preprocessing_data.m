data_dir = '../../data/mat_data/';
filePattern = fullfile(data_dir, '*.mat');
files = dir(filePattern);
eeg_all = [];
real_left = [];
real_right = [];
mi_left = [];
mi_right = [];


for k = 1 : length(files)
    fullFileName = fullfile(files(k).folder, files(k).name);
    load(fullFileName);
    eeg_all = [eeg_all;eeg]; %#ok<AGROW>
    real_left = [real_left ; eeg.movement_left]; %#ok<AGROW>
    real_right = [real_right ; eeg.movement_right]; %#ok<AGROW>
    mi_left = [mi_left ; eeg.imagery_left]; %#ok<AGROW>
    mi_right = [mi_right ; eeg.imagery_right]; %#ok<AGROW>
end