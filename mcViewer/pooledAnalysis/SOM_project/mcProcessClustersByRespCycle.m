

function mcProcessClustersByRespCycle(nBins)
    % intended for 12 odors analysis, hard coded epochs and number of
    % cycles
    % field binnedRespData is added to SpikesByCycleShifted
    % binnedRespData is of size (nCycles x 2) where the first column
    % corresponds to baseline and the second to odor periods (2 and 3rd)
    % epochs from mcViewer
    global clusters
    
    processRespRatesAsVector;
    epochs = [2 3]; %epochs and epochTimes must match in dimentionality.
    % the number of columns in epochs much mtch the number of rows in
    % epochTimes. Each row in epochTimes contains the start and end time of
    % hte corresponding epoch in "epochs"
    %%
    epochTimes = [4000 6000; 6000 8000];  %hard coded...
    %%
    respDurationThresh = 1.5; % multiples of standard deviation of respiration durations
    for cluster =1:length(clusters)
        nCycles = size(clusters(cluster).analysis.SpikesByCycleShifted.groupedData, 1);
        vectorData = clusters(cluster).analysis.SpikesByCycleShifted.vectorData;
        indices = ismember(vectorData.epoch, [2 3]);
        allDurations = vectorData.respTimes(3, indices);
        clusters(cluster).analysis.SpikesByCycleShifted.respDurationMean = mean(allDurations);
        clusters(cluster).analysis.SpikesByCycleShifted.respDurationStd = std(allDurations);
        thresh = mean(allDurations) + std(allDurations) * respDurationThresh;
        
        epochs = [2 3];
        nCycles = 24;
        binnedRespData=struct(...
            'rates', {cell(1, nBins)},...
            'ratesAvg', zeros(1,nBins),...
            'ratesStd', zeros(1,nBins),...
            'ratesN', zeros(1,nBins),...
            'binTimes', zeros(1,nBins),...
            'ratesCombinedAvg', [],...  %collapse everything into a single bin
            'ratesCombinedStd', [],...
            'ratesCombinedN', []...
            );
        binnedRespData = repmat(binnedRespData, nCycles, length(epochs));
        for cycle = 1:nCycles
            for i = 1:length(epochs)
                epoch = epochs(1,i);
                binEdges = linspace(epochTimes(i, 1), epochTimes(i, 2), nBins + 1);
                binCenters = binEdges(1, 1:nBins) + ((binEdges(1, 2) - binEdges(1,1)) / 2);
                binCenters = binCenters ./ 1000;
                binnedRespData(cycle, i).binTimes = binCenters;
                ratesCombined=[];
                for j = 1:nBins
                    indices = vectorData.epoch == epoch...
                        & vectorData.cycle == cycle...
                        & vectorData.respTimes(3,:) <= thresh...
                        & vectorData.epoch == epoch...
                        & vectorData.respTimes(1,:) >= binEdges(1, j)...
                        & vectorData.respTimes(2,:) < binEdges(1, j+1);
                    rates = vectorData.respSpikeRate(indices);
                    binnedRespData(cycle, i).rates{1, j} = rates;
                    binnedRespData(cycle, i).ratesAvg(1, j) = mean(rates);
                    binnedRespData(cycle, i).ratesStd(1, j) = std(rates);
                    binnedRespData(cycle, i).ratesN(1, j) = length(rates);
                    binnedRespData(cycle, i).ratesN(1, j) = length(rates);
                    ratesCombined = [ratesCombined rates];
                end
                binnedRespData(cycle, i).ratesCombinedAvg = mean(ratesCombined);
                binnedRespData(cycle, i).ratesCombinedStd = std(ratesCombined);
                binnedRespData(cycle, i).ratesCombinedN = length(ratesCombined);                
            end
        end
        clusters(cluster).analysis.SpikesByCycleShifted.binnedRespData = binnedRespData;        
        clusters(cluster).analysis.SpikesByCycleShifted.nBins = nBins;
        
        [effect zs] = classifyCluster(binnedRespData);
        clusters(cluster).analysis.SpikesByCycleShifted.LEDEffect = effect;
        clusters(cluster).analysis.SpikesByCycleShifted.LEDZScore = zs;        
        clusters(cluster).analysis.SpikesByCycleShifted.OdorZScores = odorZScores(binnedRespData);
        

    end
end

function out = odorZScores(data)

    out = zeros(size(data, 1), 1);
    for i = 1:size(out, 1)
        out(i, 1) = (data(i, 2).ratesCombinedAvg - data(i, 1).ratesCombinedAvg) / data(i, 1).ratesCombinedStd;
    end
        
end

function [effect zs] = classifyCluster(data)
    ratesCtl = [data(1:12, 1).ratesCombinedAvg ; data(1:12, 2).ratesCombinedAvg];
    stdCtl = [data(1:12, 1).ratesCombinedStd ; data(1:12, 2).ratesCombinedStd];
    ratesLED = [data(13:24, 1).ratesCombinedAvg ; data(13:24, 2).ratesCombinedAvg];
    deltaRates = ratesLED - ratesCtl;
    zs = deltaRates ./ stdCtl;
    zs = mean(mean(zs(isfinite(zs))));
    deltaRates = mean(deltaRates); % average together baseline and odor period deltaRates to achieve an average delta rate per odor condition
    h = ttest(deltaRates);
    if h
        if mean(deltaRates) > 0
            effect = 1;
        else
            effect = -1;
        end
    else
        effect = 0;
    end
end