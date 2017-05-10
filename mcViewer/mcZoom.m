function mcZoom(axisType, action)
    % axisType is "X" or "Y"
    global state
    
%     validChannels=find(mcChannelFieldToVector('mcFigureInclude')); %channels to be displayed in mcFigure
    validChannels = state.mcViewer.displayedChannels;
    nValidChannels = length(validChannels);    
    oldAction = action; % kludge for respiration, see below
    for i = 1:nValidChannels
        channel = validChannels(i);
        axis = state.mcViewer.axes(1, i);
        property = [axisType 'Lim'];
        lim  = get(axis, property);
        extent = lim(2) - lim(1);
        % kludge for respiration
%         if channel == 17
%             action = 'auto'; % always auto scale respiration
%         else
%             action = oldAction;
%         end
        % end kludge
        action = oldAction;
        switch action
            case 'in'
                set(axis, property, [lim(1) + extent/4 lim(2) - extent/4]);
            case 'out'
                set(axis, property, [lim(1) - extent/2 lim(2) + extent/2]);
            case 'auto'
                set(axis, [property 'Mode'], 'auto')
            case 'standard'
                if strcmp(axisType, 'X')
                    line = get(axis, 'Children');
                    if strcmp(get(line(1), 'Type'), 'line')
                        xData = get(line(1), 'XData');
                        set(axis, 'Xlim', [xData(1) xData(end)]);
                    end
                else
                    set(axis, 'Ylim', [-.5 .5]);
                end
            case 'right'
                if extent > 200
                    set(axis, property, lim + 200);
                else
                    set(axis, property, lim + extent);
                end
            case 'left'
                if extent > 200
                    set(axis, property, lim - 200);
                else
                    set(axis, property, lim - extent);
                end
            case 'up'
                set (axis, property, lim + .005);
            case 'down'
                set (axis, property, lim - .005);
            case 'special'
                if strcmp(axisType, 'Y') && (channel > state.mcViewer.nChannels || state.mcViewer.channel(channel).LowPass || state.mcViewer.channel(channel).HighPass || ~state.mcViewer.channel(channel).ShowFilter)
                    set(axis, [property 'Mode'], 'auto');
                else
                    set(axis, 'Ylim', [-.5 .5]);
                end
            otherwise
                disp('Error in mcZoom: invalid action');
        end
    end