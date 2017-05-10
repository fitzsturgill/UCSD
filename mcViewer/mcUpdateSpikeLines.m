function mcUpdateSpikeLines(force)
    global state
    
    if nargin < 1
        force = 0;
    end
    if isempty(state.mcViewer.trode) %now I keep state.mcViewer.trode empty until I run spikesorting routines
        return       
    end
    
    %handles first time loading where data is not yet filtered
    for data=state.mcViewer.tsFilteredData
        if isempty(data{1,1})
            return
        end
    end
    
    
    lineColor = {[0 1 0] [1 0 0] [1 0 1] [0 1 1] [1 1 0] [0 0 0] [0 0 1]...
        [0 0 .5] [0 .5 0] [.5 0 0]};    %I can switch up symbols later to include even more clusters (filled vs. non-filled circles for ex.)
    symbols = {'none' 'o' '+' 'x'};
    fileCounter = state.mcViewer.fileCounter;
    
    for i = 1:length(state.mcViewer.trode)
        %ensure that trode contains spike structure and cluster structure
        if isempty(state.mcViewer.trode(i).spikes)
            continue
        elseif ~isfield(state.mcViewer.trode(i), 'cluster') || isempty(state.mcViewer.trode(i).cluster) || force
            %first delete old handles to spike lines
            if ~isempty(state.mcViewer.trode(i).cluster)
                validHandles = ishandle([state.mcViewer.trode(i).cluster(:).spikeLine]);
                delete([state.mcViewer.trode(i).cluster(validHandles).spikeLine]);

            end
            state.mcViewer.trode(i).cluster = ss_makeClusterStructure(state.mcViewer.trode(i).spikes, 'all');
            mcAddPointAlignedSpikeTimes;
        end        

        for j = 1:length(state.mcViewer.trode(i).cluster)
            if state.mcViewer.showSpikes               
%             if state.mcViewer.trode(i).display && state.mcViewer.showSpikes 
                if state.mcViewer.validClusterLabels(state.mcViewer.trode(i).cluster(j).label) %if cluster is of type to be displayed
                    % find index of maxChannel from displayed channels, if
                    % it isn't displayed, continue
                    maxChannel = state.mcViewer.trode(i).cluster(j).maxChannel;
                    displayChannel = find(maxChannel == state.mcViewer.displayedChannels);
                    if isempty(displayChannel)
                        continue
                    end
                    if state.mcViewer.displayFiltered
                        YData = state.mcViewer.trode(i).cluster(j).spikeAmpsFilt{maxChannel, fileCounter};
                    else
                        YData = state.mcViewer.trode(i).cluster(j).spikeAmps{maxChannel, fileCounter};
                    end

                    if ishandle(state.mcViewer.trode(i).cluster(j).spikeLine)...
%                             && strcmp(get(state.mcViewer.trode(i).cluster(j).spikeLine, 'Type'), 'line')
                        set(state.mcViewer.trode(i).cluster(j).spikeLine,...
                            'Parent', state.mcViewer.axes(displayChannel),...
                            'XData', state.mcViewer.trode(i).cluster(j).spikeTimes{1, fileCounter},...
                            'YData', YData,...
                            'Visible', 'on'...
                            );
                    else
                        state.mcViewer.trode(i).cluster(j).spikeLine = line(...
                            state.mcViewer.trode(i).cluster(j).spikeTimes{1, fileCounter},...
                            YData,...
                            'LineStyle', 'none',...
                            'Marker', symbols{1, state.mcViewer.trode(i).cluster(j).label},... % differentiates 'good', 'multiunit' and 'garbage'
                            'MarkerEdgeColor', lineColor{1, min(length(lineColor), j)},...
                            'Parent', state.mcViewer.axes(displayChannel),...
                            'Visible', 'on'...
                            );
                    end
                end
            elseif ishandle(state.mcViewer.trode(i).cluster(j).spikeLine)
                    set(state.mcViewer.trode(i).cluster(j).spikeLine,...
                        'Visible', 'off'...
                        );
            end
            
            %kludge
            if state.mcViewer.showSelected && (j ~= state.mcViewer.ssb_cluster || i ~= state.mcViewer.ssb_trode)
                set(state.mcViewer.trode(i).cluster(j).spikeLine, 'Visible', 'Off');
            end
        end
    end
        
