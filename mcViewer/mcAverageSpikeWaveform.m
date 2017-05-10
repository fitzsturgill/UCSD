function [avgS avgSx]=mcAverageSpikeWaveform(trode,clusterIndex,window, n, timeRange, cycles)   % kludge- added timeRange and cycles 9/2014
    global state
    
    % window --> 2 element vector     window(1) = time(ms) prior to spike
    % time, window(2) = time(ms) following spike to use for averaging
    if nargin < 4 || isempty(n)
        n=300;
    end
    
    if nargin < 3 || isempty(window)
        window = [1 2];
    end
    

    
    startX = state.mcViewer.startX;
    deltaX = state.mcViewer.deltaX;
    endX=state.mcViewer.endX;
    totalSamples = length(state.mcViewer.startX:state.mcViewer.deltaX:state.mcViewer.endX);
    
    maxChannel = state.mcViewer.trode(trode).cluster(clusterIndex).maxChannel;
    cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster;
    spikes = state.mcViewer.trode(trode).spikes;
    % find all spikes matching cluster and not occuring too near the start
    % and end of an acq to avoid clipping
    if nargin < 5 || isempty(timeRange)% normal mode
        filtInd=find(spikes.assigns == cluster & spikes.spiketimes > window(1)/1000 & spikes.spiketimes < (endX/1000 - window(2)/1000));
    else % special mode 
        includeTrials = mcTrialsByCycle(cycles);
        filtInd=find(spikes.assigns == cluster & spikes.spiketimes > window(1)/1000 & spikes.spiketimes < (endX/1000 - window(2)/1000)...
            & ismember(spikes.trials, includeTrials)  & spikes.spiketimes > timeRange(1)/1000 & spikes.spiketimes < timeRange(2)/1000);
    end
        
        
    filtInd=filtInd(randperm(length(filtInd))); % randomize the indices for this cluster
    % copy code for conversion of single precision UltraMegaSort2000 spike
    % times (in seconds) to double precision mcViewer spike times (in milliseconds) as found in
    % ss_makeClusterStructure
    spikeTimes = double(spikes.spiketimes(filtInd)) * 1000 * 10 - deltaX * 10;
    spikeTimes = round(spikeTimes) / 10;
    spikeFiles = spikes.trials(filtInd);
    % preallocate array
    n = min(n, length(spikeTimes));
    allSpikes = zeros(n, sum(window)/deltaX + 1);
    % gather indv spikes
    for i=1:n
        stime=spikeTimes(i);
        p1=min(max(round(1+((stime - window(1))-startX)/deltaX), 1), totalSamples);
        p2=min(max(round(1+((stime + window(2))-startX)/deltaX), 1), totalSamples);        
        allSpikes(i,:) = state.mcViewer.tsFilteredData{1, spikeFiles(i)}(p1:p2,maxChannel);
    end
    % create avg and xData
    avgS = mean(allSpikes);
    avgSx = -window(1):deltaX:window(2);
    
    
    
    

    