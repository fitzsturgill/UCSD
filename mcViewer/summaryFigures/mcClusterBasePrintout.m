function h = mcClusterBasePrintout(trode, cluster, LFPAvg)
    global state

    %     nRows = 2 + (floor(size(state.mcViewer.ssb_cycleTable, 1)/2));
    nRows = 3;
    nColumns = 2;   
    if nargin < 3
        LFPAvg = 0;
        nRows = 2;
    end

    
    prefix = mcExpPrefix;
    pageName = [prefix 'T' num2str(trode) 'C' num2str(cluster) '_P1'];
    
    h = figure('Name', pageName, 'NumberTitle', 'off');
    
    %create axes to hold text identifying experiment, trode, cluster, etc.
    subplot(nRows, nColumns, 1);
    set(gca,'xtick',[],'ytick',[]);
    graphLabel = prefix(1:end-1);
    text(.1, .8, graphLabel,'Units', 'normalized', 'Interpreter', 'none');
    graphLabel = ['Trode: ' state.mcViewer.trode(trode).name ' Cluster: ' num2str(state.mcViewer.trode(trode).cluster(cluster).cluster) ' Label: ' num2str(state.mcViewer.trode(trode).cluster(cluster).label)];
    text(.1,.4,graphLabel,'Units','normalized');
    
    %add waveforms
    fun=state.mcViewer.trode(trode).cluster(cluster).analysis.WaveForm.displayFcnHandle;
    tempFig=figure;
    ax = fun(trode, cluster);
    figure(h); %make target figure current figure
    subplot(nRows, nColumns, 2);
    copyAxis(ax, gca);
    clf(tempFig);
    close(tempFig);
    subplot(nRows, nColumns, 3);    
    plot_isi(state.mcViewer.trode(trode).spikes,state.mcViewer.trode(trode).cluster(cluster).cluster);
    subplot(nRows, nColumns, 4)
    plot_detection_criterion(state.mcViewer.trode(trode).spikes,state.mcViewer.trode(trode).cluster(cluster).cluster);
    
    if LFPAvg
        fun=state.mcViewer.trode(trode).cluster(cluster).analysis.SpikeLFPAverage.displayFcnHandle;
        tempFig=figure;
        ax = fun(trode, cluster, 'h', tempFig);
        figure(h); %make target figure current figure
        subplot(nRows, nColumns, 5)
        copyAxis(ax, gca);
        clf(tempFig);
        close(tempFig);    
    end
        