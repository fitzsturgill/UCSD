function h = mcClusterPrintout_4odors_LaserMUA(trode, clusterInd, cycles)
    global state
    
    if nargin < 3
        cycles = state.mcViewer.ssb_cycleTable;
    end
    
    if nargin == 0
        trode = state.mcViewer.ssb_trode;
        clusterInd = state.mcViewer.ssb_cluster;
    end
    cluster = state.mcViewer.trode(trode).cluster(clusterInd).cluster;
    clusterLabel = state.mcViewer.trode(trode).cluster(clusterInd).label;
    
    prefix = mcExpPrefix;
    pageName = [prefix 'T' num2str(trode) 'C' num2str(clusterInd) '_P1'];     
    h = figure('Name', pageName, 'NumberTitle', 'off', 'CloseRequestFcn', 'plotWaveDeleteFcn');
    h=mcLandscapeFigSetup(h);
    % title(state.mcViewer.ssb_histAxes(i), [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue)]);
%     mcProcessAnalysis('WaveForm'); %ensure that waveforms are processed

    
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
    matpos_clusterQuality=[0 .1 1 .2];

    

    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Trode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)))];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    
%     %% 1) Cluster Quality
%     params.matpos = matpos_clusterQuality;
%     params.cellmargin = [.05 .05 0.05 0.05];
%     rows=1;
%     columns=4;
%     %plot waveforms
% %     axesmatrix(1, 4, 1, [], h);
%     axes; % because waveform plots on gcf, this avoids writing over titel axis
%     fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.WaveForm.displayFcnHandle;
%     axHandles(1) = fun(trode, clusterInd);
%     setaxesOnaxesmatrix(axHandles(1), rows, columns, 1, params, h);
%     txt=get(get(axHandles(1), 'YLabel'), 'String');
%     ylabel(axHandles(1), '');
%     title(axHandles(1), txt);
%     
%     
%     %plot isi    
%     axesmatrix(rows, columns, 2, params, h);
%     plot_isi(state.mcViewer.trode(trode).spikes,cluster);
%     axHandles(2) = gca;
%     txt=get(get(axHandles(2), 'YLabel'), 'String');
%     ylabel(axHandles(2), '');
%     title(axHandles(2), txt);
%     
%     % plot spike detection criterion
%     axesmatrix(rows, columns, 3, params, h);    
%     plot_detection_criterion(state.mcViewer.trode(trode).spikes,cluster);
%     axHandles(3) = gca;
%     ylabel(axHandles(3), '');
%     
%     % plot stability
%     axesmatrix(rows, columns, 4, params, h);    
%     plot_stability(state.mcViewer.trode(trode).spikes,cluster);
%     axHandles(4) = gca;
%     ylabel(axHandles(4), '');
    

%% 2) Trial Histograms, rasters, etc:   By Cycle-   only works for up to 7
%% pairs/sets of cycles to be grouped together
    % create two rows of raster, histogram pairs, second row is only 3/4
    % width of page
    % finally allocate the bottom right part of the layout for the bar
    % graph
    % these heights must add up to 0.35
    hRaster = 0.1;
    hHist = 0.25;
%     hHist = 0.225;
%                  params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].    
    matpos_raster1 = [0 .3 1 hRaster];
    matpos_hist1 = [0 (0.3 + hRaster) 1 hHist];
    matpos_raster2 = [0 (0.3 + hRaster + hHist) 0.75 hRaster];
    matpos_hist2 = [0 (0.3 + hRaster*2 + hHist) 0.75 hHist];
    % kludge- I'm setting barGraph to overlap hist2 and raster2 boundaries
    matpos_barGraph = [0.5 (0.3 + hRaster + hHist) 0.5 (hRaster + hHist)];    
%     matpos_raster1 = [0 .3 1 hRaster];
%     matpos_hist1 = [0 (0.3 + hRaster) 1 hHist];
%     matpos_raster2 = [0 (0.3 + hRaster + hHist + 0.025) 0.75 hRaster];
%     matpos_hist2 = [0 (0.3 + hRaster*2 + hHist + 0.025) 0.75 hHist];
%     matpos_barGraph = [0.75 (0.3 + hRaster + hHist + 0.025) 0.25 (hRaster + hHist)];
    %  **********   setting cellmargin here!!!
    params.cellmargin = [0 0 0  0 ];

    
    histYMax = 0; % figure out what the  ymax is over all histograms and scall all according to common ymax
    histLim=[0 0];
    % raster, first 4 cycle pairs/groups
    for i = 1:(min(size(cycles, 1), 4))
        axRaster1(i)=mcMakeRaster(trode, cluster, cycles(i, :), h);
        % get rid of lines and labels
%         axis(axRaster1(i), 'off');
        set(axRaster1(i), 'YTick', []);
        set(axRaster1(i), 'YTickLabel', {''});
        
        % add baseline and odor bars
        x1=state.mcViewer.x1/1000;
        x2=state.mcViewer.x2/1000;
        bl1=state.mcViewer.bl1/1000;
        bl2=state.mcViewer.bl2/1000;
        Ymax=get(axRaster1(i), 'YLim');
        Ymax=Ymax(2);
        addStimulusBar(axRaster1(i), [bl1 bl2 Ymax], '', state.mcViewer.lineColor{1, 1}, 3);
        addStimulusBar(axRaster1(i), [x1 x2 Ymax], '', state.mcViewer.lineColor{1, 2}, 3);
    end
    params.matpos = matpos_raster1;
    setaxesOnaxesmatrix(axRaster1, 1, 4, 1:length(axRaster1), params, h, 1);
        
    
    
    % histogram, first 4 cycle pairs/groups
    for i = 1:(min(size(cycles, 1), 4))
        axHist1(i) = mcTrialHistogram(trode, clusterInd,cycles(i, :), h, state.mcViewer.ssb_alignHist);
        xlabel('Time (sec)');
%         addStimulusBar(axHist1(i), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 1);
%         addStimulusBar(axHist1(i), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 1);
        Ymax=get(axHist1(i), 'YLim');
        if Ymax(2) > histYMax
            histYMax = Ymax(2);
        end
        if i == 1
            histLim = get(axHist1(i), 'XLim'); % use for correcting raster plot xlim
        end
    end
    params.matpos = matpos_hist1;
%     params.cellmargin = [0.025 0.025  0  0 ];
    setaxesOnaxesmatrix(axHist1, 1, 4, 1:length(axRaster1), params, h, 1);
    
    % raster, last 5+ cycle pairs/groups
    if size(cycles, 1) > 4
        rowIndices = 5:size(cycles, 1);
        for i = 1:length(rowIndices)
            axRaster2(i)=mcMakeRaster(trode, cluster, cycles(rowIndices(i), :), h);
            % get rid of lines and labels
%             axis(axRaster2(i), 'off');
            set(axRaster2(i), 'YTick', []);
            set(axRaster2(i), 'YTickLabel', {''});
            % add baseline and odor bars
            x1=state.mcViewer.x1/1000;
            x2=state.mcViewer.x2/1000;
            bl1=state.mcViewer.bl1/1000;
            bl2=state.mcViewer.bl2/1000;
            Ymax=get(axRaster2(i), 'YLim');
            Ymax=Ymax(2);
            addStimulusBar(axRaster2(i), [bl1 bl2 Ymax], '', state.mcViewer.lineColor{1, 1}, 3);
            addStimulusBar(axRaster2(i), [x1 x2 Ymax], '', state.mcViewer.lineColor{1, 2}, 3);
        end
        params.matpos = matpos_raster2;
%         params.cellmargin = [0.025 0.025  0  0 ];
        setaxesOnaxesmatrix(axRaster2, 1, 3, 1:length(axRaster2), params, h, 1);
    
    
        % histogram, last 5+ cycle pairs/groups
        for i = 1:length(rowIndices)
            axHist2(i) = mcTrialHistogram(trode, clusterInd,cycles(rowIndices(i), :), h, state.mcViewer.ssb_alignHist);
            xlabel('Time (sec)');
%             addStimulusBar(axHist2(i), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 1);
%             addStimulusBar(axHist2(i), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 1);
            Ymax=get(axHist2(i), 'YLim');
            if Ymax(2) > histYMax
                histYMax = Ymax(2);
            end
        end
        params.matpos = matpos_hist2;
%         params.cellmargin = [0.025 0.025  0  0 ];
        setaxesOnaxesmatrix(axHist2, 1, 3, 1:length(axHist2), params, h, 1);
    else
        axHist2=[];
    end
    
    set([axHist1 axHist2], 'YLim', [0 histYMax]); % set all histograms to global maximum
    set([axRaster1 axRaster2], 'XLim', histLim);
    
    
    
    
%     % Bar Graph
    axBarGraph = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h);
    set(axBarGraph, 'XTickLabel', {'Baseline' 'Odor'});
    ylabel('Spike Rate (Hz)');
    params.matpos = matpos_barGraph;
    setaxesOnaxesmatrix(axBarGraph, 1, 1, 1, params, h, 1);
    % THIS:
%     Trial Histogram    

%     % OR THIS:
    % Spike Rate per Respiration Cycle Plot
%     fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikesByCycle.displayFcnHandle;
%     respAxes = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
%     cla(respAxes(1,2)); %delete phase axis for now...,
%     delete(respAxes(1,2));
%     ax2(3) = respAxes(1,1); 
%     xlabel('Avg Time of Respiration Cycle (sec)');
%     addStimulusBar(ax2(3), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
%     addStimulusBar(ax2(3), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);   



%     % spike LFP average
%     if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPAverage')
%         fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPAverage.displayFcnHandle;
%         a = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
%         ax2 = [ax2 a];
%         xlabel('time (msec)');
%     end
%     
%     % spike LFP coherence
%     if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPCoherence')
%         fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPCoherence.displayFcnHandle;
%         a = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
%         ax2(5) = a;
%         xlabel('F (Hz)');
%         ylabel('Coherence');
%     end
%     
    
%     setaxesOnaxesmatrix(ax2, 2, 4, [1:3 5 6], params, h);
%     scaleWidth(ax2(3), 2);
%     scaleWidth(ax2(5), 3);
    
    filepath  = [state.mcViewer.filePath pageName];
%     saveas(h, filepath, 'pdf');
%     saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig'); % saving as fig shouldn't crash matlab
%     disp('*** No Saving Currently in mcClusterBasePrintout2***');
    
    function scaleWidth(ax, scaleFactor)
        % rememer: [left bottom width height] for position property
        pos=get(ax, 'Position');
        pos(3) = pos(3) * scaleFactor;
        set(ax, 'Position', pos);
    

    


