data_dir = '../../data/raw/mat_data/';
filePattern = fullfile(data_dir, '*.mat');
data_dir = dir(filePattern);

if ~exist('../../data/processed/', 'dir')
    mkdir ../../data/processed/
end

data_processed_dir = dir('../../data/processed/');

%butterworth bandpass 7 and 30 hz, and 0.5 past onset then 2 seconds

for k = 1 : length(data_dir)
    
    fullFileName = fullfile(data_dir(k).folder, data_dir(k).name);
    load(fullFileName);
    
    real= [];
    mi = [];
    
    real_event = find(eeg.movement_event == 1);
    mi_event = find(eeg.imagery_event == 1);
    
    for idx = 1 : 19
        real(: , : , idx) = eeg.movement_left( : , (real_event(idx) + 500):(real_event(idx) + 2000)); %#ok<SAGROW>
    end
    
    for idx = 20 : 38
        real(: , : , idx) = eeg.movement_right( : , (real_event(idx-19) + 500):(real_event(idx-19) + 2000));%#ok<SAGROW>
    end
    
    class_real(1:19) = 1;
    class_real(20:38) = 2;
    
    for idx = 1 : 99
        mi(: , : , idx) = eeg.imagery_left( : , (mi_event(idx) + 500):(mi_event(idx) + 2000)); %#ok<SAGROW>
    end
    
    for idx = 100 : 198
        mi(: , : , idx) = eeg.imagery_right( : , (mi_event(idx-99) + 500):(mi_event(idx-99) + 2000));%#ok<SAGROW>
    end
    
    class_mi(1:99) = 1;
    class_mi(100:198) = 2;
    
    fullFileName = fullfile(data_processed_dir(1).folder, data_dir(k).name);
    
    save(fullFileName, 'real', 'mi', 'class_mi', 'class_real');
    
end