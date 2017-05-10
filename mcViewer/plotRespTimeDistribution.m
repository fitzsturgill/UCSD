function plotRespTimeDistribution(trode, cluster)
    global state
    
    respDurations=[];
    for i=1:state.mcViewer.tsNumberOfFiles
        respDurations = [respDurations state.mcViewer.trode(trode).cluster(cluster).analysis.SpikesByCycleShifted.data(1, i).respTimes(3,:)];
    end
    
    disp(['Mean Cycle Duration = ' num2str(mean(respDurations))]);
    disp(['Standard Deviation of Cycle Durations = ' num2str(std(respDurations))]);    
    figure; 
    hist(respDurations, 1000);
    