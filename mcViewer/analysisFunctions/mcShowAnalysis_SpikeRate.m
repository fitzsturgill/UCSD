    function ax=mcShowAnalysis_SpikeRate(trode, clusterIndex, varargin)
        % requires a row vector of cycles
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikeRate')
            ax=[];
            return
        end
        %defaults or null values for parameters
        h = []; %if default, generate a fresh figure
        cycles = reshape(state.mcViewer.ssb_cycleTable', 1, numel(state.mcViewer.ssb_cycleTable)); % generate row vector from cycles
        lowCutoff=0; %default, no filtering
        highCutoff=0; %default, no filtering
        lineColor = state.mcViewer.lineColor;
        showBaseline = 1;
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
                case 'lineColor'
                    lineColor = val;
                case 'showBaseline'
                    showBaseline = val;
                otherwise
                    error('mcProcessAnalysis_spikeLFPAverage : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clusterIndex) '_SpikeRate']...
                );
        else
            figure(h); % bring figure to front and make current figure
        end
        
        if showBaseline
            Y = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,2).avg state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,1).avg],...
                numel(cycles), 2);
            Yerr = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,2).sem state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,1).sem],...
                numel(cycles), 2);
        else
            Y = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,1).avg],...
                2, numel(cycles)/2);
            Yerr = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,1).sem],...
                2, numel(cycles)/2);        
        end


        ax=axes('Parent', h);  
        bars=barwitherr(Yerr', Y', 'Parent', ax);
        
        %kludge for alternating black and red
%         lineColor = {[0 0 0], [1 0 0]};
        %

        if length(lineColor) < length(bars)
            lineColor = repmat(lineColor, 1, ceil(length(bars) / length(lineColor)));
        end
        lineColor = repmat(lineColor(1:size(state.mcViewer.ssb_cycleTable, 2)), 1, size(state.mcViewer.ssb_cycleTable, 1));   % kludge 2014      

        for i = 1:length(bars);
            set(bars(i), 'FaceColor', lineColor{1, i});
        end
        
        set(ax, 'TickDir', 'out');
        

        