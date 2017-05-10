function ax=mcTrialHistogram(trode, cluster, cycles, fig, respAlign, reject)
    global state
    
    if nargin < 6
        reject = 0;
    end
    % kludge
    reject = 1;
    %

    
    if nargin < 5 || isempty(respAlign)
        respAlign=0;
    end
    
    if nargin < 4 || isempty(fig)                
        prefix = mcExpPrefix;
        fig = figure(...
            'Name', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_Hist']...
            );
    end
    
    
    if state.mcViewer.histBinSize ~= 0
        binSize = state.mcViewer.histBinSize;
    else
        binSize = 200;
    end
    
    if size(cycles, 1) > 1
        cycles = cycles';
    end
    lineColor=state.mcViewer.lineColor;
%     cycleLookup = state.mcViewer.tsCyclePos;
%     trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length

    binEdges = 0:binSize/1000:trialLength; % 200msec bins for histogram
    spikes = state.mcViewer.trode(trode).spikes;    
    
    ax = axes(...
        'Parent', fig,...
        'XLim', [0 trialLength]...
        );    

    textBox(['cyc:' num2str(reshape(cycles, 1, numel(cycles)))]);
    for i = 1:length(cycles);
        cycle = cycles(i);
%         filtTrials = trialLookup(cycleLookup == cycle);

        filtTrials = mcTrialsByCycle(cycle, reject);
%         filtTrials = filtTrials(filtTrials <= 140);
        
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
            span = round(state.mcViewer.histWindow / state.mcViewer.histBinSize);
            if rem(span, 2) == 0
                span = span - 1;
            end
            method = 'moving';
%             method = 'sgolay';
            spikeHist = mcSmoothedHistogram(spikeTimes, binEdges, span, method);
%             window = state.mcViewer.histWindow/1000; % convert to seconds
%             spikeHist = mcSlidingHistogram(spikeTimes, binEdges, window);
        end
        spikeHist= spikeHist(1:end -  1);
        spikeHist = spikeHist ./ (binSize/1000) / length(find(filtTrials));
       
        lineColorIndex = mod(i, length(lineColor));
        if lineColorIndex == 0
            lineColorIndex = length(lineColor);
        end
%         %% kludge, normalize for figure- see fixPirC22_baselines for
%         %% rationale
%         if cycle == 5
%             spikeHist=spikeHist .* 0.6901;
%         elseif cycle == 10
%             spikeHist = spikeHist .* 1.3018
%         end
            
        histLines(i) = line(... 
            binEdges(1:end - 1),...
            spikeHist,...
            'Parent', ax,...
            'Color', lineColor{lineColorIndex}...
            );
    end