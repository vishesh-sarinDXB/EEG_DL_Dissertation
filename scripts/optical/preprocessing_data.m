data_dir = '../../data/mat_data/';
filePattern = fullfile(data_dir, '*.mat');
files = dir(filePattern);

for k = 1: length(files)
    fullFileName = fullfile(files(k).folder, files(k).name);
%     load(fullFileName)
end

