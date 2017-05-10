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
        case 'MUATrode'
            catNum = 6;
        case 'all'
            catNum = [2:4 6]; %FS MOD 4/3/2012
        otherwise
            disp('incorrect category');
            return
    end
    
%     nTrials = length(unique(spikes.trials));
    nTrials = state.mcViewer.tsNumberOfFiles; %FS MOD 6/25/2012...    this handles case where a cluster has no spikes in certain trials...
    clusters = spikes.labels(find(ismember(spikes.labels(:,2), catNum)), 1)';%clusters that match category, row vector
    labels = spikes.labels(find(ismember(spikes.labels(:,2), catNum)), 2)';%clusters that match category, row vector    
    nClusters = length(clusters);
    nChannels = state.mcViewer.nChannels;
    
    % Get Cluster Quality Information (code stolen from UltraMegaSort2000)
    % which spikes are we showing?
    show = get_spike_indices(spikes, 'all');
    spiketimes = sort( spikes.unwrapped_times(show) );
    rpv  = sum( diff(spiketimes)  <= (spikes.params.refractory_period * .001) );
    nWaveforms = length(show);

    out = struct(...
        'spikeTimes', {cell(1, nTrials)},...
        'spikeTimesAligned', {cell(1, nTrials)},... % to hold aligned spike times, e.g., aligned by a particular respiration cycle
        'spikeAmpsFilt', {cell(nChannels, nTrials)}, ...
        'spikeAmps', {cell(nChannels, nTrials)},...
        'cluster', [],...
        'maxChannel', [],...        %index of strongest electrode channel/site for given cluster
        'spikeLine', [],...
        'label', [], ...              %numeric label 2 = good 3 = multiUnit 4 = garbage
        'analysis', []...               %to contain analysis of that cluster
        );
    
    out = repmat(out, 1, nClusters);
    
%     populate structure with spikeTimes, amplitudes, etc.
    Xdata = round(state.mcViewer.displayXData * 10);
%     Xdata = round(state.mcViewer.displayXData * 100)/100;    
    Xdata = Xdata .* [0 diff(Xdata)]; %non-redundant time indices
    Xdata = Xdata /10;
    for i = 1:nClusters
        cluster = clusters(i);
        out(i).cluster = cluster;
        out(i).label = labels(i);
        allAmps = zeros(nChannels, length(find(spikes.assigns == cluster))); %use for determining best channel, 'maxChannel'
        lastIndex = 1;
        for j = 1:nTrials
            filtInd = spikes.assigns == cluster & spikes.trials == j;
            %gather spikeTimes separated by trial and cluster ID  
            % some shenanigans to deal with issues converting to double precision 
            out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd))* 1000 * 10 - 1/state.mcViewer.sampleRate * 10;
            out(i).spikeTimes{j} = round(out(i).spikeTimes{j})/10;     
             spikeIndices = find(ismember(Xdata, out(i).spikeTimes{1, j})) + 1;  %have to scale so that 1/sample rate is expressed as an integer and then round        
            for k = 1:nChannels
                    out(i).spikeAmpsFilt{k, j} = state.mcViewer.tsFilteredData {1, j}(spikeIndices, k)';
                    out(i).spikeAmps{k, j} = state.mcViewer.tsData {1, j} (spikeIndices, k)';
                    allAmps(k, lastIndex:lastIndex + length(out(i).spikeAmpsFilt{k, j}) - 1) = out(i).spikeAmpsFilt{k, j};
            end
            lastIndex = lastIndex + length(out(i).spikeAmpsFilt{k, j});
        end
        allAmps = abs(mean(allAmps, 2));
        out(i).maxChannel = find(allAmps == max(allAmps));
    end
            
            
    
    % this works as of 1/26/2012:
%     function out = ss_makeClusterStructure(spikes, category)
% % mcViewer and a series of files as well as a corresponding spike structure
% % from ultraMegaSort2000 must be loaded into matlab for use of this
% % function. Used to mark spike locations in mcViewer, separated by cluster.
% 
% 
%     global state
% 
%     catNum = [];
%     switch category
%         case 'good'
%             catNum = 2;
%         case 'multiunit'
%             catNum = 3;
%         case 'garbage'
%             catNum = 4;
%         case 'all'
%             catNum = 2:4;
%         otherwise
%             disp('incorrect category');
%             return
%     end
%     
%     nTrials = length(unique(spikes.trials));
%     clusters = spikes.labels(find(ismember(spikes.labels(:,2), catNum)), 1)';%clusters that match category, row vector
%     labels = spikes.labels(find(ismember(spikes.labels(:,2), catNum)), 2)';%clusters that match category, row vector    
%     nClusters = length(clusters);
%     nChannels = state.mcViewer.nChannels;
%     out = struct(...
%         'spikeTimes', {cell(1, nTrials)},...
%         'spikeTimesAligned', {cell(1, nTrials)},... % to hold aligned spike times, e.g., aligned by a particular respiration cycle
%         'spikeAmpsFilt', {cell(nChannels, nTrials)}, ...
%         'spikeAmps', {cell(nChannels, nTrials)},...
%         'cluster', [],...
%         'maxChannel', [],...        %index of strongest electrode channel/site for given cluster
%         'spikeLine', [],...
%         'label', [], ...              %numeric label 2 = good 3 = multiUnit 4 = garbage
%         'analysis', []...               %to contain analysis of that cluster
%         );
%     
%     out = repmat(out, 1, nClusters);
%     
% %     populate structure with spikeTimes, amplitudes, etc.
%     Xdata = round(state.mcViewer.displayXData * 10);
% %     Xdata = round(state.mcViewer.displayXData * 100)/100;    
%     Xdata = Xdata .* [0 diff(Xdata)]; %non-redundant time indices
%     for i = 1:nClusters
%         cluster = clusters(i);
%         out(i).cluster = cluster;
%         out(i).label = labels(i);
%         allAmps = zeros(nChannels, length(find(spikes.assigns == cluster))); %use for determining best channel, 'maxChannel'
%         lastIndex = 1;
%         for j = 1:nTrials
%             filtInd = spikes.assigns == cluster & spikes.trials == j;
%             %gather spikeTimes separated by trial and cluster ID  
%             out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd)* 1000 - 1/state.mcViewer.sampleRate);
%             out(i).spikeTimes{j} = round(out(i).spikeTimes{j});   % * 10????
% %             out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd)* 1000 - 1/state.mcViewer.sampleRate);
% %             out(i).spikeTimes{j} = round(out(i).spikeTimes{j} * 100)/100;
% %             spikeIndices = find(ismember(Xdata, out(i).spikeTimes{j}));  %have to scale so that 1/sample rate is expressed as an integer and then round            
%              spikeIndices = find(ismember(Xdata, round(out(i).spikeTimes{1, j}*10)));  %have to scale so that 1/sample rate is expressed as an integer and then round
% %             out(i).spikeTimes{j} = double(spikes.spiketimes(filtInd-1)* 1000);            
%             for k = 1:nChannels
%                     out(i).spikeAmpsFilt{k, j} = state.mcViewer.tsFilteredData {1, j}(spikeIndices, k)';
%                     out(i).spikeAmps{k, j} = state.mcViewer.tsData {1, j} (spikeIndices, k)';
%                     allAmps(k, lastIndex:lastIndex + length(out(i).spikeAmpsFilt{k, j}) - 1) = out(i).spikeAmpsFilt{k, j};
%             end
%             lastIndex = lastIndex + length(out(i).spikeAmpsFilt{k, j});
%         end
%         allAmps = abs(mean(allAmps, 2));
%         out(i).maxChannel = find(allAmps == max(allAmps));
%     end
%             
%             