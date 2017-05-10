function ax=mcShowAnalysis(analysisField, trode, cluster, varargin)
    global state
    
     if nargin < 2
         trode = state.mcViewer.ssb_trode;
         cluster = state.mcViewer.ssb_cluster;
     end
    

    if isempty(state.mcViewer.trode(trode).spikes) || ~isfield(state.mcViewer.trode(trode), 'cluster') || isempty(state.mcViewer.trode(trode).cluster)
        return
    end

    f = state.mcViewer.trode(trode).cluster(cluster).analysis.(analysisField).displayFcnHandle;
    ax=f(trode, cluster, varargin{:,:}); %execute function handle with trode, cluster, and varargin as arguments
