function h = mcClusterCoherencePrintout(trode, clusterInd, cycles)
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
    matpos_clusterAverage=[0 .1 1 .4];
    matpos_clusterCoherence = [0 .55 1 .4];
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Trode:' num2str(trode) ' (' num2str(state.mcViewer.trode(trode).channels) ')' ' Cluster:' num2str(cluster) ' Label:' num2str(clusterLabel) ' Cycles:' num2str(reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)))];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    


%% 2) Trial Histograms, rasters, etc:   By Cycle



    % spike LFP average
    params.cellmargin = [0.05 0.05  0.05  0.05 ];
    params.matpos = matpos_clusterAverage;
    rows = 1;
    columns = size(cycles, 1);    
    if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPAverage')
        fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPAverage.displayFcnHandle;
        axAverage = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed        
        for i = 1:length(axAverage)
            xlabel(axAverage(i), 'time (msec)');
        end            
    end
    setaxesOnaxesmatrix(axAverage, rows, columns, 1:columns, params, h);    
    
    % spike LFP coherence
    params.matpos = matpos_clusterCoherence;
    rows = 1;
    columns = size(cycles, 1);
    if isfield(state.mcViewer.trode(trode).cluster(clusterInd).analysis, 'SpikeLFPCoherence')
        fun=state.mcViewer.trode(trode).cluster(clusterInd).analysis.SpikeLFPCoherence.displayFcnHandle;
        axCoherence = fun(trode, clusterInd, 'h', h, 'cycles', cycles); % axis handle 'a' will be empty if cluster is a garbage cluster label == 4 and is not to be displayed
        for i = 1:length(axCoherence)
            xlabel(axCoherence(i), 'F (Hz)');
            ylabel(axCoherence(i), 'Coherence');
        end
    end
    setaxesOnaxesmatrix(axCoherence, rows, columns, 1:columns, params, h);       
    
    return
    filepath  = [state.mcViewer.filePath pageName];
    saveas(h, filepath, 'pdf');
    saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');
%     disp('*** No Saving Currently in mcClusterBasePrintout2***');
    

    

    


