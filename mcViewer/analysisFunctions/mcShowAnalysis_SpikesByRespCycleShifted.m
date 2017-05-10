function ax=mcShowAnalysis_SpikesByRespCycleShifted(trode, clusterIndex, varargin)
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikesByCycleShifted')
            ax=[];
            return
        end
        %defaults or null values for paramters
        h = []; %if default, generate a fresh figure
        cycles = state.mcViewer.ssb_cycleTable; % default, determines arrangement of axes on each cluster's figure (cycles that share a row are graphed together, each row generates a separate axes)
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
                otherwise
                    error('mcShowAnalysis_SpikesByRespCycleShifted : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clusterIndex) '_SpikesRespCycShifted']...
                );
                h=mcLandscapeFigSetup(h);
        else
            figure(h); % bring figure to front and make current figure
        end
        
        lineColor = state.mcViewer.lineColor;
        % grouped data- structure of size --> [nCycles, nEpochs] 
        groupedData = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData;
        yHeights=zeros(1, size(cycles, 1));
        for i = 1:size(cycles, 1);     
            ax(i, 1) = axes; % ssecond column will contain handles to phase plots....   not implemented yet
            ylabel(ax(i, 1), num2str(cycles(i, :)));  
            if i==1
                title(ax(i,1), 'Rate');
            end            
            hold on
            for j = 1:size(cycles, 2);
                cycle = cycles(i, j);
                for k = 1:size(groupedData, 2)
                    lh=errorbar(groupedData(cycle, k).respTimesAvg, groupedData(cycle, k).respSpikeAvgRate, groupedData(cycle, k).respSpikeAvgRateSEM);
                    yLimits = get(ax(i,1), 'YLim');
                    yHeights(1,i) = yLimits(2);
                    set(lh, 'Color', lineColor{1, j});
                end
            end
        end
        
        set(ax, 'YLim', [0 max(yHeights)]);
                    
%         % now phase per respiration cycle
%         for i = 1:size(cycles, 1);     
%             ax(i, 2) = axes; % ssecond column will contain handles to phase plots....   not implemented yet
%             hold on
%             for j = 1:size(cycles, 2);
%                 cycle = cycles(i, j);
%                 for k = 1:size(groupedData, 2)
%                     lh=errorbar(groupedData(cycle, k).respTimesAvg, groupedData(cycle, k).respSpikeAvgPhase, groupedData(cycle, k).respSpikeAvgPhaseSEM);
%                     set(lh, 'Color', lineColor{1, j});
%                 end
%             end
%         end                
%% Arrange axes on graph
    params.matpos = [0 0 1 1];
    params.cellmargin = [.05 .05 0.05 0.05];
%     setaxesOnaxesmatrix(reshape(ax', 1, numel(ax)), size(ax, 1), size(ax, 2), 1:numel(ax), params, h);     
    setaxesOnaxesmatrix_old(ax', ceil(length(ax)/2), 2, 1:numel(ax), params, h); 

                