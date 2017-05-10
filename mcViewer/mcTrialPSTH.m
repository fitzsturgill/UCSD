function ax=mcTrialPSTH(trode, cluster, cycles, fig)
    global state
    % requires a pulse train with evenly spaced pulses
    
    % for MUA set cluster == 0
    

    
    if nargin < 3
        cycles = sort(unique(state.mcViewer.tsCyclePos));
    end
    
    if nargin < 2
        cluster = state.mcViewer.ssb_cluster;
    end
    
    if nargin < 1
        trode = state.mcViewer.ssb_trode;
    end
    
    if nargin < 4 || isempty(fig)                
        prefix = mcExpPrefix;
        fig = figure(...
            'Name', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_Hist']...
            );
    end
    
    try
        delay = state.mcViewer.pulse.pulseDelay;
        nPulses = state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
    catch
        disp('Error in mcTrialPSTH: provide pulse information via pulse mcViewer structure field');
        return
    end
    
    binSize = 1;
    lineColor=state.mcViewer.lineColor;
    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    
    trialLength = state.mcViewer.trode(trode).spikes.info.detect.dur(1); % assume all trials are equal in length

%     binEdges = 0:binSize/1000:trialLength; % 200msec bins for histogram
    spikes = state.mcViewer.trode(trode).spikes;    
    
    ax = axes(...
        'Parent', fig...
        );    
        cycles=cycles';
    for i = 1:numel(cycles)
        cycle = cycles(i);
        filtTrials = trialLookup(cycleLookup == cycle);
        filtInd = ismember(spikes.trials, filtTrials); % element by element comparison
%         spikeTimes = double(spikes.spiketimes(filtInd));
        if cluster == 0 % kludge for recreating MUA- all spikes....
            spikeTimes = double(spikes.spiketimes(filtInd))* 1000 * 10 - 1/state.mcViewer.sampleRate * 10; % taken from ss_makeClusterStructure
            spikeTimes = round(spikeTimes)/10;     % taken from ss_makeClusterStructure
        else
            spikeTimes = cat(2, state.mcViewer.trode(trode).cluster(cluster).spikeTimes{1, filtTrials}); % spike times in msec
        end
        % convert to PSTH w.r.t LED pulses here...    
        spikeTimes = spikeTimes(spikeTimes > delay & spikeTimes < (delay + ISI * nPulses));  % get rid of spikes adjacent to pulse train
        spikeTimes = spikeTimes - delay; % subtract off delay
        spikeTimes = rem(spikeTimes, ISI); %
        binEdges = 0:1:ISI;
        
        spikeHist = histc(spikeTimes, binEdges);        
%         spikeHist = spikeHist ./ (binSize/1000) / length(find(filtTrials)); 

        histLines(i) = line(... 
            binEdges,...
            spikeHist,...
            'Parent', ax,...
            'Color', lineColor{min(i, length(lineColor))}...
            );
    end