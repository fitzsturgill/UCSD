function printAnalysisFields
% prints analysis fields of 'multiunit' or 'good' clusters
% assumes that there is at least 1 such cluster
    global state
    for i = 1:length(state.mcViewer.trode)
        for j = 1:length(state.mcViewer.trode(i).cluster)
            if ismember(state.mcViewer.trode(i).cluster(j).label, [2 3]) && isstruct(state.mcViewer.trode(i).cluster(j).analysis)
                fields = fieldnames(state.mcViewer.trode(i).cluster(j).analysis);                
                for k = 1:length(fields)
                    disp(fields{k});
                end
                return
            end
        end
    end