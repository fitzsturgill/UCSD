function h = mc_spikeSortPlots(spikes, category, nPulses, figName)
    global state

    try
        delay = state.mcViewer.pulse.pulseDelay;
        nLEDPulses = state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
    catch
        disp('provide pulse information');
        h = [];
        return
    end
    if ~isnumeric(category)
        catNum = [];
        switch category
            case 'good'
                catNum = 2;
            case 'multiunit'
                catNum = 3;
            case 'garbage'
                catNum = 4;
            otherwise
                disp('incorrect category');
                h = [];
                return
        end

        clusters = spikes.labels(spikes.labels(:, 2) == catNum, 1)'; %clusters that match category, row vector
    else % just plot an individual cluster, the nth cluster as determined by n = category
        clusters = spikes.labels(category, 1);
    end

    h.figure = figure('Name', figName);
    lineColor = {[0 0 0] [1 0 0] [0 1 0] [0 1 1] [1 1 0] [1 0 1] [0 0 1]...
        [0 0 .5] [0 .5 0] [.5 0 0]};    %I can switch up symbols later to include even more clusters (filled vs. non-filled circles for ex.)    
    gap=.05;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(length(clusters) * nPulses -1))/length(clusters)/nPulses;
    start = 1 - delta - start;
    
    
    trialLength = spikes.info.detect.dur(1);  % assume all trials are equal in length
    binEdges = 0:500/1000:trialLength; %predetermined bins of spacing of 50msec
    
    spikeTimes = cell(length(clusters), nPulses);
    spikeTrials = cell(length(clusters), nPulses);
    for i = 1:length(clusters) * nPulses
        disp(['i = ' num2str(i)]);        
        pulse = mod(i - 1, nPulses) + 1;
        disp(['pulse = ' num2str(pulse)]);        
        clusterInd = ceil(i/nPulses);
        disp(['cluster = ' num2str(clusters(clusterInd))]);        

% ------------------------------------------------------
% spikes.assigns and spikes.trials are of same length equal to total number of detected spikes
% bitwise comparison finds indexes of spikes matching cluster and trial
% selected using clusterInd and pulse respectively
        filtInd = spikes.assigns == clusters(clusterInd) & mod(spikes.trials - 1, nPulses) + 1 == pulse; 
% ------------------------------------------------------    
        
        h.axes(i) = axes(...       
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [.05 start - (i-1) * (delta + gap) .2667 delta],...
            'XLim', [0 trialLength]...j
            );
        spikeTimes{clusterInd, pulse} = spikes.spiketimes(filtInd);
        spikeTrials{clusterInd, pulse} = spikes.trials(filtInd);        
        h.lines(i) = linecustommarker(spikeTimes{clusterInd, pulse},spikeTrials{clusterInd, pulse}, [], [], h.axes(i));
        set(h.lines(i), 'Color', lineColor{1, min(pulse, length(lineColor))});
        if i == length(clusters) * nPulses
            set(h.axes(i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
        end
        ylabel(h.axes(i), ['Cluster ' num2str(clusters(clusterInd))]);        
    end
    
%     Add histograms, lets use a separate for-loop from that used to generate rasters for
%     readibility and ease of coding
    gap=.05;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(length(clusters)-1))/length(clusters);
    start = 1 - delta - start;
    for i = 1:length(clusters)
        h.histAxes(i) = axes(...
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [0.3667 start - (i-1) * (delta + gap) 0.2667 delta],...
            'XLim', [0 trialLength]...
            );
        h.PSTHAxes(i) = axes(...
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [0.6834 start - (i-1) * (delta + gap) 0.2667 delta],...
            'XLim', [0 ISI/1000]...
            );
        
        for j = 1:nPulses
            %trial histogram
            spikeHist = histc(spikeTimes{i, j}, binEdges);
            spikeHist = spikeHist(1:end - 1);
            if j<8
                style = '-';
            else
                style = ':';
            end
            line(binEdges(1:end - 1), spikeHist, 'Parent', h.histAxes(i), 'Color', lineColor{min(j, length(lineColor))}, 'LineStyle', style);
            
            %PSTH
            allSpikes = spikeTimes{i, j};
            allSpikes(allSpikes < delay/1000 | allSpikes > (delay/1000 + ISI/1000 * nLEDPulses)) = NaN; % ignore spikes before or after pulse train
            allSpikes = rem(allSpikes, ISI/1000);  % so much of a better way of doing this than I implemented in Igor (not Igor's fault)
            spikePSTH = histc(allSpikes, 0:1/100:ISI/1000);
            spikePSTH = spikePSTH(1:end-1);
            line(0:1/100:(ISI/1000 - 1/100), spikePSTH, 'Parent', h.PSTHAxes(i), 'Color', lineColor{min(j, length(lineColor))}, 'LineStyle', style);
        end
    end