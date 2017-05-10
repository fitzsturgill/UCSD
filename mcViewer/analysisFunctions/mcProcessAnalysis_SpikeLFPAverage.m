    function mcProcessAnalysis_SpikeLFPAverage(trode, clusterIndex, varargin)
%         function mcProcessAnalysis_SpikeLFPAverage(trode, clusterIndex,
%         varargin)     Parameters contained within varargin:
%       x1- time within trial to begin including spikes for average
%       x2- time within trial to end including spikes for average
%       bl1 - time to begin calculating baseline
%       bl2 - time to end calculating baseline
%       window- time window (msec) surrounding a given spike, equal to
%       length of average
%       cycles- vector of cycles, for each of which an independent average
%       is generated
        global state
        
%         state.mcViewer.trode(trode).cluster(clusterIndex).analysis=rmfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikeLFPAverage');
%         return
        if state.mcViewer.trode(trode).cluster(clusterIndex).label == 4 || strcmpi(state.mcViewer.trode(trode).name, 'MUATrode')  % skip garbage clusters as these aren't relevent and are computationally intensive due to excessive numbers of spikes
            return
        end
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage = struct(...
            'data', [],... %array of size in 1st dimension of # of included spikes
            'displayFcnHandle', @mcShowAnalysis_SpikeLFPAverage,...
            'settings', {varargin}...                
            );


        %default values
        window = 1000; % 100msec        
%         x1 = state.mcViewer.startX; 
%         x2 = state.mcViewer.endX;
%         bl1 = state.mcViewer.startX;
%         bl2 = x2 - floor(window/2);
        x1 = state.mcViewer.x1; % now x1, x2, bl1 and bl2 are global variables that are common to multiple analysis types and manually or externally set
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;
        maxChannel = state.mcViewer.trode(trode).cluster(clusterIndex).maxChannel;        
        

        cycles = sort(unique(state.mcViewer.tsCyclePos));
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
                case 'window'
                    window = val;
                case 'cycles'
                    cycles = val;
                case 'channel'
                    maxChannel = val;
                otherwise
            end
            counter=counter+2;
        end
%         bl1 = state.mcViewer.startX; %set bl1 and bl2 in relation to x1 as defaults
%         bl2 = x1 - floor(window/2);        
%         counter = 1;
%         while counter+1 <= length(varargin) 
%             prop = varargin{counter};
%             val = varargin{counter+1};
%             switch prop
%                 case 'bl1'
%                     bl1 = val;
%                 case 'bl2'
%                     bl2 = val;
%                 otherwise
%             end
%             counter=counter+2;
%         end        
        %needed quantities/vectors/arrays

        mcAddPointAlignedSpikeTimes; %equivalent to spikes.spiketimes but in msec and scaled for indexing into tsXData (see ss_makeClusterStructure)
        spikes = state.mcViewer.trode(trode).spikes; 
        cycleLookup = state.mcViewer.tsCyclePos;
        trialLookup = 1:state.mcViewer.tsNumberOfFiles;
        cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster;
        
        %preallocate structure to contain SpikeLFPAverage data
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage.data = struct(...
            'avg', cell(length(cycles), 2),...
            'n', [],...
            'sem', cell(length(cycles), 2)...
            );       
%             'data', cell(length(cycles), 2),...        
        
        %more needed quantities/vectors/arrays        
        windowSamples = round(window/state.mcViewer.deltaX);
        windowSamples = floor(windowSamples/2) * 2 + 1; %ensures that windowSamples is an odd number so that a given spike occurs in the exact center of a given snippet of data
        halfWindow = floor(windowSamples/2); % # samples/points lying on either side of center/spike location
        totalTrialSamples = size(state.mcViewer.tsData{1,1}, 1);
        
        % ensure that windows contain an odd number of points such that the
        % spike can be precisely in the middle (I think this is why I have
        % this code.... :) )
        if mcX2pnt(x1) < halfWindow + 1
            x1 = ceil(mcPnt2x(halfWindow + 1));
        end
        if mcX2pnt(x2) > totalTrialSamples - halfWindow - 1
            x2 = floor(mcPnt2x(totalTrialSamples - halfWindow - 1));
        end
        
        if mcX2pnt(bl1) < halfWindow + 1
            bl1 = ceil(mcPnt2x(halfWindow + 1));
        end
        if mcX2pnt(bl2) > totalTrialSamples - halfWindow - 1
            bl2 = floor(mcPnt2x(totalTrialSamples - halfWindow - 1));
        end        
        

        % fill cell array with data surrounding each spike of length ==
        % windowSamples
  
        h=waitbar(0, ['SpikeLFPAverage: Trode-' num2str(trode) ' Cluster-' num2str(cluster)]);
        waitCount = 1;
        for i = 1:length(cycles)
            cycle = cycles(i);
            filtTrials = trialLookup(cycleLookup == cycle);            
            for j = 1:2 % testPeriod and baselinePeriod
                if j == 1
                    startTime = x1;
                    stopTime = x2;
                else
                    startTime = bl1;
                    stopTime = bl2;
                end
                %preallocate array to contain data snippets surrounding spikes      
                %filtInd- indices of spikes limited to a particular cluster, trial and tme
                %range
                filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials) & spikes.spiketimes_aligned > startTime & spikes.spiketimes_aligned < stopTime;
                spikeTimes = spikes.spiketimes_aligned(filtInd);
                spikeTrials = spikes.trials(filtInd);
                spikeData = zeros(length(spikeTimes), windowSamples); % Preallocation: to contain data snippets surrounding spikes               
                spikeCount = 1;
                for k = 1:length(filtTrials)
%                     tic;
                    trial = filtTrials(k);
                    trialSpikeTimes = spikeTimes(spikeTrials == trial); %advantage of drawing trialSpikeTimes from spikes-derived structure is I've already limited spikes to those in analysis window (startTime to stopTime)
                    trialData=state.mcViewer.tsData{1, trial}(:, maxChannel)';
                    for l = 1:length(trialSpikeTimes)
                        spikePoint = mcX2pnt(trialSpikeTimes(l));
                        p1 = spikePoint - halfWindow;
                        p2 = spikePoint + halfWindow;
                        spikeData(spikeCount,:) = trialData(p1:p2);
                        spikeCount = spikeCount + 1;                       
                    end                   
%                     disp(['Processing-  Trial:' num2str(trial) ' Period:' num2str(j) ' Cycle:' num2str(cycle)]);
%                     toc;                      
                end
                %deposit spike data
%                 state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage.data(i, j).data = spikeData;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage.data(i, j).avg = mean(spikeData);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage.data(i, j).n = size(spikeData, 1);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPAverage.data(i, j).sem = std(spikeData) / sqrt(size(spikeData, 1));
                waitbar(waitCount/(length(cycles) * 2));                
                waitCount = waitCount + 1;
            end
        end
        close(h);
