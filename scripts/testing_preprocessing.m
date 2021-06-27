load('../data/raw/mat_data/s01.mat');

load('./miscellaneous/BCICIV_calib_ds1a.mat');

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

order = 8;
[B,A] = butter(order/2,[7 30]/(fs/2));   % [8 30]

