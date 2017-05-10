function saveMUAHistograms(maxY)
    
    global state
    

    if nargin == 0 
        axLim = get(state.mcViewer.ssb_histAxes, 'YLim');
        maxY = max(cellfun(@max, axLim));
        minY = min(cellfun(@min, axLim));        
    else
        minY = 0;
    end
    
    stimBarWidth = 3;
    
    trode = state.mcViewer.ssb_trode;
    clust = state.mcViewer.ssb_cluster;

    
    cycles = state.mcViewer.ssb_cycleTable;
    
    savePath = 'Z:\Fitz\SOM_manuscript\exampleMUA\';
    bl1 = state.mcViewer.bl1/1000;
    bl2 = state.mcViewer.bl2/1000;
    x1 = state.mcViewer.x1/1000;
    x2 = state.mcViewer.x2/1000;
    endX = state.mcViewer.endX/1000;
    
    prefix = mcExpPrefix;
    ax = zeros(size(cycles, 1), 1);
%     params.matpos = [0 0 1 1];
%     params.cellmargin = [0.1 0.1  0.1  0.1 ];
    fontSize = 7;
    screenPosition = [200 200 80 60];
    % in points 8.5 x 11 is 595 x 770
    paperPosition = [200 200 80 60];
    
    for i=1:size(cycles, 1);
        pageName = [prefix 'T' num2str(trode) 'C' num2str(clust) '_MUA_C' num2str(cycles(i, 1)) 'C' num2str(cycles(i, 2))];
        fig = figure('NumberTitle', 'off', 'Name', pageName, 'Units', 'points', 'PaperUnits', 'points');
        set(fig, 'Position', screenPosition, 'PaperPosition', paperPosition);
        
 
        
        %make and format histogram
        ax(i) = mcTrialHistogram(trode, clust, cycles(i, :), fig); % cluster INDEX number
        set(gca, 'FontSize', fontSize, 'YLim', [minY maxY], 'TickDir', 'out'); 
%         xlabel('Time (sec)');
%         ylabel('Spikes/s');
        removeAxesLabels(gca);
        addStimulusBar(gca, [bl1 bl2 1], '', [0.3 0.3 0.3], stimBarWidth);% grey
        addStimulusBar(gca, [x1 x2 1], '', [0 0 0], stimBarWidth);     % black
        

        filepath = [savePath pageName];
        disp(['*** Saving ' filepath ' ***']);
        saveas(fig, filepath, 'fig');
        saveas(fig, filepath, 'epsc');        

    end
        
        