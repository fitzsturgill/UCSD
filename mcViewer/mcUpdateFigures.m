function mcUpdateFigures
    try
        global state

        if state.mcViewer.showThresh
            show = 'on';
        else
            show = 'off';
        end
        
        validChannels=find(mcChannelFieldToVector('mcFigureInclude')); %channels to be displayed in mcFigure
        state.mcViewer.displayedChannels = validChannels;        
        nValidChannels = length(validChannels);
        for i = 1:nValidChannels
            channel = validChannels(i);
            set(state.mcViewer.lines(1, i),...
                'Ydata', state.mcViewer.displayData(:, channel),...
                'Xdata', state.mcViewer.displayXData...
                );
            if channel <= state.mcViewer.nChannels
                set(state.mcViewer.threshLines(1, i),...
                    'Ydata', state.mcViewer.displayThreshData(:, channel),...
                    'Xdata', state.mcViewer.displayXData,...
                    'Visible', show...
                    );
            end
        end
        mcUpdateSpikeLines;
        mcUpdateRespirationLines;
        title(state.mcViewer.axes(1), [state.mcViewer.fileName ' Cycle: ' num2str(state.mcViewer.currentCyclePos)], 'Interpreter', 'none');
    catch
        lasterr
        disp('error in mcUpdateFigures');
    end
    
%     % vectorized version!!!   doesn't work
%     i = 1:state.mcViewer.nChannels;
%         set(state.mcViewer.lines(1, i),...
%             'Ydata', state.mcViewer.displayData(:, i)...
%             );
