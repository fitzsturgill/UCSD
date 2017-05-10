function mcProcessAnalysis_HilbertTransform(trode, clusterIndex, varargin)
    global state
    
%         if state.mcViewer.trode(trode).cluster(clusterIndex).label == 4 % skip garbage clusters as these aren't relevent and are computationally intensive due to excessive numbers of spikes
%             return
%         end    
    
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform = struct(...
            'data', [],... %array of size in 1st dimension of # of included spikes
            'groupedData', [],...
            'displayFcnHandle', @mcShowAnalysis_HilbertTransform,...
            'settings', state.mcViewer.hilbert...                
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
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data = struct(...
            'phase', cell(1, state.mcViewer.tsNumberOfFiles),...
            'amplitude', cell(1, state.mcViewer.tsNumberOfFiles)...
            );
        
        if isempty(state.mcViewer.tsHilbertPhase)
            disp('First run mcMakeHilbertTransform');
        end
        
        % iterate over fileNumbers and respiration cycles
        
        for i = 1:state.mcViewer.tsNumberOfFiles
            state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, i).phase = zeros(1, length(state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i}));
            for j = 1:length(state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i})
                spikeTime = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i}(1, j);
                phaseIndex = mcX2pnt(spikeTime);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, i).phase(1, j) = state.mcViewer.tsHilbertPhase(phaseIndex, i);
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, i).amplitude(1, j) = state.mcViewer.tsHilbertAmp(phaseIndex, i);                
            end
        end

%         
        thisStruct = struct(...
            'phase', [],...
            'amplitude', []...
            );

        
        % separate trials into epochs- pre baseline LED, baseline LED, post
        % baseline LED, Odor/LED, post-Odor-LED as values of x1,x2,bl1,bl2
        % allow, i.e. if there aren't breaks before after or between
        % baseline and odor then epochs aren't inserted
        epochs = [bl1 bl2; x1 x2];

        h=waitbar(0, ['HilbertTransform: Trode-' num2str(trode) ' Cluster-' num2str(clusterIndex)]);            
        % groupedData of size # rows = # cycles    # columns = # epochs
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData = repmat(thisStruct, length(cycles), size(epochs, 1));         
        for i = 1:length(cycles)
            cycle = cycles(i);
            trials=mcTrialsByCycle(cycle);           
            for j = 1:size(epochs, 1) % testPeriod and baselinePeriod
                startTime = epochs(j, 1);
                stopTime = epochs(j, 2);

                
                for k = 1:length(trials)
                    trial = trials(k);
                    data = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, trial);
                    spikeTimes = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, trial};
                    
                    spikeIndices = find(spikeTimes > startTime & spikeTimes < stopTime);
                    spikePhases = data.phase(1, spikeIndices);
                    try
                        spikeHAmp = data.amplitude(1, spikeIndices);
                    catch
                        spikeHAmp = [];
                    end
                   
                 
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData(i,j).phase{1,k} = spikePhases; % keep as cell array
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData(i,j).amplitude{1,k} = spikeHAmp; % keep as cell array                    
                    
                end
                
               
            end
            waitbar(i/length(cycles));             
        end        
        close(h);
        
        
       %% old version below: 
%         function mcProcessAnalysis_HilbertTransform(trode, clusterIndex, varargin)
%     global state
%     
% %         if state.mcViewer.trode(trode).cluster(clusterIndex).label == 4 % skip garbage clusters as these aren't relevent and are computationally intensive due to excessive numbers of spikes
% %             return
% %         end    
%     
%         state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform = struct(...
%             'data', [],... %array of size in 1st dimension of # of included spikes
%             'groupedData', [],...
%             'displayFcnHandle', @mcShowAnalysis_HilbertTransform,...
%             'settings', state.mcViewer.hilbert...                
%         );
% 
%         %default values    
%         x1 = state.mcViewer.x1; % now x1, x2, bl1 and bl2 are global variables that are common to multiple analysis types and manually or externally set
%         x2 = state.mcViewer.x2;
%         bl1 = state.mcViewer.bl1;
%         bl2 = state.mcViewer.bl2;
%         cycles = sort(unique(state.mcViewer.tsCyclePos));   % all cycle positions      
%         
%         
%         % parse input parameter pairs
%         counter = 1;
%         while counter+1 <= length(varargin) 
%             prop = varargin{counter};
%             val = varargin{counter+1};
%             switch prop
%                 case 'x1'
%                     x1 = val;
%                 case 'x2'
%                     x2 = val;
%                 case 'bl1'
%                     bl1=val;
%                 case 'bl2'
%                     bl2=val;
%                 case 'cycles'
%                     cycles=val;
%                 otherwise
%             end
%             counter=counter+2;
%         end
%         
%         
%         %% Create a data structure not grouped by cycle
%         %preallocate structure to contain  data
%         %data is a struct of length tsNumberOfFiles
%         %data contains arrays of respTimes (start, stop, and duration in separate
%         %rows) as well as cellArrays of spikeTimes and spikePhases
%         state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data = struct(...
%             'phase', cell(1, state.mcViewer.tsNumberOfFiles)...
%             );
%         
%         if isempty(state.mcViewer.tsHilbertPhase)
%             disp('First run mcMakeHilbertTransform');
%         end
%         
%         % iterate over fileNumbers and respiration cycles
%         
%         for i = 1:state.mcViewer.tsNumberOfFiles
%             state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, i).phase = zeros(1, length(state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i}));
%             for j = 1:length(state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i})
%                 spikeTime = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, i}(1, j);
%                 phaseIndex = mcX2pnt(spikeTime);
%                 state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, i).phase(1, j) = state.mcViewer.tsHilbertPhase{1, i}(phaseIndex, 1);
%             end
%         end
% 
% %         
%         thisStruct = struct(...
%             'phase', []...
%             );
% 
%         
%         % separate trials into epochs- pre baseline LED, baseline LED, post
%         % baseline LED, Odor/LED, post-Odor-LED as values of x1,x2,bl1,bl2
%         % allow, i.e. if there aren't breaks before after or between
%         % baseline and odor then epochs aren't inserted
%         epochs = [bl1 bl2; x1 x2];
% 
%         h=waitbar(0, ['HilbertTransform: Trode-' num2str(trode) ' Cluster-' num2str(clusterIndex)]);            
%         % groupedData of size # rows = # cycles    # columns = # epochs
%         state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData = repmat(thisStruct, length(cycles), size(epochs, 1));         
%         for i = 1:length(cycles)
%             cycle = cycles(i);
%             trials=mcTrialsByCycle(cycle);           
%             for j = 1:size(epochs, 1) % testPeriod and baselinePeriod
%                 startTime = epochs(j, 1);
%                 stopTime = epochs(j, 2);
% 
%                 
%                 for k = 1:length(trials)
%                     trial = trials(k);
%                     data = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.data(1, trial);
%                     spikeTimes = state.mcViewer.trode(trode).cluster(clusterIndex).spikeTimes{1, trial};
%                     
%                     spikeIndices = find(spikeTimes > startTime & spikeTimes < stopTime);
%                     spikePhases = data.phase(1, spikeIndices);
%                    
%                  
%                     state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData(i,j).phase{1,k} = spikePhases; % keep as cell array
%                     
%                 end
%                 
%                
%             end
%             waitbar(i/length(cycles));             
%         end        
%         close(h);