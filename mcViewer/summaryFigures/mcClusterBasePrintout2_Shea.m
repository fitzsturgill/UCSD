function h = mcClusterBasePrintout2_Shea(trode, clusterInd, cycles)
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
    matpos_cluster = [0 .3 1 .7];
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Trode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)))];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix_old(title_ax, 1, 1, 1, params, h);
    
    %% 1) Cluster Quality
    params.matpos = matpos_clusterQuality;
    params.cellmargin = [.05 .05 0.05 0.05];
    rows=1;
    columns=4;
    %plot waveforms
%     axesmatrix(1, 4, 1, [], h);
    axes; % because waveform plots on gcf, this avoids writing over titel axis
    fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.WaveForm.displayFcnHandle;
    axHandles(1) = fun(trode, clusterInd);
    setaxesOnaxesmatrix_old(axHandles(1), rows, columns, 1, params, h);
    txt=get(get(axHandles(1), 'YLabel'), 'String');
    ylabel(axHandles(1), '');
    title(axHandles(1), txt);
    
    
    %plot isi    
    axesmatrix(rows, columns, 2, params, h);
    plot_isi(state.mcViewer.trode(trode).spikes,cluster);
    axHandles(2) = gca;
    txt=get(get(axHandles(2), 'YLabel'), 'String');
    ylabel(axHandles(2), '');
    title(axHandles(2), txt);
    
    % plot spike detection criterion
    axesmatrix(rows, columns, 3, params, h);    
    plot_detection_criterion(state.mcViewer.trode(trode).spikes,cluster);
    axHandles(3) = gca;
    ylabel(axHandles(3), '');
    
    % plot stability
    axesmatrix(rows, columns, 4, params, h);    
    plot_stability(state.mcViewer.trode(trode).spikes,cluster);
    axHandles(4) = gca;
    ylabel(axHandles(4), '');
    

%% 2) Trial Histograms, rasters, etc:   By Cycle
    params.matpos = matpos_cluster;
    rows = 2;
    columns = 4;
    
    % raster 
    ax2(1)=mcMakeRaster(trode, cluster, cycles, h);
    xlabel('time (sec)');
    x1=state.mcViewer.x1/1000;
    x2=state.mcViewer.x2/1000;
    bl1=state.mcViewer.bl1/1000;
    bl2=state.mcViewer.bl2/1000;
    Ymax=get(ax2(1), 'YLim');
    Ymax=Ymax(2);
    
    addStimulusBar(ax2(1), [bl1 bl2 Ymax], '', state.mcViewer.lineColor{1, 1}, 3);
    addStimulusBar(ax2(1), [x1 x2 Ymax], '', state.mcViewer.lineColor{1, 2}, 3);    
    
    
%     % Bar Graph
    ax2(2) = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h);
    set(ax2(2), 'XTickLabel', {'Baseline' 'Odor'});
    ylabel('Spike Rate (Hz)');
    % THIS:
%     Trial Histogram    
    ax2(3) = mcTrialHistogram(trode, clusterInd,cycles, h, state.mcViewer.ssb_alignHist);
    xlabel('Time (sec)');
    addStimulusBar(ax2(3), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
    addStimulusBar(ax2(3), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);    
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



    % spike LFP average
    if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPAverage')
        fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPAverage.displayFcnHandle;
        a = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
        ax2(4) = a;
        xlabel('time (msec)');
    end
    
    % spike LFP coherence
    if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPCoherence')
        fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPCoherence.displayFcnHandle;
        a = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
        ax2(5) = a;
        xlabel('F (Hz)');
        ylabel('Coherence');
    end
    
    % hilbert transform
        fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.HilbertTransform.displayFcnHandle;
        a = fun(trode, clusterInd, 'h', h, 'cycles', cycles, 'threshold', .8); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
        ax2(6) = a;
        xlabel('Phase (r)');
        ylabel('Spike Count');    
    
    
    setaxesOnaxesmatrix_old(ax2, 2, 4, [1:3 5:7], params, h);
%     scaleWidth(ax2(3), 2);
%     scaleWidth(ax2(5), 3);
%     return
    filepath  = [state.mcViewer.filePath pageName];
%     saveas(h, filepath, 'pdf');
%     saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');
%     disp('*** No Saving Currently in mcClusterBasePrintout2***');
    
    function scaleWidth(ax, scaleFactor)
        % rememer: [left bottom width height] for position property
        pos=get(ax, 'Position');
        pos(3) = pos(3) * scaleFactor;
        set(ax, 'Position', pos);
    

    


