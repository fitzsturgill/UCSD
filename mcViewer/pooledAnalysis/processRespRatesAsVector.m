
function processRespRatesAsVector
% puts SpikesByCycleShifted groupedData into the form of a vector, similar
% to how spikes are stored in ultra mega sort.  Separate ID vectors for
% cycle, trial, epoch can be used in conjunction with respTimes to filter/obtain
% sets of spike rates binned by respiration and  categorized by those same
% variables
    global clusters
   
   
    for cluster = 1:length(clusters)
        groupedData = clusters(cluster).analysis.SpikesByCycleShifted.groupedData;
        vectorData = struct(...
            'respTimes', [],...
            'respSpikeRate', [],...
            'cycle', [],...
            'trial', [],...
            'epoch', []...
            );
       
        for cycle = 1:size(groupedData, 1)
            for epoch = 1:size(groupedData, 2)
                nTrials = size(groupedData(cycle, epoch).respSpikeRate, 2);
                vectorData.respSpikeRate=[vectorData.respSpikeRate [groupedData(cycle, epoch).respSpikeRate{:,:}]];
                vectorData.respTimes=[vectorData.respTimes [groupedData(cycle, epoch).respTimes{:,:}]];
                respNumbers = cellfun(@length, groupedData(cycle, epoch).respSpikeRate);
                trialVector = [];
                for trial = 1:nTrials
                    trialVector = [trialVector zeros(1, respNumbers(1, trial)) + trial];
                end
                vectorData.trial = [vectorData.trial trialVector];
                vectorData.cycle = [vectorData.cycle zeros(1,length(trialVector)) + cycle];
                vectorData.epoch = [vectorData.epoch zeros(1,length(trialVector)) + epoch];
            end
        end
        clusters(cluster).analysis.SpikesByCycleShifted.vectorData = vectorData;
    end