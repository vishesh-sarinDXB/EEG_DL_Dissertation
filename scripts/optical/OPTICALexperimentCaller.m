function OPTICALexperimentCaller(processed_dir, experiment_name, channels)

for k = 1 : 10
    stream = RandStream('mlfg6331_64','Seed',k); % MATLAB's start-up settings
    RandStream.setGlobalStream(stream);
    en = strcat(experiment_name, '/', num2str(k));
    OPTICALexperiment(processed_dir, en, channels, k);
end
