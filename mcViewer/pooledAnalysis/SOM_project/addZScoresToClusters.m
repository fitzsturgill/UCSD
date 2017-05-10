function addZScoresToClusters
    % NOT RELIANT ON RESP CYCLE OR RESP CYCLE SHIFTED ANALYSIS FIELDS    

    % adds zscores corresponding to the significance of the odor response
    % as well as the overall significance of the LED effect
    
    % assumes that there are n total cycles, 1:n/2 correspond to a null
    % odor trial and n/2 - 1 different odors,   (n/2 + 1):n correspond to
    % an odor trial + LED and the same, n/2 - 1 odors as without the LED
    
    
    % not reliant on resp cycle or resp cycle shifted analysis fields, in
    % other words if I wasn't able to capture respiration in a particular
    % experiment then this function generates z scores from spike rates by
    % trial rather than by total respiration cycles across trials for a
    % particular time period
    
    % does require STD and N fields in SpikeRate analysis field, this was
    % added later and will require reprocessing of earlier experiments
    % (such as from 12 odor experiments in early 2013)
    
    global clusters
    
    for cluster = 1:length(clusters)
        nCycles = size(clusters(cluster).analysis.SpikeRate.data, 1);
        if rem(nCycles, 2) ~= 0
            disp(['Cluster Index #' num2str(cluster) ' contains an odd number of cycles, skipping']);
        end
        ctlCyc = 1:nCycles/2;
        LEDCyc = nCycles/2 + 1:nCycles;
        % classify cluster according to direction of LED effect and size of
        % effect (by averaging z scores)
        [effect zs] = classifyCluster(clusters(cluster).analysis.SpikeRate.data, ctlCyc, LEDCyc);
        clusters(cluster).analysis.SpikeRate.LEDEffect = effect;
        clusters(cluster).analysis.SpikeRate.LEDZScore = zs;   
        OdorZScores = odorZScores(clusters(cluster).analysis.SpikeRate.data);
        clusters(cluster).analysis.SpikeRate.OdorZScores = OdorZScores;   
    end
end

function [effect zs] = classifyCluster(data, ctlCyc, LEDCyc)
    % remember for SpikeRate field, basline period is second column, odor
    % period is first column
    ratesCtl = [data(ctlCyc, 2).avg; data(ctlCyc, 1).avg];
    stdCtl = [data(ctlCyc, 2).std; data(ctlCyc, 1).std];    
    ratesLED = [data(LEDCyc, 2).avg; data(LEDCyc, 1).avg];
    deltaRates = ratesLED - ratesCtl;
    zs = deltaRates ./ stdCtl;
    zs = mean(mean(zs(isfinite(zs))));
    deltaRates = mean(deltaRates); % average together baseline and odor periods
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

function out = odorZScores(data)

    out = zeros(size(data, 1), 1);
    for i = 1:size(out, 1)
        out(i, 1) = (data(i, 1).avg - data(i, 2).avg) / data(i, 2).std;
    end 
end
    
    