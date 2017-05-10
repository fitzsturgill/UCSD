function calcClusterZScores
%% DON'T USE- newer funtion available, addZScoresToClusters
    % calculate zscores and directionality of LED effect
    % for Amyl Acetate concentration series experiments-   1-7 for odor
    % series control, 8-14 for odor series LED
    global clusters
    
    disp('Dont use this function: use addZScoresToClusters instead');
    return


    for cluster =1:length(clusters)
        data = clusters(cluster).analysis.SpikeRate.data;
        
        try
            [effect zs] = classifyCluster(data);
        catch
            disp(num2str(cluster));
            continue
        end
        clusters(cluster).analysis.SpikeRate.LEDEffect = effect;
        clusters(cluster).analysis.SpikeRate.LEDZScore = zs;        
        
    end
end



function [effect zs] = classifyCluster(data)
    ratesCtl = [data(1:7, 1).avg; data(1:7, 2).avg];
    try
        stdCtl = [data(1:7, 1).std; data(1:7, 2).std];
    catch
        disp('wtf');
    end
    ratesLED = [data(8:14, 1).avg; data(8:14, 2).avg];
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


        
        
        
        
       