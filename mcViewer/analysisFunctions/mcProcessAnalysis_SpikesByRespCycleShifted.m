function mcProcessAnalysis_SpikesByRespCycleShifted(trode, clusterIndex, varargin)
    global state
    
%         if state.mcViewer.trode(trode).cluster(clusterIndex).label == 4 % skip garbage clusters as these aren't relevent and are computationally intensive due to excessive numbers of spikes
%             return
%         end    
    
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted = struct(...
        'data', [],... %array of size in 1st dimension of # of included spikes
        'groupedData', [],...
        'displayFcnHandle', @mcShowAnalysis_SpikesByRespCycleShifted,...
        'settings', {varargin}...                
        );

        %default values    
        x1 = state.mcViewer.x1; % now x1, x2, bl1 and bl2 are global variables that are common to multiple analysis types and manually or externally set
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;
        cycles = sort(unique(state.mcViewer.tsCyclePos));   % all cycle positions      
        
        
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
                    bl1=val;
                case 'bl2'
                    bl2=val;
                case 'cycles'
                    cycles=val;
                otherwise
            end
            counter=counter+2;
        end
        
        
        %% Create a data structure not grouped by cycle
        %preallocate structure to contain  data
        %data is a struct of length tsNumberOfFiles
        %data contains arrays of respTimes (start, stop, and duration in separate
        %rows) as well as cellArrays of spikeTimes and spikePhases
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data = struct(...
            'respTimes', cell(1, state.mcViewer.tsNumberOfFiles),...
            'respSpikeRate', cell(1, state.mcViewer.tsNumberOfFiles),...
            'respSpikeTimes', cell(1, state.mcViewer.tsNumberOfFiles),...
            'respSpikeTimesZeroed', cell(1, state.mcViewer.tsNumberOfFiles),...
            'respSpikePhases', cell(1, state.mcViewer.tsNumberOfFiles)... % to be added later                                  
            );
        
        
        % iterate over fileNumbers and respiration cycles
        
        for i = 1:state.mcViewer.tsNumberOfFiles
            respTimes = zeros(3, length(state.mcViewer.features.respiration.timesShifted{1,i}) - 1); % one less complete cycle than boundarys between resp cycles
            respTimes(1,:) = state.mcViewer.features.respiration.timesShifted{1,i}(1:end - 1); % starting points of respiration cycles
            respTimes(2,:) = state.mcViewer.features.respiration.timesShifted{1,i}(2:end); % ending points of respiration cycles
            respTimes(3,:) = respTimes(2, :) - respTimes(1, :); % duration of respiration cycles in mSec
            % initialize the following according to length of respTimes
            state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respTimes = respTimes;
            state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeTimes = cell(1, length(respTimes));
            state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeTimesZeroed = cell(1, length(respTimes));            
            state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeRate = zeros(1, length(respTimes));
            for j=1:size(respTimes, 2)
                spikeIndices = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1,i} >= respTimes(1, j) & state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1,i} < respTimes(2, j);
                spikeTimes = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1,i}(spikeIndices);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeTimes{1, j} = spikeTimes;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeTimesZeroed{1, j} = spikeTimes - respTimes(1, j); % time from beginning of respCycle   
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikeRate(1, j) = length(spikeTimes) / respTimes(3, j) * 1000; % rate in Hz
                respSpikePhases = 2 * pi / respTimes(3, j) .* (spikeTimes - respTimes(1, j)); % 2pi / cycle duration in msec * spike time in msec
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, i).respSpikePhases{1, j} = respSpikePhases;             
            end
        end
        
        %% Now create data structure where data is grouped by Cycle
        
        thisStruct = struct(...
            'respTimes', [],...
            'respSpikeRate', [],...
            'respSpikeTimes', [],...
            'respSpikeTimesZeroed', [],...
            'respSpikePhases', [],... 
            'respSpikeAvgPhase', [],...
            'respSpikeAvgPhaseSEM', [],...
            'respSpikeAvgPhaseN', [],...
            'respSpikeAvgRate', [],...
            'respSpikeAvgRateSEM', [],...
            'respSpikeAvgRateN', [],...
            'respTimesAvg', [],...
            'respTimesAvgSEM', [],...
            'respTimesAvgN', []...
            );

        
        % separate trials into epochs- pre baseline LED, baseline LED, post
        % baseline LED, Odor/LED, post-Odor-LED as values of x1,x2,bl1,bl2
        % allow, i.e. if there aren't breaks before after or between
        % baseline and odor then epochs aren't inserted
        epochs = [bl1 bl2];
        if bl1 > 0
            epochs = [0 bl1; epochs];
        end
        
        if x1 > bl2
            epochs = [epochs; bl2 x1];
        end
        epochs = [epochs; x1 x2];
        
        if x2 < state.mcViewer.endX
            epochs = [epochs; x2 state.mcViewer.endX];
        end
        
        % groupedData of size # rows = # cycles    # columns = # epochs
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData = repmat(thisStruct, length(cycles), size(epochs, 1));         
        for i = 1:length(cycles)
            cycle = cycles(i);
            trials=mcTrialsByCycle(cycle);           
            for j = 1:size(epochs, 1) % testPeriod and baselinePeriod
                startTime = epochs(j, 1);
                stopTime = epochs(j, 2);

                %initialize cell containers for rates and phases separated
                %by respiration cycle number
                Rates = {[]};
                Phases = {[]};
                respTimes = {[]};
                
                for k = 1:length(trials)
                    trial = trials(k);
                    data = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.data(1, trial);
                    % find indexes of respiration cycles between start and
                    % stop
                    respIndices = find(data.respTimes(1,:) > startTime & data.respTimes(2,:) < stopTime);
                    
                    % lengthen Rates and Phases if necessary to deal with
                    % varying numbers of respiration cycles in baseline and
                    % odor periods accross trials
                    if length(respIndices) > length(Rates)
                        lengthDifference = length(respIndices) - length(Rates);
                        Rates = [Rates repmat({[]}, 1, lengthDifference)]; % make it longer
                        Phases = [Phases repmat({[]}, 1, lengthDifference)]; % make it longer
                        respTimes = [respTimes repmat({[]}, 1, lengthDifference)]; % make it longer
                    end
                    % Notes 2/14/2013- data(1,1).respSpikeTimes for example is a double cell
                    % array corresponding to the first epoch and first
                    % cycle.  The outer cell array is necessary because
                    % there may be different numbers of respiration cycles
                    % in a paricular trial epoch.  The inner cell array is
                    % necessary because there may be different numbers of
                    % spikes within a respiration cycle.  
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeTimes{1,k} = data.respSpikeTimes(1, respIndices); % keep as cell array
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeTimesZeroed{1,k} = data.respSpikeTimesZeroed(1, respIndices); % keep as cell array
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respTimes{1,k} = data.respTimes(:, respIndices); % double                  
                    try
                        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikePhases{1,k} = data.respSpikePhases(1, respIndices);        % keep as cell array
                    catch
                        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikePhases{1,k} = [];
                        disp('kludge in mcProcessAnalysis_SpikesbyRespCycle');
                    end
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeRate{1,k} = data.respSpikeRate(1, respIndices); % double
                    
                    % add spikerates for every trial and every respiration
                    % cycle to vectors contained within cell array "Rates"
                    
                    %Rates, Phases and respTimes end up being cell arrays
                    %where each cell in the cell array contains rates or
                    %phases from a particular respiration.  The length of
                    %Rates, Phases and respTimes corresponds to the maximum
                    %number of respiration cycles contained within an epoch
                    %across all trials of a particular cycle
                    for l = 1:length(respIndices)
                        respIndex = respIndices(l);
                        Rates{1, l} = [Rates{1, l} data.respSpikeRate(1, respIndex)];
                        Phases{1, l} = [Phases{1, l} data.respSpikePhases{1, respIndex}];
                        respTimes{1, l} = [respTimes{1, l} (data.respTimes(1, respIndex) + data.respTimes(2, respIndex)) / 2]; % take average of beginning and end of resp cycle
                    end
                    
                    %                     state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgPhase{1,k} = data.respSpikeAvgPhase(1, respIndices); % double
                end
                
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgRate = cellfun(@mean, Rates);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgRateN = cellfun(@length, Rates);                
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgRateSEM = cellfun(@std, Rates) ./ sqrt(cellfun(@length, Rates));
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgPhase = cellfun(@mean, Phases);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgPhaseN = cellfun(@length, Phases);                
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respSpikeAvgPhaseSEM = cellfun(@std, Phases) ./ sqrt(cellfun(@length, Phases));
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respTimesAvg = cellfun(@mean, respTimes);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respTimesAvgN = cellfun(@length, respTimes);                
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData(i,j).respTimesAvgSEM = cellfun(@std, respTimes) ./ sqrt(cellfun(@length, respTimes));                
            end
        end        