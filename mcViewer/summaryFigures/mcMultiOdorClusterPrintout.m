function h = mcMultiOdorClusterPrintout(trode, clusterInd, cycles)
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
    h=mcPortraitFigSetup(h);
    % title(state.mcViewer.ssb_histAxes(i), [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue)]);
%     mcProcessAnalysis('WaveForm'); %ensure that waveforms are processed

    
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
    matpos_clusterQuality=[0 .1 1 .2];
    matpos_cluster = [0 .3 1 .7];
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Trode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable', 1, numel(state.mcViewer.ssb_cycleTable)))];
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
    try
        axHandles(1) = fun(trode, clusterInd);
    catch
        axHandles(1) = gca;
    end
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
    params.cellmargin = [.04 .04 .03 .03];
    rows = size(cycles,1) + 1;
    columns = 2;
    
    
    
    for i = 0:size(cycles, 1) - 1 % number of rows in cycles....
        % raster 
        ax2(1 + i*2)=mcMakeRaster(trode, cluster, cycles(i+1, :), h);  %odd positions in axes matrix are rasters
        set(gca, 'FontSize', 7);
        xlabel('time (sec)');
        x1=state.mcViewer.x1/1000;
        x2=state.mcViewer.x2/1000;
%         bl1=state.mcViewer.bl1/1000;
%         bl2=state.mcViewer.bl2/1000;
        Ymax=get(ax2(1 + i*2), 'YLim');
        Ymax=Ymax(2);

%         addStimulusBar(ax2(1 + i*2), [bl1 bl2 Ymax], '', state.mcViewer.lineColor{1, 1}, 3);
        addStimulusBar(ax2(1 + i*2), [x1 x2 Ymax], '', state.mcViewer.lineColor{1, 2}, 3);
        set(ax2(1 + i*2), 'XLim', [0 state.mcViewer.endX / 1000]);




        % Trial Histogram    
        ax2(2 + i*2) = mcTrialHistogram(trode, clusterInd,cycles(i+1, :), h, state.mcViewer.ssb_alignHist); % even positions in axes matrix are trial histograms
        set(gca, 'FontSize', 7);        
        xlabel('Time (sec)');
        ylabel('Spikes/s');
%         addStimulusBar(ax2(3), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
        addStimulusBar(ax2(2+i*2), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);
    end
    
%     % kludge for figure
%     for i=1:length(ax2)
%         set(ax2(i), 'XLim', [6 15]);
%     end


        %     % Bar Graph  -   this should be axes 
%         ax2(end + 1) = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h, 'lineColor', {'k', 'r'});
        ax2(end + 1) = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h);        
        set(gca, 'FontSize', 7);
        set(ax2(end), 'XTickLabel', {'Baseline' 'Odor'});
        ylabel('Spike Rate (Hz)');
        
       
    
    setaxesOnaxesmatrix(ax2, rows, columns, [1:length(ax2)], params, h);
%     scaleWidth(ax2(3), 2);
%     scaleWidth(ax2(5), 3);
    filepath  = [state.mcViewer.filePath pageName];
%     saveas(h, filepath, 'pdf');
%     saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');
%     disp('*** No Saving Currently in mcMultiOdorClusterPrintout***');
end
    
function scaleWidth(ax, scaleFactor)
    % rememer: [left bottom width height] for position property
    pos=get(ax, 'Position');
    pos(3) = pos(3) * scaleFactor;
    set(ax, 'Position', pos);
end

% function ylabel(s)
%     ylabel(s, 'FontSize', 7);
    

    


