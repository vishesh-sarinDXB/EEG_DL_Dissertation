load('../data/raw/mat_data/s01.mat');

% load('./miscellaneous/BCICIV_calib_ds1a.mat');

fs = eeg.srate;
startEpoch = 0.5;
endEpoch = 2.5;

nbSamplesPerTrial = ceil((endEpoch - startEpoch) * fs);

nbChannels = 64;

cues_real = find(eeg.movement_event == 1);
cues_mi = find(eeg.imagery_event == 1);

nbTrials_real = length(cues_real);
nbTrials_mi = length(cues_mi);

real = zeros(nbChannels, nbSamplesPerTrial, (nbTrials_real*2));
mi = zeros(nbChannels, nbSamplesPerTrial, (nbTrials_mi*2));

[B,A] = butter(4,[7 30]/(fs/2));   % [8 30]

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

class_mi(1:nbTrials_real) = 1;
class_mi((nbTrials_real + 1) : (nbTrials_real * 2)) = 2;