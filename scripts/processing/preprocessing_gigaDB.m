function preprocessing_gigaDB(data_dir, data_processed_dir, startEpoch, endEpoch, nbChannels, order, lowPassBand, highPassBand)

% data_dir = '../data/raw/mat_data/';
filePattern = fullfile(data_dir, '*.mat');
data_dir = dir(filePattern);

data_processed_dir = strcat('../../data/processed/', data_processed_dir, '/');

if ~exist(data_processed_dir, 'dir')
    mkdir(data_processed_dir)
end

data_processed_dir = dir(data_processed_dir);

% startEpoch = 2.5;
% endEpoch = 4.5;

% nbChannels = 64;

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

    [B,A] = butter(order,[lowPassBand highPassBand]/(fs/2));   % [8 30]

    movement_left_intermediate = eeg.movement_left((1:64), :);
    movement_right_intermediate = eeg.movement_right((1:64), :);
    
    movement_left = filter(B, A, movement_left_intermediate);
    movement_right = filter(B, A, movement_right_intermediate);

    for trial = 1 : nbTrials_real
        cueIndex = cues_real(trial);
        epoch_intermediate = movement_left(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch_shape = size(epoch_intermediate);
        epoch = zeros(epoch_shape);
        
        for i=1:(epoch_shape(2))
            epoch(:,i) = epoch_intermediate(:,i)-mean(epoch_intermediate,2);
        end
% %         
%         epoch = filter(B,A,epoch);
        real(:,:,trial) = epoch;
    end

    for trial = (nbTrials_real + 1) : (nbTrials_real * 2)
        cueIndex = cues_real(trial - nbTrials_real);
        epoch_intermediate = movement_right(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch_shape = size(epoch_intermediate);
        epoch = zeros(epoch_shape);
        
        for i=1:(epoch_shape(2))
            epoch(:,i) = epoch_intermediate(:,i)-mean(epoch_intermediate,2);
        end
%         
%         for i=1:(epoch_shape(1))
%             epoch(i,:) = epoch_intermediate(i,:)-mean(epoch_intermediate,1);
%         end
%         
%         epoch = filter(B,A,epoch);
        real(:,:,trial) = epoch;
    end

    class_real(1:nbTrials_real) = 1;
    class_real((nbTrials_real + 1) : (nbTrials_real * 2)) = 2;

    mi_left_intermediate = eeg.imagery_left((1:64), :);
    mi_right_intermediate = eeg.imagery_right((1:64), :);
    
    mi_left = filter(B, A, mi_left_intermediate);
    mi_right = filter(B, A, mi_right_intermediate);

    for trial = 1 : nbTrials_mi
        cueIndex = cues_mi(trial);
        epoch_intermediate = mi_left(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch_shape = size(epoch_intermediate);
        epoch = zeros(epoch_shape);
        
        for i=1:(epoch_shape(2))
            epoch(:,i) = epoch_intermediate(:,i)-mean(epoch_intermediate,2);
        end
%         
%         for i=1:(epoch_shape(1))
%             epoch(i,:) = epoch_intermediate(i,:)-mean(epoch_intermediate,1);
%         end
%         
%         epoch = filter(B,A,epoch);
        mi(:,:,trial) = epoch;
    end

    for trial = (nbTrials_mi + 1) : (nbTrials_mi * 2)
        cueIndex = cues_mi(trial - nbTrials_mi);
        epoch_intermediate = mi_right(:, (cueIndex + round(startEpoch*fs)):(cueIndex + round(endEpoch*fs))-1);
        epoch_shape = size(epoch_intermediate);
        epoch = zeros(epoch_shape);
        
        for i=1:(epoch_shape(2))
            epoch(:,i) = epoch_intermediate(:,i)-mean(epoch_intermediate,2);
        end
%         
%         for i=1:(epoch_shape(1))
%             epoch(i,:) = epoch_intermediate(i,:)-mean(epoch_intermediate,1);
%         end
%         
%         epoch = filter(B,A,epoch);
        mi(:,:,trial) = epoch;
    end

    class_mi(1:nbTrials_mi) = 1;
    class_mi((nbTrials_mi + 1) : (nbTrials_mi * 2)) = 2;
    
    fullFileName = fullfile(data_processed_dir(1).folder, data_dir(k).name);
    
    save(fullFileName, 'real', 'mi', 'class_mi', 'class_real');
    
    disp(fullFileName)
    
%     clear
%     
%     data_dir = '../data/raw/mat_data/';
%     filePattern = fullfile(data_dir, '*.mat');
%     data_dir = dir(filePattern);
% 
%     if ~exist('../data/processed/sevenThirty/', 'dir')
%         mkdir ../data/processed/sevenThirty/
%     end
% 
%     data_processed_dir = dir('../data/processed/sevenThirty/');
% 
%     startEpoch = 2.5;
%     endEpoch = 4.5;
% 
%     nbChannels = 64;
    
end