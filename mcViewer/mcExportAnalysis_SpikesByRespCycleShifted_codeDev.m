function out=mcExportAnalysis_SpikesByRespCycleShifted_codeDev(trode, clusterIndex, varargin)
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikesByCycleShifted')
            ax=[];
            return
        end
        clusterLabel = state.mcViewer.trode(trode).cluster(clusterIndex).label;
        %defaults or null values for paramters
        h = []; %if default, generate a fresh figure
        maxDuration = 700; % 700ms
        cycles=unique(state.mcViewer.tsCyclePos);
        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'h'
                    h = val;
                case 'maxDuration' %maximum cycle duration
                    maxDuration = val;
                otherwise
                    error('mcShowAnalysis_SpikesByRespCycle : Invalid Parameter')
            end
            counter=counter+2;
        end
        
%         generate wave and/or figure prefix
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
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
    matpos_cluster=[0 .1 1 0.7];

    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Trode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(clusterIndex) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)))];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    
    %% 1) Everything else
    params.matpos = matpos_cluster;
    params.cellmargin = [.05 .05 0.05 0.05];
    rows=2;
    columns=2;
    %%
        lineColor = state.mcViewer.lineColor;
        % grouped data- structure of size --> [nCycles, nEpochs] 
        groupedData = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikesByCycleShifted.groupedData;
        
        out = struct(...
            'rateAvg', [],...
            'rateSEM', [],...
            'rateN', []...
            );
        out = repmat(out, 3, length(cycles));
        for i = 1:length(cycles)
                cycle = cycles(i);
                ratesBaseline=[];
                ratesOdor=[];
            for j = 1:length(groupedData(cycle,2).respTimes)
                % first baseline
                respTimes = groupedData(cycle, 2).respTimes{1,j};
                respRates = groupedData(cycle, 2).respSpikeRate{1,j};                
                for k = 1:size(respTimes, 2)
                    if respTimes(3,k) < maxDuration
                        ratesBaseline = [ratesBaseline respRates(1, k)];
                    end
                end
                % now Odor
                respTimes = groupedData(cycle, 3).respTimes{1,j};
                respRates = groupedData(cycle, 3).respSpikeRate{1,j};                
                for k = 1:size(respTimes, 2)
                    if respTimes(3,k) < maxDuration
                        ratesOdor = [ratesOdor respRates(1, k)];
                    end
                end                
            end
            
            out(1,cycle).rateAvg = mean(ratesBaseline);
            out(1,cycle).rateN = length(ratesBaseline);            
            out(1,cycle).rateSEM = std(ratesBaseline) ./ sqrt(length(ratesBaseline));
            
            out(2,cycle).rateAvg = mean(ratesOdor);
            out(2,cycle).rateN = length(ratesOdor);            
            out(2,cycle).rateSEM = std(ratesOdor) ./ sqrt(length(ratesBaseline));     
            
            %baseline subtracted
            out(3, cycle).rateAvg = mean(ratesOdor - out(1,cycle).rateAvg);
            out(3,cycle).rateN = length(ratesOdor);
            out(3, cycle).rateSEM = std((ratesOdor - out(1,cycle).rateAvg) ./ sqrt(length(ratesBaseline)));            
        end
        
        cycles = state.mcViewer.ssb_cycleTable; % default, determines arrangement of axes on each cluster's figure (cycles that share a row are graphed together, each row generates a separate axes)        
        
        

        toGraph = zeros(size(cycles), 3);
        toGraphError = zeros(size(cycles), 3);        
        for i = 1:size(cycles,1)
            for j = 1:size(cycles,2)
                cycle = cycles(i, j);
                toGraph(i,j, 1) = out(1, cycle).rateAvg;
                toGraph(i,j, 2) = out(2, cycle).rateAvg;                
                toGraph(i,j, 3) = out(3, cycle).rateAvg;
                toGraphError(i,j, 1) = out(1, cycle).rateSEM;
                toGraphError(i,j, 2) = out(2, cycle).rateSEM;                
                toGraphError(i,j, 3) = out(3, cycle).rateSEM;                    
            end
        end
        axheights = zeros(3,2);
        ax(1) = axes('Parent', h);
        barwitherr(toGraphError(:,:,1), toGraph(:,:,1), 'Parent', ax(1));
        axheights(1,:)=get(ax(1), 'YLim');
        ax(2) = axes('Parent', h);        
        barwitherr(toGraphError(:,:,2), toGraph(:,:,2), 'Parent', ax(2));
        axheights(2,:)=get(ax(2), 'YLim');
        ax(3) = axes('Parent', h);        
        barwitherr(toGraphError(:,:,3), toGraph(:,:,3), 'Parent', ax(3));      
        axheights(3,:)=get(ax(3), 'YLim');        
        maxHeight = max(axheights(:,2));
        minHeight = min(axheights(:,1));
        set(ax, 'YLim', [minHeight maxHeight]);

    
    setaxesOnaxesmatrix_old(ax, 2, 2, 1:3, params, h); 

                