% Experiment names will describe channels used first, then frequencies. If
% frequencies are ommited then a bandpass filter between 7 and 30 Hz maybe
% assumed.

% All channels, only basic bandpass filter between 7 and 30 Hz
OPTICALexperimentCaller('../../data/processed/oneFourtyFive/', 'all_145', [1:64]);
clear

% Using all channels, but bandpass ButterWorth filter between 8 and 14 Hz
% thus isolating alpha and mu waves
OPTICALexperimentCVcaller('../../data/processed/oneFourtyFive/', 'all_145', [1:64]);
clear

% Only using channels that aren't related to occipital, temporal, or
% parietal lobes. Allowing channels that are in between one of these and
% other lobes. Using bandpass filter between 7 and 30 Hz
OPTICALexperimentCaller('../../data/processed/oneFourtyFive/', 'bio_channelsOPT_145', [1:14, 17:19, 32:51, 54:56]);
clear

% Only using channels that aren't related to , occipital, temporal, or
% parietal lobes. Allowing channels that are in between one of these and
% other lobes. Using bandpass filter between 8 and 14 Hz thus isolating 
% alpha and mu waves
OPTICALexperimentCVcaller('../../data/processed/oneFourtyFive/', 'bio_channelsOPT_145', [1:14, 17:19, 32:51, 54:56]);
clear

% Only using channels that aren't related to temporal, or
% parietal lobes. Allowing channels that are in between one of these and
% other lobes. Using bandpass filter between 7 and 30 Hz
OPTICALexperimentCaller('../../data/processed/oneFourtyFive/', 'bio_channelsPT_145', [1:14, 17:19, 25:30, 32:51, 54:56, 62:64]);
clear

% Only using channels that aren't related to temporal, or
% parietal lobes. Allowing channels that are in between one of these and
% other lobes. Using bandpass filter between 8 and 14 Hz thus isolating
% alpha and mu waves
OPTICALexperimentCVcaller('../../data/processed/oneFourtyFive/', 'bio_channelsPT_145', [1:14, 17:19, 25:30, 32:51, 54:56, 62:64]);
clear
% 
% % Only using channels related to occipital lobe. 
% % Allowing channels that are in between occipital and other lobes.
% % Using bandpass filter between 8 and 14 Hz thus isolating alpha waves
% OPTICALexperimentCaller('../../data/processed/eightFourteen/', 'bio_channelsOonly_145', [25:30, 62:64]);
% clear
% 
% % Only using channels related to motor cortex (C electrodes). 
% % Allowing channels that are in between C electrodes and other regions.
% % Using bandpass filter between 8 and 14 Hz thus isolating mu waves
% OPTICALexperimentCaller('../../data/processed/eightFourteen/', 'bio_channelsConly_145', [9:14, 17:19, 32, 44:51, 54:56]);
% clear
% 
% % Only using channels related to motor cortex and occipital lobe (C and O electrodes). 
% % Allowing channels that are in between these and other regions.
% % Using bandpass filter between 8 and 14 Hz thus isolating alpha and mu waves
% OPTICALexperimentCaller('../../data/processed/eightFourteen/', 'bio_channelsOConly_145', [9:14, 17:19, 32, 25:30, 44:51, 54:56, 62:64]);
