function mcShowAnalysisAll(analysisField, varargin)
    global state
    
    if isempty(state.mcViewer.trode)
        return
    end
    
    % iterate over trodes and clusters
    for i = 1:length(state.mcViewer.trode)
        % borrowed from mcUpdateSpikeLines:
        %ensure that trode contains spike structure and cluster structure
        if isempty(state.mcViewer.trode(i).spikes)
            continue
        elseif ~isfield(state.mcViewer.trode(i), 'cluster') || isempty(state.mcViewer.trode(i).cluster) %|| force
            state.mcViewer.trode(i).cluster = ss_makeClusterStructure(state.mcViewer.trode(i).spikes, 'all');
        end

        for j = 1:length(state.mcViewer.trode(i).cluster)
            if ~isfield(state.mcViewer.trode(i).cluster(j), 'analysis')
                state.mcViewer.trode(i).cluster(j).analysis=[];
            end
%             f=str2func(['mcShowAnalysis_' analysisField]); % for every type of trode analysis create this function and store it in the matlab path
            f = state.mcViewer.trode(i).cluster(j).analysis.(analysisField).displayFcnHandle;
            f(i, j, varargin{:,:}); %execute function handle with trode, cluster, and varargin as arguments
        end
    end
% % 

% 
%     function mcShowAnalysis_WaveForm(trode, clust, varargin)
%         global state
%         
%         plot_waveforms(state.mcViewer.trode(trode).spikes, state.mcViewer.trode(trode).cluster(clust).cluster);
%         
        
%     function mcShowAnalysis_SpikeLFPAverage(trode, clust, varargin)
%         global state
%         
%         %defaults or null values for paramters
%         h = []; %if default, generate a fresh figure
%         cycles = state.mcViewer.ssb_cycleTable; % default, determines arrangement of axes on each cluster's figure (cycles that share a row are graphed together, each row generates a separate axes)
%         
%         % parse input parameter pairs
%         counter = 1;
%         while counter+1 <= length(varargin) 
%             prop = varargin{counter};
%             val = varargin{counter+1};
%             switch prop
%                 case 'h'
%                     h = val;
%                 case 'cycles'
%                     cycles = val;
%                 otherwise
%                     error('mcProcessAnalysis_spikeLFPAverage : Invalid Parameter')
%             end
%             counter=counter+2;
%         end
%         
%         % generate wave and/or figure prefix
%         firstIndex = strfind(state.mcViewer.tsFileNames{1,1}, '_'); %last underscore
%         firstIndex = firstIndex(end);
%         lastIndex = strfind(state.mcViewer.tsFileNames{1,1}, '.daq'); %file extension, should only occur once
%         firstNum = state.mcViewer.tsFileNames{1,1}(firstIndex + 1 : lastIndex - 1);
%         firstIndex = strfind(state.mcViewer.tsFileNames{1,end}, '_'); %last underscore
%         firstIndex = firstIndex(end);
%         lastIndex = strfind(state.mcViewer.tsFileNames{1,end}, '.daq'); %file extension, should only occur once            
%         lastNum = state.mcViewer.tsFileNames{1,end}(firstIndex + 1 : lastIndex - 1);
%         prefix = [state.mcViewer.fileBaseName num2str(firstNum) 'to' num2str(lastNum) '_'];
%         
%         % deal with parameter contingencies
%         if isempty(h)
%             h = figure(...
%                 'Name', [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg']...
%                 );
%         else
%             figure(h); % bring figure to front and make current figure
%         end
%         
%         % Make waves for every cycle
%         wList = {};
%         argumentList = {'xscale', [0 state.mcViewer.deltaX]}; %eventually scale such that spike occurs at t = 0, i.e. fix startX and not just deltaX
%         for i = 1:size(state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data, 1) % iterate over cycles, make a manipulation period and baseline period wave for every cycle           
%             waveo([prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i)], ... %may not be the real cycle, check on this- i.e. num2str(i)
%                 state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data(i, 1).avg,...
%                 argumentList{:});
%             waveo([prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i) 'BL'], ... %may not be the real cycle, check on this- i.e. num2str(i)
%                 state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data(i, 2).avg,...
%                 argumentList{:});
%             wList{1, i} = [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i)]; %index should correspond to cycle
%             wList{2, i} = [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i) 'BL'];            
%         end % kludge to cmpile
%         
%         % graph waves according to cycles parameter or by default according
%         % to the arrangement of the cycle table, cycles along a row are
%         % graphed together, cycles in separate rows graphed apart
%         lineColor = {[0 0 0] [1 0 0] [0 1 0] [0 1 1] [1 1 0] [1 0 1] [0 0 1]...
%             [0 0 .5] [0 .5 0] [.5 0 0]};        
%         nColumns = 2;
%         nRows = ceil(size(cycles, 1));
%         for i = 1:size(cycles, 1);     
%             subplot(nRows, nColumns, i);
%             for j = 1:size(cycles, 2);
%                 thisCycle = cycles(i, j);
%                 append(wList{1, thisCycle});
%                 set(get(wList{1, thisCycle}, 'plot'),...
%                     'Color', lineColor{1, j},...
%                     'LineStyle', '-'...
%                     );
%                 append(wList{2, thisCycle});
%                 set(get(wList{2, thisCycle}, 'plot'),...
%                     'Color', lineColor{1, j},...
%                     'LineStyle', ':'...
%                     );
%             end
%         end
        