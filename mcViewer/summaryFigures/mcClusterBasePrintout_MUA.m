function h = mcClusterBasePrintout_MUA(trode, clusterInd, cycles)
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
    pageName = [prefix 'T' num2str(trode) 'C' num2str(clusterInd) '_MUA'];     
    h = figure('Name', pageName, 'NumberTitle', 'off', 'CloseRequestFcn', 'plotWaveDeleteFcn');
    h=mcLandscapeFigSetup(h);
    % title(state.mcViewer.ssb_histAxes(i), [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue)]);
%     mcProcessAnalysis('WaveForm'); %ensure that waveforms are processed

    
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
    matpos_clusterQuality=[0 .1 1 .2];
    matpos_Hist = [0 .3 .7 .7];
    matpos_barGraph = [.7 .3 .3 .7];
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' MUATrode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)))];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    
    %% 1) MUA Quality
    
    % plot stability
    params.matpos = matpos_clusterQuality;
    params.cellmargin = [.05 .05 0.05 0.05];
    rows=1;
    columns=2;    
    axesmatrix(rows, columns, 1, params, h);    
    plot_stability(state.mcViewer.trode(trode).spikes,cluster);
    axHandles = gca;
    ylabel(gca, '');
    

%% 2) Trial Histograms, rasters, etc:   By Cycle
    
    % raster 
    axHist(1)=mcMakeRaster(trode, cluster, cycles, h);
    xlabel('time (sec)');
    x1=state.mcViewer.x1/1000;
    x2=state.mcViewer.x2/1000;
    bl1=state.mcViewer.bl1/1000;
    bl2=state.mcViewer.bl2/1000;
    Ymax=get(axHist(1), 'YLim');
    Ymax=Ymax(2);
    
    addStimulusBar(axHist(1), [bl1 bl2 Ymax], '', state.mcViewer.lineColor{1, 1}, 3);
    addStimulusBar(axHist(1), [x1 x2 Ymax], '', state.mcViewer.lineColor{1, 2}, 3);    
    
    
%     % Bar Graph
    axBar = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h);
    set(axBar, 'XTickLabel', {'Baseline' 'Odor'});
    ylabel('Spike Rate (Hz)');
    % THIS:
    % Trial Histogram    
    axHist(2) = mcTrialHistogram(trode, clusterInd,cycles, h, state.mcViewer.ssb_alignHist);
    xlabel('Time (sec)');
    addStimulusBar(axHist(2), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
    addStimulusBar(axHist(2), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);    
    % OR THIS:
    % Spike Rate per Respiration Cycle Plot
%     fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikesByCycle.displayFcnHandle;
%     respAxes = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
%     cla(respAxes(1,2)); %delete phase axis for now...,
%     delete(respAxes(1,2));
%     ax2(3) = respAxes(1,1); 
%     xlabel('Avg Time of Respiration Cycle (sec)');
%     addStimulusBar(ax2(3), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
%     addStimulusBar(ax2(3), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);   

    
    % set raster and hist on first axes matrix
    params.matpos = matpos_Hist;    
    setaxesOnaxesmatrix(axHist, 2, 1, 1:2, params, h);
    
    % set bar graph on second axes matrix
    params.matpos = matpos_barGraph;
    setaxesOnaxesmatrix(axBar, 1, 1, 1, params, h);
    
    filepath  = [state.mcViewer.filePath pageName];
    saveas(h, filepath, 'pdf');
    saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');


    


