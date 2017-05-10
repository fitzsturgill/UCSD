function mcShowSplitMerge(trode)
% Trode can either be index in numeric form or name of trode in string form    
    global state
    
    index = 0;
    if isnumeric(trode)
        index = trode;
    else
        for i = 1:length(state.mcViewer.trode)
            if strcmp(state.mcViewer.trode(i).name, trode)
                index = i;
                break
            end
        end
    end
    
    if ~index || index > length(state.mcViewer.trode)
        disp('***Error in mcShowSplitMerge: trode does not exist***')
        return
    end
    
    if isempty(state.mcViewer.trode(index).splitMergeToolHandle) || ~ishandle(state.mcViewer.trode(index).splitMergeToolHandle)
        state.mcViewer.trode(index).splitMergeToolHandle = figure;
    end
    state.mcViewer.trode(index).spikes.params.display.default_waveformmode = 3;
    splitmerge_tool(state.mcViewer.trode(index).spikes, 'all', state.mcViewer.trode(index).splitMergeToolHandle, index);    