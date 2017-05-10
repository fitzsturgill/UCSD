function h = mcPSTHPrintout(cycles)
    global state
    
    if nargin < 1
        cycles = state.mcViewer.ssb_cycleTable(1, :);
    end
    
    

    
    prefix = mcExpPrefix;
    pageName = [prefix 'LEDpulse_PSTH'];     
    h = figure('Name', pageName, 'NumberTitle', 'off');
    h=mcLandscapeFigSetup(h);
    % title(state.mcViewer.ssb_histAxes(i), [mcExpPrefix ' Trode:' num2str(state.mcViewer.ssb_trode) ' Cluster:' num2str(state.mcViewer.ssb_clusterValue)]);
%     mcProcessAnalysis('WaveForm'); %ensure that waveforms are processed

    
%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
    matpos_title=[0 0 1 .1]; 
    matpos_body=[0 .1 1 .9];
    params.cellmargin = [.05 .05 0.05 0.05];
    
    
    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = pageName;
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    


%% 2) Trial Histograms, rasters, etc:   By Cycle
    params.matpos = matpos_body;
    rows = 1;
    columns = 4;
    
    
    axes=[];
    for trode=1:length(state.mcViewer.trode)
        axes(end+1) = mcTrialPSTH(trode, 0, cycles, h);
        title(['Trode' num2str(trode) ': MUA']);
        set(gca, 'Color', [.9 .9 1]);
        for cluster = 1:length(state.mcViewer.trode(trode).cluster)
            if any(state.mcViewer.trode(trode).cluster(cluster).label == [2 3])  % if either a good or multiunit cluster ....
                axes(end+1) = mcTrialPSTH(trode, cluster, cycles, h);
                title(['Trode: ' num2str(trode) ', Cluster: ' num2str(state.mcViewer.trode(trode).cluster(cluster).cluster) ', Label: ' num2str(...
                    state.mcViewer.trode(trode).cluster(cluster).label)]);
            end
        end
    end
    
    columns = 4;
    rows = ceil(length(axes) / 4);

    
    setaxesOnaxesmatrix(axes, rows, columns, 1:length(axes), params, h);

    

    


