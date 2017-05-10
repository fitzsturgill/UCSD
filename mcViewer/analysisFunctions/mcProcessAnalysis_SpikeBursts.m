function mcProcessAnalysis_SpikeBursts(trode, clusterIndex, varargin)
    % generates data structure containing 1) data field, with all spike
    % ISIs for creation of cumulative autocorrelogram for a given cluster
    % 2) groupedData.ISIs, ISIs for spontaneous and odor period 3)
    % groupedData.bursts, counts of singles, doubles, triples, and 4+
    % events separated by less than a threshold interval defining a burst
    
    % burstCutoff is the optional parameter (default = 10ms) for this
    % threshold
    global state

    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts = struct(...
        'data', [],... %
        'groupedData', [],...
        'dataLabels', {{'spontaneous', 'odor'}},...
        'displayFcnHandle', @mcShowAnalysis_SpikeBursts,...
        'settings', {varargin}...
        );
    
        %default values
        x1 = state.mcViewer.x1; 
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;       
        cycles = sort(unique(state.mcViewer.tsCyclePos));
        burstCutoff = 10;  %ISI of 10msec or less denotes a spike burst
        
        
        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'x1'
                    x1 = val;
                case 'x2'
                    x2 = val;
                case 'bl1'
                    bl1 = val;
                case 'bl2'
                    bl2 = val;                    
                case 'cycles'
                    cycles = val;
                case 'burstCutoff'
                    burstCutoff = val;
                otherwise
            end
            counter=counter+2;
        end
        

        
        %mcAddPointAlignedSpikeTimes must be called prior to retrieving
        %spikes structure as it deposites aligned times in spikes structure
        if ~isfield(state.mcViewer.trode(trode).spikes, 'spiketimes_aligned')
            mcAddPointAlignedSpikeTimes; %equivalent to spikes.spiketimes but in msec and scaled for indexing into tsXData (see ss_makeClusterStructure)             
        end          
        spikes = state.mcViewer.trode(trode).spikes;
        cycleLookup = state.mcViewer.tsCyclePos;
        trialLookup = 1:state.mcViewer.tsNumberOfFiles;
        cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster; 
        h=waitbar(0, ['SpikeBursts: Trode-' num2str(trode) ' Cluster-' num2str(cluster)]);             

        % preallocate groupedData
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts.groupedData = struct(...
            'ISIs', cell(length(cycles), 2),...
            'bursts', cell(length(cycles), 2)...
            );
        % first extract unwrapped spike times (monotonically increasing, mesured in seconds) for generation of
        % cumulative autocorrelograms 
          filtInd = spikes.assigns == cluster;
%         ISIs = diff(state.mcViewer.trode(trode).spikes.spiketimes_aligned(filtInd));
%         ISIs = ISIs(ISIs > 0);
%         state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts.data.ISIs = ISIs;
          state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts.data.unwrapped_times = state.mcViewer.trode(trode).spikes.unwrapped_times(filtInd);
        
        % now extract ISIs grouped by cycle and analysis period, as well as
        % counts of spike bursts of different orders (singles, doubles,
        % triples, 4+
        for i = 1:length(cycles)
            cycle = cycles(i);
            filtTrials = trialLookup(cycleLookup == cycle);            
            for j = 1:2 % testPeriod and baselinePeriod, and period prior to baseline 
                if j == 1
                    startTime = bl1;
                    stopTime = bl2;
                else
                    startTime = x1;
                    stopTime = x2;
                end


                filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials) & spikes.spiketimes_aligned > startTime & spikes.spiketimes_aligned < stopTime;                    
                spikeTimes = spikes.spiketimes_aligned(filtInd);
                spikeISIs = diff(spikeTimes);
                spikeISIs = spikeISIs(spikeISIs > 0);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts.groupedData(i, j).ISIs = spikeISIs;
                
                % now turn ISIs into a logical vector and count the spike
                % bursts
                spikeISIs = spikeISIs < burstCutoff;
                bursts = zeros(1, 4); % vector in which to tally single spikes, doublets, triples, and 4+ events
                bursts(1,1) = length(find(not(spikeISIs)));
                starts = diff([0 spikeISIs]);
                
                for k = find(starts == 1)
                    count = 1;
                    while 1
                        if k + count > length(starts) || starts(k + count) == -1
                            break
                        end
                        count = count + 1;
                    end
                    % if count == 1 then the qualifying ISI was not trailed
                    % by another qualifying ISI, indicating a spike
                    % doublet, tally this doublet into the 2nd (or count+1)
                    % element of the variable bursts
                    bursts(1, min(count + 1, 4)) = bursts(1, min(count + 1, 4)) + 1;                    
                end
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeBursts.groupedData(i, j).bursts = bursts;                
            end
            waitbar(i/length(cycles)); 
        end
        close(h);
              