function mcProcessAnalysis_SpikeRate(trode, clusterIndex, varargin)
    % generates spike rate analysis field
    % as  of 12/2013 this includees in addition to spike rates, spike rate
    % avg and spike rate sem ALSO the standard dev and sample size (n)
    global state
    disp('Kludge in mcProcessAnalysis_SpikeRate, pre-baseline hard coded as 1st 2 seconds');
    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate = struct(...
        'data', [],... % 
        'dataLabels', {{'odor', 'spontaneous'}},...        
        'displayFcnHandle', @mcShowAnalysis_SpikeRate,...
        'settings', {varargin}...
        );
    
        %default values
        x1 = state.mcViewer.x1; 
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;       
        cycles = sort(unique(state.mcViewer.tsCyclePos));
        reject = 0;
        
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
                case 'reject'
                    reject = val;
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
%         cycleLookup = state.mcViewer.tsCyclePos;
%         trialLookup = 1:state.mcViewer.tsNumberOfFiles;
%         if reject
%             trialLookup = trialLookup(state.mcViewer.tsRejectAcq == 0);
%             cycleLookup = trialLookup(state.mcViewer.tsRejectAcq == 0);
%         end
        cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster;   
        
        h=waitbar(0, ['SpikeRate: Trode-' num2str(trode) ' Cluster-' num2str(cluster)]);         
        for i = 1:length(cycles)
            cycle = cycles(i);
%             filtTrials = trialLookup(cycleLookup == cycle);    
            filtTrials = mcTrialsByCycle(cycle, reject);
            for j = 1:2 % testPeriod and baselinePeriod, and period prior to baseline 
                if j == 1
                    startTime = x1;
                    stopTime = x2;
                else
                    startTime = bl1;
                    stopTime = bl2;
                end
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).data=zeros(1,length(filtTrials)); %preallocate
                for k=1:length(filtTrials)
                    trial=filtTrials(k);
                    filtInd = spikes.assigns == cluster & spikes.trials==trial & spikes.spiketimes_aligned > startTime & spikes.spiketimes_aligned < stopTime;                    
                    spikeTimes = spikes.spiketimes_aligned(filtInd);
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).data(1, k) = length(spikeTimes) / (stopTime - startTime) * 1000; % convert denominator to seconds from msec
                end
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).avg=mean(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).data);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).n = length(filtTrials); % new, 12/2013
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).std = std(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).data);  % new, 12/2013
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).sem = std(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(i, j).data) / sqrt(length(filtTrials));
            end
            
            % This code added later
            % determined true baseline spike rate prior to bl1 as bl1 and
            % bl2 define the baseline LED period in which an LED is present
            % as code is currently used
            if bl1 > 0
%                 print('Kludge in mcProcessAnalysis_SpikeRate, pre-baseline hard coded as 1st 2 seconds');
                bl1 = 2000;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).data=zeros(1,length(filtTrials)); %preallocate
                for k=1:length(filtTrials)
                    trial=filtTrials(k);
                    filtInd = spikes.assigns == cluster & spikes.trials==trial & spikes.spiketimes_aligned > 0 & spikes.spiketimes_aligned < bl1;                    
                    spikeTimes = spikes.spiketimes_aligned(filtInd);
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).data(1, k) = length(spikeTimes) / bl1 * 1000; % convert denominator to seconds from msec
                end
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).avg=mean(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).data);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).n = length(filtTrials);                            
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).std = std(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).data);                            
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).sem = std(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.baseline(i).data) / sqrt(length(filtTrials));            
            end
            
            waitbar(i/length(cycles));
        end
        close(h);
                    