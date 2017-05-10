function mcMakeSpikeSortBrowser

    global state

    try
        delay = state.mcViewer.pulse.pulseDelay;
        nLEDPulses = state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
    catch
        disp('provide pulse information');
        return
    end
    
    if isempty(state.mcViewer.trode)
        return
    end
    %clear old figure and make new one
    mcDeleteSpikeSortBrowser;
    state.mcViewer.spikeSortBrowser = figure('Name', 'SpikeSortBrowser: Analysis Plots', 'NumberTitle', 'off');
    
    % set cluster and trode to 1 and determine cluster ID and category
    state.mcViewer.ssb_cluster = 1;
    state.mcViewer.ssb_trode = 1;

    mcUpdateSpikeLines; % refreshes cluster structures
    state.mcViewer.ssb_clusterValue = state.mcViewer.trode(1).cluster(1).cluster;
    state.mcViewer.ssb_clusterCat = state.mcViewer.trode(1).cluster(1).label;
    updateGUIByGlobal('state.mcViewer.ssb_cluster');
    updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
    updateGUIByGlobal('state.mcViewer.ssb_clusterCat');    
    
    lineColor = {[0 0 0] [1 0 0] [0 1 0] [0 1 1] [1 1 0] [1 0 1] [0 0 1]...
        [0 0 .5] [0 .5 0] [.5 0 0]};
    
    
%     mcUpdateCyclesByTable;
    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    
    % determine spacing values for axes placement
    gap=0; %formerly 0.05
    start=.05;
    height = 1 - start*2;
    delta1=(height-gap*(size(state.mcViewer.ssb_cycleTable, 1)*size(state.mcViewer.ssb_cycleTable, 2) -1))...  % for rasters
        /size(state.mcViewer.ssb_cycleTable, 1)/size(state.mcViewer.ssb_cycleTable, 2);
    delta2=(height-gap*(size(state.mcViewer.ssb_cycleTable, 1) -1))/size(state.mcViewer.ssb_cycleTable, 1);  %for Histograms and PSTHs'  
    start1 = 1 - delta1 - start;
    start2 = 1 - delta2 - start;
    
    trode = state.mcViewer.ssb_trode; % should be sequential integers
    cluster = state.mcViewer.ssb_clusterValue; % are not sequential integers
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length
    binEdges = 0:state.mcViewer.histBinSize/1000:trialLength; % 100msec bins for histogram
    
    spikeTimes = cell(size(state.mcViewer.ssb_cycleTable));
    spikeTrials = cell(size(state.mcViewer.ssb_cycleTable));
    spikes = state.mcViewer.trode(trode).spikes;
    
        % iterate over entire rows each containing cycles to group within
        % histogram and PSTH graphs

    count = 1; % tracks pulse number for spacing raster graphs, total iterations through i and j
    for i = 1:size(state.mcViewer.ssb_cycleTable, 1);     
            % Histogram Axes
            state.mcViewer.ssb_histAxes(i) = axes(...
                'Parent', state.mcViewer.spikeSortBrowser,...
                'Position', [.4 start2 - (i-1) * (delta2 + gap) 0.6 delta2],...
                'XLim', [0 trialLength],...
                'XTickLabel', {},...
                'Box', 'on',...
                'XGrid', 'on'...
                );
            if i == 1
                title(state.mcViewer.ssb_histAxes(i), ...
                    [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue) ' Label:' num2str(state.mcViewer.ssb_clusterCat)],...
                    'Interpreter', 'none');
            end
            
            if i == size(state.mcViewer.ssb_cycleTable, 1)
                set(state.mcViewer.ssb_histAxes(i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
            end
            
            if mod(i, 2) == 1
                set(state.mcViewer.ssb_histAxes(i), 'Color', [0.9 0.9 0.9]);
            end
%                 'Position', [0.3667 start2 - (i-1) * (delta2 + gap) 0.2667 delta2],...            
                % PSTH Axes
%             state.mcViewer.ssb_PSTHAxes(i) = axes(...
%                 'Parent', state.mcViewer.spikeSortBrowser,...
%                 'Position', [0.6834 start2 - (i-1) * (delta2 + gap) 0.2667 delta2],...
%                 'XLim', [0 ISI/1000]...
%                 );

        % iterate over elements of each row vector
        for j = 1:size(state.mcViewer.ssb_cycleTable, 2);
            cycle = state.mcViewer.ssb_cycleTable(i, j);            
            % Raster Axes
            state.mcViewer.ssb_rasterAxes(i,j) = axes(...       
                'Parent', state.mcViewer.spikeSortBrowser,...
                'XTickLabel', {},...
                'Position', [.1 start1 - (count-1) * (delta1 + gap) .25 delta1],...
                'XLim', [0 trialLength],...
                'YDir', 'reverse',...
                'YTickLabel', {},...
                'YTick', [],...
                'Box', 'on',...
                'XGrid', 'on'...
                );
            if i == size(state.mcViewer.ssb_cycleTable, 1) && j == size(state.mcViewer.ssb_cycleTable, 2)
                set(state.mcViewer.ssb_rasterAxes(i, j), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
            end
            if mod(i, 2) == 1
                set(state.mcViewer.ssb_rasterAxes(i, j), 'Color', [0.9 0.9 0.9]);
            end            
            ylabel(state.mcViewer.ssb_rasterAxes(i,j), ['c' num2str(cycle)]);
            trialIndices = cycleLookup == cycle;
            try
                trialIndices = logical(trialIndices .* abs(state.mcViewer.tsRejectAcq - 1));
            catch
            end
            filtTrials = trialLookup(trialIndices);
            filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials); % element by element comparison
            spikeTimes{i, j} = double(spikes.spiketimes(filtInd));
            spikeTrials{i, j} = double(spikes.trials(filtInd));
            
            % in case there are no spikes set these to 0 so that
            % there is something to plot and output from linecustommarker
            if isempty(spikeTimes{i,j})
                spikeTimes{i,j} = 0;
                spikeTrials{i,j} = 0;
            end
            
            % Raster Plots
            state.mcViewer.ssb_rasterLines(i, j) = linecustommarker(spikeTimes{i, j},spikeTrials{i, j},...
                [], [], state.mcViewer.ssb_rasterAxes(i, j)); % one raster for every cycle position
            set(state.mcViewer.ssb_rasterLines(i, j), 'Color', lineColor{min(j, length(lineColor))});
%             set(state.mcViewer.ssb_rasterAxes(i,j), 'YLim', [? ?]); % 
            
            % Trial Histogram
            if ~state.mcViewer.ssb_alignHist
                spikeHist = getSpikeHist(spikeTimes{i, j}, binEdges);
            else
                spikeTimesAligned = cat(2, state.mcViewer.trode(trode).cluster(state.mcViewer.ssb_cluster).spikeTimesAligned{1, filtTrials});
                spikeTimesAligned = spikeTimesAligned ./ 1000; % convert to seconds
                spikeHist = getSpikeHist(spikeTimesAligned, binEdges);
            end
            spikeHist= spikeHist(1:end -  1);
            spikeHist = spikeHist ./ (state.mcViewer.histBinSize/1000) / length(filtTrials);            
            
             state.mcViewer.ssb_histLines(i, j) = line(... % one histogram for every row in ssb_cycleTable
                binEdges(1:end - 1),...
                spikeHist,...
                'Parent', state.mcViewer.ssb_histAxes(i),...
                'Color', lineColor{min(j, length(lineColor))}...
                );

            
            %PSTH
%             allSpikes = spikeTimes{i, j};
%             allSpikes(allSpikes < delay/1000 | allSpikes > (delay/1000 + ISI/1000 * nLEDPulses)) = NaN; % ignore spikes before or after pulse train
%             allSpikes = rem(allSpikes, ISI/1000);  % so much of a better way of doing this than I implemented in Igor (not Igor's fault)
%             spikePSTH = histc(allSpikes, 0:1/1000:ISI/1000);
%             disp('fix PSTH bins in spikePSTH');
%             spikePSTH = spikePSTH(1:end-1);
%             
%             state.mcViewer.ssb_PSTHLines(i,j) = line(... % one histogram for every row in ssb_cycleTable
%                 0:1/1000:(ISI/1000 - 1/1000),...
%                 spikePSTH,...
%                 'Parent', state.mcViewer.ssb_PSTHAxes(i),...
%                 'Color', lineColor{min(j, length(lineColor))}...                
%                 );
            count = count + 1;
        end
    end
    
    % function handle to pull out second element of an input
    % use this function handle with cellfun to attain an array of yMax
    % values from the cell array of yLims returned by get
    getSecond = @(x) x(2);
    % set hist axes to same values
    hAxes = get(state.mcViewer.ssb_histAxes, 'YLim');
    if ~iscell(hAxes)
        hAxes = {hAxes};
    end
    yMax = cellfun(getSecond, hAxes);
    yMax = max(yMax);
    set(state.mcViewer.ssb_histAxes, 'YLim', [0 yMax]);
    
    % set raster axes to same values (minimum yMax in this case)
    hAxes = get(state.mcViewer.ssb_rasterAxes, 'YLim');
    if ~iscell(hAxes)
        hAxes = {hAxes};
    end
    yMax = cellfun(getSecond, hAxes);
    yMax = min(yMax);
    set(state.mcViewer.ssb_rasterAxes, 'YLim', [0 yMax]);
    
    
    
end

function spikeHist = getSpikeHist(times, binEdges)
    global state
    
    if state.mcViewer.histWindow == 0
        spikeHist = histc(times, binEdges);
    else
        span = round(state.mcViewer.histWindow / state.mcViewer.histBinSize);
        if rem(span, 2) == 0
            span = span - 1;
        end
        method = 'moving';
    %             method = 'sgolay';
        spikeHist = mcSmoothedHistogram(times, binEdges, span, method);
    end
end
