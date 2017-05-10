function [C, shiftC, rawC, lags] = mcXCorr(unit1, unit2, cycle, x1, x2, maxLag, Fs)
    % C is a vector of the raw crosscorreltion
    % shiftC is the shift predictor
    % rawC is the correted crosscorrelation
    % lags are the x values for the crosscorrelation
    
    % unit1 and unit2 are 2 element vectors of form: [trode cluster]
    % cycle is cycle
    % x1 and x2 are boundaries of time window
    global state
    
    % set Defaults and initialize variables
    if nargin < 6
        maxLag = 250;
    end
    if nargin < 7
        Fs = 0.5;
    end
    
   
    % get cycle vector
    trials = mcTrialsByCycle(cycle);
    
    % initialize output variables in case there are no spikes
    shiftC = zeros(1, 2*Fs*maxLag + 1);
    C = zeros(1, 2*Fs*maxLag + 1);
    rawC = zeros(1, 2*Fs*maxLag + 1);
    lags = zeros(1, 2*Fs*maxLag + 1);
%%     % first assemble uncorrrected xcorr    

    [rawC, lags] = corrFromTrials(trials, trials);
    if isempty(find(lags))
        return
    end
%% Next assemble shift predictor xcorr
    shiftC = zeros(1, 2*Fs*maxLag + 1);
    for i = 1:length(trials)-1
        shiftTrials = circshift(trials, [0 i]);
        [thisC, thisLags] = corrFromTrials(trials, shiftTrials);
        shiftC = shiftC + thisC;
    end
    shiftC = shiftC ./ (length(trials) - 1);
    
%% Now assemble corrected xcorr by subracting shift predictor from raw
    C = rawC - shiftC;
    
    
%% nested function to perform xcorr by blocks of trials    
    function [thisC, thisLags] = corrFromTrials(trials1, trials2)
        thisC = zeros(1, 2*Fs*maxLag + 1);
        thisLags = zeros(1, 2*Fs*maxLag + 1);
        corrCount = 1;
        for I = 1:length(trials)
            trial1 = trials1(I);
            trial2 = trials2(I);

            times1 = state.mcViewer.trode(unit1(1)).cluster(unit1(2)).spikeTimes{1, trial1};
            times1 = times1(times1 > x1 & times1 < x2);
            times2 = state.mcViewer.trode(unit2(1)).cluster(unit2(2)).spikeTimes{1, trial2};
            times2 = times2(times2 > x1 & times2 < x2);
            
            
            if length(times1) > 1 && length(times2) > 1
                [preC, thisLags] = pxCorr(times1, times2, Fs, maxLag);
                thisC = thisC + preC;
                corrCount = corrCount + 1;
            end
        end
        thisC = thisC / corrCount; % average correlation (added 5/10/2017)
    end
end

    
    
    
%     % first assemble uncorrrected xcorr
%     cluster1 = state.mcViewer.trode(trode(1)).cluster(clusterIndex(1)).cluster;
%     spikeIndices1 = mcFiltSpikes(trode(1), 'assigns', cluster1, 'spiketimes_aligned', [x1 x2], 'trials', trials);
%     cluster2 = state.mcViewer.trode(trode(2)).cluster(clusterIndex(2)).cluster;
%     spikeIndices2 = mcFiltSpikes(trode(2), 'assigns', cluster2, 'spiketimes_aligned', [x1 x2], 'trials', trials);
%     
%     spikeTimes1 = state.mcViewer.trode(trode(1)).spikes.unwrapped_times(spikeIndices1);
%     spikeTimes2 = state.mcViewer.trode(trode(2)).spikes.unwrapped_times(spikeIndices2);
%     [cross, lags] = pxcorr(spikeTimes1, spikeTimes2, Fs, maxLag);
%     
%     figure
%     bar(lags*1000,cross,1.0);




