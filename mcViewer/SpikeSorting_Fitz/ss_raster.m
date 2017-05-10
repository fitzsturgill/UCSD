function h = ss_raster(spikes, category, nPulses)

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
    
    
    h.figure = figure;
    
    clusters = spikes.labels(spikes.labels(:, 2) == catNum, 1)'; %clusters that match category, row vector       

    lineColor = {'b', 'g', 'r', 'm', 'b'};
    gap=.05;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(length(clusters) * nPulses -1))/length(clusters)/nPulses;
    start = 1 - delta - start;
    
    
    trialLength = spikes.info.detect.dur(1);  % assume all trials are equal in length
    binEdges = 0:50/1000:trialLength; %predetermined bins of spacing of 50msec
    
    for i = 1:length(clusters) * nPulses
        disp(['i = ' num2str(i)]);
        pulse = mod(i - 1, nPulses) + 1;
        disp(['pulse = ' num2str(pulse)]);
        clusterInd = ceil(i/nPulses);
        disp(['cluster = ' num2str(clusters(clusterInd))]);
        pulses = mod(spikes.trials - 1, nPulses) + 1;
        filtInd = spikes.assigns == clusters(clusterInd) & pulses == pulse;
        if i == 1 
            h.diff{i} = [];
        else
            h.diff{i} = find(filtInd == oldFiltInd); %debugging- common spikes!!!
        end
        oldFiltInd = filtInd;
        
        h.axes(i) = axes(...       
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [.05 start - (i-1) * (delta + gap) .4 delta],...
            'XLim', [0 trialLength]...j
            );
         h.lines(i) = linecustommarker(spikes.spiketimes(filtInd),spikes.trials(filtInd), [], [], h.axes(i));
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
            'Position', [.55 start - (i-1) * (delta + gap) .4 delta],...
            'XLim', [0 trialLength]...
            );
        for j = 1:nPulses
            pulse = j;
            pulses = mod(spikes.trials - 1, nPulses) + 1;
            filtInd = spikes.assigns == clusters(i) & pulses == pulse;
            spikeHist = histc(spikes.spiketimes(filtInd), binEdges);
            line(binEdges, spikeHist, 'Parent', h.histAxes(i), 'Color', lineColor{min(j, length(lineColor))});
        end
    end
    
%             spikeHist{i, 1}(j,:) = histc(allSpikes, binEdges);
%             line(binEdges, spikeHist{i, 1}(j, :), 'Parent', h.axes(i), 'Color', lineColor{min(j, length(lineColor))});        


% duration = spikes.info.detect.dur(1);    
        
% spikes = 
% 
%              params: [1x1 struct]
%                info: [1x1 struct]
%           waveforms: [16310x15x4 single]
%          spiketimes: [1x16310 single]
%              trials: [1x16310 single]
%     unwrapped_times: [1x16310 single]
%             assigns: [1x16310 single]
%              labels: [6x2 double]
%              
%              
%              spikes.params
% 
% ans = 
% 
%                              Fs: 10000
%                   detect_method: 'auto'
%                          thresh: 3.9000
%                     window_size: 1.5000
%                          shadow: 0.7500
%                      cross_time: 0.6000
%               refractory_period: 2.5000
%                      max_jitter: 0.6000
%                      agg_cutoff: 0.0500
%              kmeans_clustersize: 500
%                         display: [1x1 struct]
%     initial_split_figure_panels: 4
%     
%     
% 
% spikes.info
% 
% ans = 
% 
%               detect: [1x1 struct]
%                  pca: [1x1 struct]
%                align: [1x1 struct]
%               kmeans: [1x1 struct]
%     interface_energy: [32x32 double]
%                 tree: [26x2 double]    