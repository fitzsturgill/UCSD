function mcAlignClustersByRespiration(xStart)
    global state
    
    if nargin < 1
        xStart = 0;
    end
    
    for i = 1:state.mcViewer.tsNumberOfFiles
        firstResp = state.mcViewer.features.respiration.times{1, i}(find(state.mcViewer.features.respiration.times{1, i} > xStart, 1));
        
        for j = 1:length(state.mcViewer.trode)
            for k = 1:length(state.mcViewer.trode(j).cluster)
                state.mcViewer.trode(j).cluster(k).spikeTimesAligned{1, i} = state.mcViewer.trode(j).cluster(k).spikeTimes{1, i} - (firstResp - xStart);
            end
        end
    end
    
    
    