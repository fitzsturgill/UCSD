function mcShowAllWaveForms
    global state
    prefix = mcExpPrefix;
    pageName = [prefix 'allWaveForms'];
    h = figure('Name', pageName, 'NumberTitle', 'off');
    h=mcLandscapeFigSetup(h);
    ax = [];
    for i = 1:length(state.mcViewer.trode)
        for j = 1:length(state.mcViewer.trode(i).cluster)
            if ismember(state.mcViewer.trode(i).cluster(j).label, [2 3])
                ax(end + 1) = axes;
                mcShowAnalysis_WaveForm(i, j);
            end
        end
    end
    
    splayAxisTile;