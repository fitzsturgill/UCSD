function mcUpdateSpikeSortBrowser(force)


    global state
    %% kludge
%     global exclude excludeTrials
    %% end kludge
    if nargin < 1
        force = 0;
    end
    
    try
        delay = state.mcViewer.pulse.pulseDelay;
        nLEDPulses = state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
    catch
        disp('provide pulse information');
        return
    end
    

    % force ensures updating in case cycle selection table has changed,
    % etc.
    if force || ~ishandle(state.mcViewer.spikeSortBrowser)
        mcMakeSpikeSortBrowser;
        return
    end
    
    lineColor = {[0 0 0] [1 0 0] [0 1 0] [0 1 1] [1 1 0] [1 0 1] [0 0 1]...
        [0 0 .5] [0 .5 0] [.5 0 0]};

    %   state.mcViewer.tsCyclePos should be updated at this point    
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    cycleLookup = state.mcViewer.tsCyclePos;
    
    trode = state.mcViewer.ssb_trode;
    cluster = state.mcViewer.ssb_clusterValue;
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length
    binEdges = 0:state.mcViewer.histBinSize/1000:trialLength; % 250msec bins for histogram
    
%     spikeTimes = cell(size(state.mcViewer.ssb_cycleTable));
%     spikeTrials = cell(size(state.mcViewer.ssb_cycleTable));
    spikes = state.mcViewer.trode(trode).spikes;

    title(state.mcViewer.ssb_histAxes(1), ...
                    [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue) ' Label:' num2str(state.mcViewer.ssb_clusterCat)],...
                    'Interpreter', 'none');
    excludeTrials = [];
    for i = 1:size(state.mcViewer.ssb_cycleTable, 1);
        for j = 1:size(state.mcViewer.ssb_cycleTable, 2);
            cycle = state.mcViewer.ssb_cycleTable(i, j);
            filtTrials = trialLookup(cycleLookup == cycle);
            filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials); % element by element comparison
            spikeTimes = double(spikes.spiketimes(filtInd));
            spikeTrials = double(spikes.trials(filtInd));           
            
%             %% build kludge to exclude certain acquisitions (but balanced across cycles)
%             
% %             exclude = []; % exclude 10 - 15th acquisition for every cycle
%             disp('get rid of kludge in mcUpdateSpikeSortBrowser');
%             allTimes = spikeTimes;
%             allTrials = spikeTrials;
%             
%             % now figure out which acqs for a given cycle correspond to the
%             % excluded repititions
%             
%             uTrials = sort(unique(allTrials));
%             exTrials = uTrials(exclude);
%             excludeTrials = [excludeTrials exTrials];
% %             [selectTrials indices] = setdiff(allTrials, excludeTrials);
%             indices = ~ismember(allTrials, exTrials);
%             selectTimes = allTimes(indices);
%             selectTrials = allTrials(indices);
%             
%             spikeTimes = selectTimes;
%             spikeTrials = selectTrials;
%             
%             %%
            % Raster Plots
            cla(state.mcViewer.ssb_rasterAxes(i, j)); % remove old raster line objects
            rasterLine = linecustommarker(spikeTimes,spikeTrials,...
                [], [], state.mcViewer.ssb_rasterAxes(i, j)); % one raster for every cycle position
            if isempty(rasterLine)
                rasterLine = line(0, 0, 'Parent', state.mcViewer.ssb_rasterAxes(i, j));
            end
            state.mcViewer.ssb_rasterLines(i, j) = rasterLine;
            set(state.mcViewer.ssb_rasterLines(i, j), 'Color', lineColor{min(j, length(lineColor))});            
            
            % Trial Histogram
            if ~state.mcViewer.ssb_alignHist
                spikeHist = getSpikeHist(spikeTimes, binEdges);
            else
                spikeTimesAligned = cat(2, state.mcViewer.trode(trode).cluster(state.mcViewer.ssb_cluster).spikeTimesAligned{1, filtTrials});
                spikeTimesAligned = spikeTimesAligned ./ 1000; % convert to seconds
                spikeHist = getSpikeHist(spikeTimesAligned, binEdges);
            end
            spikeHist= spikeHist(1:end -  1);
            spikeHist = spikeHist ./ (state.mcViewer.histBinSize/1000) / length(filtTrials);                   
            set(state.mcViewer.ssb_histLines(i,j),... % one histogram for every row in ssb_cycleTable
                'XData', binEdges(1:end - 1),...
                'YData', spikeHist...
                );

            
            %PSTH
%             allSpikes = spikeTimes;
%             allSpikes(allSpikes < delay/1000 | allSpikes > (delay/1000 + ISI/1000 * nLEDPulses)) = NaN; % ignore spikes before or after pulse train
%             allSpikes = rem(allSpikes, ISI/1000);  % so much of a better way of doing this than I implemented in Igor (not Igor's fault)
%             spikePSTH = histc(allSpikes, 0:1/1000:ISI/1000);
%             spikePSTH = spikePSTH(1:end-1);
%             
%             set(state.mcViewer.ssb_PSTHLines(i,j),... % one histogram for every row in ssb_cycleTable
%                 'XData', 0:1/1000:(ISI/1000 - 1/1000),...
%                 'YData', spikePSTH...
%                 );
        end
    end        
    % function handle to pull out second element of an input
    % use this function handle with cellfun to attain an array of yMax
    % values from the cell array of yLims returned by get    
    getSecond = @(x) x(2);
    % set hist axes to same values    
    set(state.mcViewer.ssb_histAxes, 'YLimMode', 'auto');
    hAxes = get(state.mcViewer.ssb_histAxes, 'YLim');
    if ~iscell(hAxes)
        hAxes = {hAxes};
    end    
    yMax = cellfun(getSecond, hAxes);
    yMax = max(yMax);
    set(state.mcViewer.ssb_histAxes, 'YLim', [0 yMax]);
    
    % set raster axes to same values (minimum yMax in this case)
    set(state.mcViewer.ssb_rasterAxes, 'YLimMode', 'auto');    
    hAxes = get(state.mcViewer.ssb_rasterAxes, 'YLim');
    if ~iscell(hAxes)
        hAxes = {hAxes};
    end
    yMax = cellfun(getSecond, hAxes);
    yMax = min(yMax);
    set(state.mcViewer.ssb_rasterAxes, 'YLim', [0 yMax]);

    mcUpdateSpikeLines;
try
    disp(['Spike Width is ' num2str(state.mcViewer.trode(trode).cluster(state.mcViewer.ssb_cluster).analysis.WaveForm.data.spikeWidth)]);
catch
end
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
%     show_clusters(state.mcViewer.trode(trode).spikes, cluster);
%     if isfield(state.mcViewer.trode(trode).cluster(state.mcViewer.ssb_cluster).analysis, 'WaveForm')...
%             && isfield(state.mcViewer.trode(trode).cluster(state.mcViewer.ssb_cluster).analysis.WaveForm.data, 'spikeWidth')
        
    