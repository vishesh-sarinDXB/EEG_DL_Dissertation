% Experiment names will describe channels used first, then frequencies. If
% frequencies are ommited then a bandpass filter between 7 and 30 Hz maybe
% assumed.

% All channels, only basic bandpass filter between 7 and 30 Hz

OPTICALexperimentCV('../../data/processed/sevenThirty_0.5-2.5/', 'all_0.5-2.55', [1:64]);
clear

OPTICALexperimentCV('../../data/processed/sevenThirty_2.5-4.5/', 'all_2.5-4.5', [1:64]);
clear
% 
% % Using all channels, but bandpass ButterWorth filter between 8 and 14 Hz
% % thus isolating alpha and mu waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'all_channels_alphamu', [1:64]);
% clear
% 
% % Only using channels that aren't related to occipital, temporal, or
% % parietal lobes. Allowing channels that are in between one of these and
% % other lobes. Using bandpass filter between 7 and 30 Hz
% OPTICALexperimentCV('../../data/processed/sevenThirty/', 'bio_channelsOPT', [1:14, 17:19, 32:51, 54:56]);
% clear
% 
% % Only using channels that aren't related to , occipital, temporal, or
% % parietal lobes. Allowing channels that are in between one of these and
% % other lobes. Using bandpass filter between 8 and 14 Hz thus isolating 
% % alpha and mu waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'bio_channelsOPT_alphamu', [1:14, 17:19, 32:51, 54:56]);
% clear
% 
% % Only using channels that aren't related to temporal, or
% % parietal lobes. Allowing channels that are in between one of these and
% % other lobes. Using bandpass filter between 7 and 30 Hz
% OPTICALexperimentCV('../../data/processed/sevenThirty/', 'bio_channelsPT', [1:14, 17:19, 25:30, 32:51, 54:56, 62:64]);
% clear
% 
% % Only using channels that aren't related to temporal, or
% % parietal lobes. Allowing channels that are in between one of these and
% % other lobes. Using bandpass filter between 8 and 14 Hz thus isolating
% % alpha and mu waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'bio_channelsPT_alphamu', [1:14, 17:19, 25:30, 32:51, 54:56, 62:64]);
% clear
% 
% % Only using channels related to occipital lobe. 
% % Allowing channels that are in between occipital and other lobes.
% % Using bandpass filter between 8 and 14 Hz thus isolating alpha waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'bio_channelsOonly_alphamu', [25:30, 62:64]);
% clear
% 
% % Only using channels related to motor cortex (C electrodes). 
% % Allowing channels that are in between C electrodes and other regions.
% % Using bandpass filter between 8 and 14 Hz thus isolating mu waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'bio_channelsConly_alphamu', [9:14, 17:19, 32, 44:51, 54:56]);
% clear
% 
% % Only using channels related to motor cortex and occipital lobe (C and O electrodes). 
% % Allowing channels that are in between these and other regions.
% % Using bandpass filter between 8 and 14 Hz thus isolating alpha and mu waves
% OPTICALexperimentCV('../../data/processed/eightFourteen/', 'bio_channelsOConly_alphamu', [9:14, 17:19, 32, 25:30, 44:51, 54:56, 62:64]);
% clear