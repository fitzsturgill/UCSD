function ax=mcShowAnalysis_SpikesByRespCycle(trode, clusterIndex, varargin)
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikesByCycle')
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
                    error('mcShowAnalysis_SpikesByRespCycle : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clusterIndex) '_SpikesRespCyc']...
                );
                h=mcLandscapeFigSetup(h);
        else
            figure(h); % bring figure to front and make current figure
        end
        
        lineColor = state.mcViewer.lineColor;
        % grouped data- structure of size --> [nCycles, nEpochs] 
        groupedData = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycle.groupedData;
        for i = 1:size(cycles, 1);     
            ax(i, 1) = axes;
            ylabel(ax(i, 1), num2str(cycles(i, :))); % ssecond column will contain handles to phase plots....   not implemented yet
            if i==1
                title(ax(i,1), 'Rate');
            end
            hold on
            for j = 1:size(cycles, 2);
                cycle = cycles(i, j);
                for k = 1:size(groupedData, 2)
                    lh=errorbar(groupedData(cycle, k).respTimesAvg, groupedData(cycle, k).respSpikeAvgRate, groupedData(cycle, k).respSpikeAvgRateSEM);
                    set(lh, 'Color', lineColor{1, j});
                end
            end
        end
                    
        % now phase per respiration cycle
        for i = 1:size(cycles, 1);     
            ax(i, 2) = axes; % ssecond column will contain handles to phase plots....   not implemented yet
            if i==1
                title(ax(i,2), 'Phase');
            end            
            hold on
            for j = 1:size(cycles, 2);
                cycle = cycles(i, j);
                for k = 1:size(groupedData, 2)
                    lh=errorbar(groupedData(cycle, k).respTimesAvg, groupedData(cycle, k).respSpikeAvgPhase, groupedData(cycle, k).respSpikeAvgPhaseSEM);
                    set(lh, 'Color', lineColor{1, j});
                end
            end
        end                
        %% clean up axes, etc.
        b.xl = 1;
        b.yl = 0; % don't remove y label
        b.xtl = 1;
        b.ytl = 1;
        removeAxesLabels(reshape(ax(1:end-1, :), 1, numel(ax(1:end-1, :))), b);
%% Arrange axes on graph
    params.matpos = [0 .05 1 0.9];
    params.cellmargin = [.05 .05 0.005 0.005];
    
    setaxesOnaxesmatrix_old(reshape(ax', 1, numel(ax)), size(ax, 1), size(ax, 2), 1:numel(ax), params, h); 

                