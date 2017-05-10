function saveRastersAndHistograms_for_exampleCell(histYMax)
    
    global state
    if nargin == 0
        histYMax = 20;
    end
    
    trode = state.mcViewer.ssb_trode;
    clust = state.mcViewer.ssb_cluster;
    cluster = state.mcViewer.ssb_clusterValue;
    
    cycles = state.mcViewer.ssb_cycleTable;
    
    savePath = 'Z:\Fitz\SOM_manuscript\vector_files_and_data\exampleCells\excludedUnits_forReviewers\';
    bl1 = state.mcViewer.bl1/1000;
    bl2 = state.mcViewer.bl2/1000;
    x1 = state.mcViewer.x1/1000;
    x2 = state.mcViewer.x2/1000;
    endX = state.mcViewer.endX/1000;
    
    prefix = mcExpPrefix;
    ax = zeros(size(cycles, 1), 2);
    params.matpos = [0 0 1 1];
    params.cellmargin = [0.1 0.1  0.1  0.1 ];
    fontSize = 7;
    screenPosition = [200 200 120 60];
    % in points 8.5 x 11 is 595 x 770
    paperPosition = [200 200 120 60];
    
    for i=1:size(cycles, 1);
        pageName = [prefix 'T' num2str(trode) 'C' num2str(clust) '_C' num2str(cycles(i, 1)) 'C' num2str(cycles(i, 2))];
        fig = figure('NumberTitle', 'off', 'Name', pageName, 'Units', 'points', 'PaperUnits', 'points');
        set(fig, 'Position', screenPosition, 'PaperPosition', paperPosition);
        
        %make and format raster
%         ax(i, 1) = mcMakeRaster(trode, cluster, cycles(i, :), fig); % cluster number
        ax(i, 1) = mcMakeRaster(trode, cluster, cycles(i, :), fig, 1); % cluster number
        set(gca, 'FontSize', fontSize, 'TickDir', 'out');
%         xlabel('time (sec)');
        yLims=get(gca, 'YLim');
        Ymax=yLims(2);
        stimBarWidth = 3;
%         addStimulusBar(gca, [bl1 bl2 Ymax], '', [0.3 0.3 0.3], stimBarWidth); % grey
%         addStimulusBar(gca, [x1 x2 Ymax], '', [0 0 0], stimBarWidth); % black
        set(gca, 'XLim', [0 endX]);
        removeAxesLabels(gca);
        
        %make and format histogram
        ax(i, 2) = mcTrialHistogram(trode, clust, cycles(i, :), fig); % cluster INDEX number
        set(gca, 'FontSize', fontSize, 'YLim', [0 histYMax], 'TickDir', 'out'); 
%         xlabel('Time (sec)');
%         ylabel('Spikes/s');
        removeAxesLabels(gca);
        addStimulusBar(gca, [bl1 bl2 1], '', [0.3 0.3 0.3], stimBarWidth);% grey
        addStimulusBar(gca, [x1 x2 1], '', [0 0 0], stimBarWidth);     % black
        
        setaxesOnaxesmatrix(ax(i, :), 1, 2, 1:2, params, fig);
        filepath = [savePath pageName];
        disp(['*** Saving ' filepath ' ***']);
        saveas(fig, filepath, 'fig');
        saveas(fig, filepath, 'epsc');        

    end
        

        