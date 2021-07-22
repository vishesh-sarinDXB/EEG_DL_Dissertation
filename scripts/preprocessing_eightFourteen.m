data_dir = '../data/raw/mat_data/';
filePattern = fullfile(data_dir, '*.mat');
data_dir = dir(filePattern);

if ~exist('../data/processed/eightFourteen/', 'dir')
    mkdir ../data/processed/eightFourteen/
end

data_processed_dir = dir('../data/processed/eightFourteen/');

startEpoch = 0.5;
endEpoch = 2.5;

nbChannels = 64;

for k = 1 : length(data_dir)
    
    fullFileName = fullfile(data_dir(k).folder, data_dir(k).name);
    load(fullFileName);

    fs = eeg.srate;

    nbSamplesPerTrial = ceil((endEpoch - startEpoch) * fs);

    cues_real = find(eeg.movement_event == 1);
    cues_mi = find(eeg.imagery_event == 1);

    nbTrials_real = length(cues_real);
    nbTrials_mi = length(cues_mi);

    real = zeros(nbChannels, nbSamplesPerTrial, (nbTrials_real*2));
    mi = zeros(nbChannels, nbSamplesPerTrial, (nbTrials_mi*2));

    [B,A] = butter(4,[8 14]/(fs/2));   % [8 30]

    movement_left = eeg.movement_left((1:64), :);
    movement_right = eeg.movement_right((1:64), :);

    for trial = 1 : nbTrials_real
        cueIndex = cues_real(trial);
        epoch = movement_left(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch = filter(B,A,epoch);
        real(:,:,trial) = epoch;
    end

    for trial = (nbTrials_real + 1) : (nbTrials_real * 2)
        cueIndex = cues_real(trial - nbTrials_real);
        epoch = movement_right(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch = filter(B,A,epoch);
        real(:,:,trial) = epoch;
    end

    class_real(1:nbTrials_real) = 1;
    class_real((nbTrials_real + 1) : (nbTrials_real * 2)) = 2;

    mi_left = eeg.imagery_left((1:64), :);
    mi_right = eeg.imagery_right((1:64), :);

    for trial = 1 : nbTrials_mi
        cueIndex = cues_mi(trial);
        epoch = mi_left(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch = filter(B,A,epoch);
        mi(:,:,trial) = epoch;
    end

    for trial = (nbTrials_mi + 1) : (nbTrials_mi * 2)
        cueIndex = cues_mi(trial - nbTrials_mi);
        epoch = mi_right(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch = filter(B,A,epoch);
        mi(:,:,trial) = epoch;
    end

    class_mi(1:nbTrials_mi) = 1;
    class_mi((nbTrials_mi + 1) : (nbTrials_mi * 2)) = 2;
    
    fullFileName = fullfile(data_processed_dir(1).folder, data_dir(k).name);
    
    save(fullFileName, 'real', 'mi', 'class_mi', 'class_real');
    
    clear
    
    data_dir = '../data/raw/mat_data/';
    filePattern = fullfile(data_dir, '*.mat');
    data_dir = dir(filePattern);

    if ~exist('../data/processed/eightFourteen/', 'dir')
        mkdir ../data/processed/eightFourteen/
    end

    data_processed_dir = dir('../data/processed/eightFourteen/');

    startEpoch = 0.5;
    endEpoch = 2.5;

    nbChannels = 64;

end