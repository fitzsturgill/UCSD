function mcExportClusterHistogram(trode, cluster, respAlign)
    % exports each cycle as a separate igor text wave
    % bin size determined by state.mcViewer.histBinSize or 200 as default
    % cycles are all unique cycles
    global state
    
    if nargin < 3
        respAlign = 0;
    end
    
    if nargin < 2
        cluster = state.mcViewer.ssb_cluster;
    end
    
    if nargin < 1
        trode = state.mcViewer.ssb_trode;
    end
    
    if state.mcViewer.histBinSize ~= 0
        binSize = state.mcViewer.histBinSize;
    else
        binSize = 200;
    end
    
    % generate wave and/or figure prefix
    prefix = mcExpPrefix;    

    cycles = sort(unique(state.mcViewer.tsCyclePos));
    
    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length

    binEdges = 0:binSize/1000:trialLength; % 200msec bins for histogram
    spikes = state.mcViewer.trode(trode).spikes;    
    waveList = cell(size(cycles));
    for i = 1:length(cycles)
        cycle = cycles(i);
        filtTrials = trialLookup(cycleLookup == cycle);
%         filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials); % element by element comparison
%         spikeTimes = double(spikes.spiketimes(filtInd));
        
        if ~respAlign
            spikeTimes = cat(2, state.mcViewer.trode(trode).cluster(cluster).spikeTimes{1, filtTrials});
            spikeTimes = spikeTimes ./ 1000; % convert to seconds
        else
            spikeTimesAligned = cat(2, state.mcViewer.trode(trode).cluster(cluster).spikeTimesAligned{1, filtTrials});
            spikeTimes = spikeTimesAligned ./ 1000; % convert to seconds
        end
        if state.mcViewer.histWindow == 0
            spikeHist = histc(spikeTimes, binEdges);        
        else
            window = state.mcViewer.histWindow/1000; % convert to seconds
            spikeHist = mcSlidingHistogram(spikeTimes, binEdges, window);
        end
        spikeHist= spikeHist(1:end -  1);
        spikeHist = spikeHist ./ (binSize/1000) / length(find(filtTrials));
        waveo([prefix 'T' num2str(trode) 'C' num2str(cluster) '_c' num2str(cycle) '_Hist'], spikeHist, 'xscale', [0 binSize/1000]);
        waveList{1, i} = [prefix 'T' num2str(trode) 'C' num2str(cluster) '_c' num2str(cycle) '_Hist'];
    end
    mkdir(state.mcViewer.filePath,'analysis'); % make directory if it doesn't already exist

    exportWave(waveList, '', fullfile(state.mcViewer.filePath,'analysis', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_Hist']));
    disp(['***Saving: ' fullfile(state.mcViewer.filePath,'analysis', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_Hist']) '***']);    
        