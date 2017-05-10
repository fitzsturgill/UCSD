function mcPlotWaveform(trode, clust, fig)
    global state
    if nargin < 3
        fig = figure;
    end
    
    if nargin < 2
        clust = state.mcViewer.ssb_cluster;
    end
    
    if nargin < 1
        trode = state.mcViewer.ssb_trode;
    end
    
    ax = axes('Parent', fig);
    plot(ax, state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgX, state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvg);
    width = state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.data.spikeWidth;
    xlabel('time (ms)');
    textBox(['Width=' num2str(width)]);
    