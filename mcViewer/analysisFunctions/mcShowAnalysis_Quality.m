    function ax=mcShowAnalysis_Quality(trode, clust, varargin)
        global state
        plot_isi(state.mcViewer.trode(trode).spikes, state.mcViewer.trode(trode).cluster(clust).cluster);
        ax = gca;