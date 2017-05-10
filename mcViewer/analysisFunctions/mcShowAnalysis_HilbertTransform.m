    function ax=mcShowAnalysis_HilbertTransform(trode, clusterIndex, varargin)
        % requires a row vector of cycles
        global state

        if nargin < 2 || isempty(clusterIndex)
            clusterIndex = state.mcViewer.ssb_cluster;
        end
        
        if nargin < 1 || isempty(trode)
            trode = state.mcViewer.ssb_trode;
        end        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'HilbertTransform')
            ax=[];
            return
        end
        

        %defaults or null values for parameters
        h = []; %if default, generate a fresh figure
        cycles = state.mcViewer.ssb_cycleTable; % generate row vector from cycles
%         lowCutoff=0; %default, no filtering
%         highCutoff=0; %default, no filtering
        lineColor = state.mcViewer.lineColor;
        threshold = 0.8;  % i.e. take only top 20% of hilbert spikes by instantaneous power
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
                case 'threshold'
                    threshold = val;
                otherwise
                    error('mcProcessAnalysis_spikeLFPAverage : Invalid Parameter')
            end
            counter=counter+2;
        end
        
        
        % generate wave and/or figure prefix
        prefix = mcExpPrefix;
        
        % deal with parameter contingencies
        if isempty(h)
            newFig=1;
            h = figure(...
                'Name', [prefix 'T' num2str(trode) 'C' num2str(clusterIndex) '_HilbertTransform']...
                );
        else
            figure(h); % bring figure to front and make current figure
            newFig = 0;
        end
        
        
        lineColor = state.mcViewer.lineColor;
        % grouped data- structure of size --> [nCycles, nEpochs] 
        groupedData = state.mcViewer.trode(trode).cluster(clusterIndex).analysis.HilbertTransform.groupedData;
        yHeights=zeros(1, size(cycles, 1));
        
        bins  = linspace(-pi, pi, 18); % bins for histogram
        
        %% determine global threshold for phase amplitude
        allAmps = reshape(state.mcViewer.tsHilbertAmp, size(state.mcViewer.tsHilbertAmp, 1) * size(state.mcViewer.tsHilbertAmp, 2), 1);
        allAmps = sort(allAmps);
        threshold = allAmps(round(threshold * length(allAmps)), 1);
        
        
        %% ODOR PERIOD
        for i = 1:size(cycles, 1);     
            ax(i, 1) = axes; % ssecond column will contain handles to phase plots....   not implemented yet
            ylabel(num2str(cycles(i, :)));
            hold on
            for j = 1:size(cycles, 2);
                cycle = cycles(i, j);
%                 for k = 1:size(groupedData, 2)
                    allPhases = [groupedData(cycle, 2).phase{:,:}];
                    allAmps =  [groupedData(cycle, 2).amplitude{:,:}];
                    indices = allAmps >= threshold;
                    yData = histc(allPhases(indices), bins);
                    yData = yData ./ sum(yData);
%                     bar(ax(i, 1), bins, yData, 'EdgeColor', lineColor{1, j}, 'FaceColor', 'none');
                    line(bins, yData, 'Parent', ax(i, 1), 'Color', lineColor{1, j});
%                     yLimits = get(ax(i,1), 'YLim');
%                     yHeights(1,i) = yLimits(2);
%                     set(lh, 'Color', lineColor{1, j});
%                 end
            end
        end        
        
 
      if newFig  
        splayAxisTile;
      end
        
        
%         Yerr = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,2).sem state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,1).sem], length(cycles), 2);
        % no longer necesssary to flipdim because I concatenate the
        % baseline and odor periods appropriately in the 2 lines of code
        % above
%         if length(cycles) > 1
%             revDim = 2;
%         else
%             revDim = 1;
%         end
%         Y = flipdim(Y, revDim); % so that baseline period comes first and then odor period unlike how it is stored in analysis structure
%         Yerr = flipdim(Yerr, revDim);
%         
% 
%         ax=axes('Parent', h);  
%         bars=barwitherr(Yerr', Y', 'Parent', ax);
%         if length(lineColor) < length(bars)
%             lineColor = repmat(lineColor, 1, ceil(length(bars) / length(lineColor)));
%         end
%         for i = 1:length(bars);
%             set(bars(i), 'FaceColor', lineColor{1, i});
%         end
        

        