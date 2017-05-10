    function ax=mcShowAnalysis_SpikeLFPAverage(trode, clust, varargin)
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clust).analysis, 'SpikeLFPAverage')
            ax=[];
            return
        end
        %defaults or null values for paramters
        h = []; %if default, generate a fresh figure
        cycles = state.mcViewer.ssb_cycleTable; % default, determines arrangement of axes on each cluster's figure (cycles that share a row are graphed together, each row generates a separate axes)
        lowCutoff=0; %default, no filtering
        highCutoff=0; %default, no filtering
        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'h'
                    h = val;
                case 'cycles'
                    cycles = val;
                case 'lowCutoff'
                    lowCutoff = val;
                case 'highCutoff'
                    highCutoff = val;
                otherwise
                    error('mcProcessAnalysis_spikeLFPAverage : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            newFig = 1;
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg']...
                );
        else
            figure(h); % bring figure to front and make current figure
            newFig = 0;
        end
        
        % Make waves for every cycle
        wList = {};
        argumentList = {'xscale', [0 state.mcViewer.deltaX]}; %eventually scale such that spike occurs at t = 0, i.e. fix startX and not just deltaX
        for i = 1:size(state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data, 1) % iterate over cycles, make a manipulation period and baseline period wave for every cycle           
            waveo([prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i)], ... %may not be the real cycle, check on this- i.e. num2str(i)
                mcFilter(state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data(i, 1).avg, lowCutoff, highCutoff, state.mcViewer.sampleRate),... %filtering does nothing if lowCutoff and highCutoff == 0
                argumentList{:});
            waveo([prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i) 'BL'], ... %may not be the real cycle, check on this- i.e. num2str(i)
                mcFilter(state.mcViewer.trode(trode).cluster(clust).analysis.SpikeLFPAverage.data(i, 2).avg, lowCutoff, highCutoff, state.mcViewer.sampleRate),...
                argumentList{:});
            wList{1, i} = [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i)]; %index should correspond to cycle
            wList{2, i} = [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg_' 'cyc' num2str(i) 'BL'];            
        end 
        
        % graph waves according to cycles parameter or by default according
        % to the arrangement of the cycle table, cycles along a row are
        % graphed together, cycles in separate rows graphed apart
        lineColor = state.mcViewer.lineColor;       
        for i = 1:size(cycles, 1);     
%             ax(i) = subplot(nRows, nColumns, i);
            ax(i) = axes;
          
            graphLabel = [state.mcViewer.trode(trode).name ' C' num2str(state.mcViewer.trode(trode).cluster(clust).cluster)...
                ' L' num2str(state.mcViewer.trode(trode).cluster(clust).label) ' Cyc: ' num2str(cycles(i, :))];
%             graphLabel = 'Spike/LFP Avg'
            text(.1,.9,graphLabel,'Units','normalized');
            for j = 1:size(cycles, 2);
                thisCycle = cycles(i, j);
                append(wList{1, thisCycle});
                set(get(wList{1, thisCycle}, 'plot'),...
                    'Color', lineColor{1, j},...
                    'LineStyle', '-'...
                    );
                append(wList{2, thisCycle});
                set(get(wList{2, thisCycle}, 'plot'),...
                    'Color', lineColor{1, j},...
                    'LineStyle', ':'...
                    );
            end
        end
        
         
        if newFig
            ax=textAxes(h, [prefix 'T' num2str(trode) 'C' num2str(clust) '_SpLFPAvg'], 8);
            splayAxisTile;
        end
