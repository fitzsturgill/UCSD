function h = mcMultiOdorClusterPrintoutMUA(trode, clusterInd, cycles, reject)
    global state
    
    if nargin < 4
        reject = 0;
    end
    if nargin < 3 || isempty(cycles)
        cycles = state.mcViewer.ssb_cycleTable;
    end
    
    if nargin == 0
        trode = state.mcViewer.ssb_trode;
        clusterInd = state.mcViewer.ssb_cluster;
    end
    cluster = state.mcViewer.trode(trode).cluster(clusterInd).cluster;
    clusterLabel = state.mcViewer.trode(trode).cluster(clusterInd).label;
    
    x1=state.mcViewer.x1/1000;
    x2=state.mcViewer.x2/1000;
    
    prefix = mcExpPrefix;
    pageName = [prefix 'T' num2str(trode) 'C' num2str(clusterInd) '_MUA'];     
    h = figure('Name', pageName, 'NumberTitle', 'off', 'CloseRequestFcn', 'plotWaveDeleteFcn');
    h=mcLandscapeFigSetup(h);
    % title(state.mcViewer.ssb_histAxes(i), [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue)]);
%     mcProcessAnalysis('WaveForm'); %ensure that waveforms are processed

    
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
%     matpos_clusterQuality=[0 .1 1 .2];
    matpos_cluster = [0 .1 1 .9];
    
    
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' MUATrode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel)];
    title_ax = textAxes(h, fig_title, 12);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    
%     %% 1) MUA Quality
%     
%     % plot stability
%     params.matpos = matpos_clusterQuality;
%     params.cellmargin = [.05 .05 0.05 0.05];
%     rows=1;
%     columns=2;    
%     axesmatrix(rows, columns, 1, params, h);    
%     plot_stability(state.mcViewer.trode(trode).spikes,cluster);
%     axHandles = gca;
%     ylabel(gca, '');
    

%% 2) Trial Histograms, rasters, etc:   By Cycle
   
    

%% 2) Trial Histograms, rasters, etc:   By Cycle
    params.matpos = matpos_cluster;
    params.cellmargin = [.04 .04 .03 .03];
    rows = ceil((size(cycles, 1) + 2) / 4);
    columns = 4;
    
    
    
    for i = 1:size(cycles, 1) % number of rows in cycles....

        % Trial Histogram    
        ax2(i) = mcTrialHistogram(trode, clusterInd,cycles(i, :), h, state.mcViewer.ssb_alignHist, reject); % even positions in axes matrix are trial histograms
        set(gca, 'FontSize', 7);        
        xlabel('Time (sec)');
        ylabel('Spikes/s');
        textBox(['Cyc: ' num2str(cycles(i,:))]);
%         addStimulusBar(ax2(3), [bl1 bl2 1], '', state.mcViewer.lineColor{1, 1}, 3);
        addStimulusBar(ax2(i), [x1 x2 1], '', state.mcViewer.lineColor{1, 2}, 3);
    end
    


        %%     % Bar Graph  -   this should be axes 
        ax2(end + 1) = mcShowAnalysis_SpikeRate(trode, clusterInd,'h', h, 'lineColor', {'k', 'r'});
        set(gca, 'FontSize', 7);
        set(ax2(end), 'XTickLabel', {'Baseline' 'Odor'});
        ylabel('Spike Rate (Hz)');
        
        %% scatter plot'
        try
        ax2(end+1) = mcScatterPlot(trode, clusterInd, cycles', h);
        catch
        end
        %% quality
%     % plot stability
%     axes('Parent', h);
%     ax2(end+1) = gca;
%     plot_stability(state.mcViewer.trode(trode).spikes,cluster);
% %     axHandles = gca;
% %     ylabel(gca, '');        
        
        
        
       
    
    setaxesOnaxesmatrix(ax2, rows, columns, 1:length(ax2), params, h);
%     scaleWidth(ax2(3), 2);
%     scaleWidth(ax2(5), 3);
    filepath  = [state.mcViewer.filePath pageName];
%     saveas(h, filepath, 'pdf');
%     saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');
%     disp('*** No Saving Currently in mcMultiOdorClusterPrintout***');
end
    

    

    


