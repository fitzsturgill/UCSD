
function ax=mcMakeRaster(trode, cluster, cycles, fig, reject)
    global state
    

    lineColor = state.mcViewer.lineColor;
    % generate wave and/or figure prefix
    prefix = mcExpPrefix;
 
    
    if nargin == 0 
        trode = state.mcViewer.ssb_trode;
        cluster = state.mcViewer.ssb_clusterValue;
    end
    
    if nargin < 3
        cycles = state.mcViewer.ssb_cycleTable;
    end

    if nargin < 4 || isempty(fig)
        fig = figure(...
            'Name', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_raster']...
            );
    else
        figure(fig); % bring figure to front and make current figure
    end    

    if nargin < 5
        reject = 0;
    end
    % kludge
%     reject = 1;
    %

    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length
    
%     spikeTimes = cell(length(cycles));
%     spikeTrials = cell(length(cycles));
    rasterLines=zeros(size(cycles));
    spikes = state.mcViewer.trode(trode).spikes;
    ax=axes(...
        'Parent', fig,...
        'YDir', 'reverse'...
        );
    startY = 1;
    trialCount=0;
    cycles=cycles';
    for i = 1:numel(cycles)
        cycle = cycles(i);
        filtTrials =  mcTrialsByCycle(cycle, reject);
        filtTrials = filtTrials(filtTrials <= 140); % kludge for figure making...
        filtInd = spikes.assigns == cluster & ismember(spikes.trials, filtTrials); % element by element comparison
        spikeTimes = double(spikes.spiketimes(filtInd));
        
        %deinterlace spike trials such that instead of 1:2:9 trials are 1:5
        %and for 2:2:10 trials are 6:10 *** this separates conditions on
        %the raster
        spikeTrials=double(spikes.trials(filtInd));        
        uniqueTrials = sort(unique(filtTrials));
        nTrials = length(uniqueTrials);
        trialCount = trialCount + nTrials;
        allY = startY:startY+nTrials-1;
        startY=startY+nTrials; %new startY for next interation
        oldSpikeTrials=spikeTrials;
        for j=1:nTrials
            spikeTrials(oldSpikeTrials == uniqueTrials(j)) = allY(j);
        end
        
        % in case there are no spikes give something to plot
        if isempty(spikeTimes)
            spikeTimes = 0;
            spikeTrials = 0;
        end
        
        rasterLines(i) = linecustommarker(spikeTimes, spikeTrials, [], [], ax);
        lineColorIndex = mod(i, length(lineColor));
        if lineColorIndex == 0
            lineColorIndex = length(lineColor);
        end
        set(rasterLines(i), 'Color', lineColor{lineColorIndex});
        %%
%         disp('kludge in mcMakeRaster, using alternating black and red');
%         if rem(i, 2)
%             set(rasterLines(i), 'Color', 'k');
%         else
%             set(rasterLines(i), 'Color', 'r');
%         end
        %%
    end
       set(ax, 'YLim', [0 trialCount]); % some room for stimulus bars
    