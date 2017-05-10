    function ax=mcShowAnalysis_WaveForm(trode, clust, varargin)
        global state
        
        if nargin < 1 || isempty(trode)
            trode = state.mcViewer.ssb_trode;
        end
        
        if nargin < 2 || isempty(clust)
            clust = state.mcViewer.ssb_cluster;
        end
        plot_waveforms(state.mcViewer.trode(trode).spikes, state.mcViewer.trode(trode).cluster(clust).cluster);
        ax = gca;