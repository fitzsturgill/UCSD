function out = ss_makeClusterStructure(spikes, category)
% mcViewer and a series of files as well as a corresponding spike structure
% from ultraMegaSort2000 must be loaded into matlab for use of this
% function. Used to mark spike locations in mcViewer, separated by cluster.


    global state

    catNum = [];
    switch category
        case 'good'
            catNum = 2;
        case 'multiunit'
            catNum = 3;
        case 'garbage'
            catNum = 4;
        otherwise
            disp('incorrect category');
            return
    end
    
    nTrials = length(unique(spikes.trials));
    clusters = spikes.labels(spikes.labels(:, 2) == catNum, 1)'; %clusters that match category, row vector   
    nClusters = length(clusters);
    nChannels = state.mcViewer.nChannels;
    out = struct(...
        'spikeTimes', {cell(1, nTrials)},...
        'spikeAmpsFilt', {cell(nChannels, nTrials)}, ...
        'spikeAmps', {cell(nChannels, nTrials)},...
        'cluster', [],...
        'maxChannel', [],...        %index of strongest electrode channel/site for given cluster
        'spikeLine', []...
        );
    
    out = repmat(out, 1, nClusters);
    
%     populate structure with spikeTimes, amplitudes, etc.
    
    for i = 1:nClusters
        cluster = clusters(i);
        out(i).cluster = cluster;
        allAmps = zeros(nChannels, length(find(spikes.assigns == cluster))); %use for determining best channel, 'maxChannel'
        lastIndex = 1;
        for j = 1:nTrials
            filtInd = spikes.assigns == cluster & spikes.trials == j;
            %gather spikeTimes separated by trial and cluster ID  
            out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd)* 1000 - 1/state.mcViewer.sampleRate);
            spikeIndices = find(ismember(round(state.mcViewer.displayXData * 10), round(out(i).spikeTimes{1, j}*10)));  %have to scale so that 1/sample rate is expressed as an integer and then round
%             out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd-1)* 1000);            
            for k = 1:nChannels
                out(i).spikeAmpsFilt{k, j} = state.mcViewer.tsFilteredData {1, j}(spikeIndices, k)';
%                 out(i).spikeAmps{k, j} = state.mcViewer.tsData {1, j} (spikeIndices, k)';
                allAmps(k, lastIndex:lastIndex + length(out(i).spikeAmpsFilt{k, j}) - 1) = out(i).spikeAmpsFilt{k, j};
            end
            lastIndex = lastIndex + length(out(i).spikeAmpsFilt{k, j});
        end
        allAmps = abs(mean(allAmps, 2));
        out(i).maxChannel = find(allAmps == max(allAmps));
    end
            
            