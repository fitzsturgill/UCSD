function success = mcUpdateSpikeLines
    global state
    
    success = 0;
    
    if isempty(state.mcViewer.trode) %now I keep state.mcViewer.trode empty until I run spikesorting routines
        return       
    end
    
    lineColor = {'b', 'g', 'r', 'm', 'c', 'y', 'k'};    %I can switch up symbols later to include even more clusters (filled vs. non-filled circles for ex.)
    fileCounter = state.mcViewer.fileCounter;
    for i = 1:length(state.mcViewer.trode.cluster)
        maxChannel = state.mcViewer.trode.cluster(i).maxChannel;
   
        if state.mcViewer.displayFiltered
            YData = state.mcViewer.trode.cluster(i).spikeAmpsFilt{maxChannel, fileCounter};
        else
            YData = state.mcViewer.trode.cluster(i).spikeAmps{maxChannel, fileCounter};
        end
        
        if ~isempty(state.mcViewer.spikeLines) && length(state.mcViewer.spikeLines) >= i && ishandle(state.mcViewer.spikeLines(i))
            set(state.mcViewer.spikeLines(i),...
                'Parent', state.mcViewer.axes(maxChannel),...
                'XData', state.mcViewer.trode.cluster(i).spikeTimes{1, fileCounter},...
                'YData', YData...                               
                );
        else
            state.mcViewer.spikeLines(i) = line(...
                state.mcViewer.trode.cluster(i).spikeTimes{1, fileCounter},...
                YData,...
                'LineStyle', 'none',...
                'Marker', 'o',...
                'MarkerEdgeColor', lineColor{1, min(length(lineColor), i)},...
                'Parent', state.mcViewer.axes(maxChannel)...
                );
        end
                        
        if state.mcViewer.showSpikes
            set(state.mcViewer.spikeLines(i), 'Visible', 'on');
        else
            set(state.mcViewer.spikeLines(i), 'Visible', 'off');
        end
    end
    success = 1;