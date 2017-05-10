function mcWTF
    global state
    
    for i = 1:length(state.mcViewer.trode)
        for j = 1:length(state.mcViewer.trode(i).cluster)
            state.mcViewer.trode(i).cluster = rmfield(state.mcViewer.trode(i).cluster, 'analysis');
        end
    end