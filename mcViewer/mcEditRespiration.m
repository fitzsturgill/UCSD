function mcEditRespiration
    global state
    
    
    % function that allows you to add, remove or move respiration markers
    % separating respiration cycles
    
    
    
    %% STEP 1: Restrict the mcFigure window to the respiration channel and
    % set appropriate Callback Functions for figure and/or axes
    if ~state.mcViewer.showRespiration
        state.mcViewer.showRespiration = 1;
        updateGUIByGlobal('state.mcViewer.showRespiration');
        mcUpdateRespirationLines;
    end
    updateFigures(17) % show only channel 17 (resp channel)

    figure(state.mcViewer.mcFigure); % bring mcFigure to front
    
    set(state.mcViewer.axes, 'ButtonDownFcn', @editRespirationButtonDownFcn);
    set(state.mcViewer.mcFigure, 'Pointer', 'crosshair'); % set to crosshair signifying edit mode
%     set(state.mcViewer.mcFigure, 'KeyPressFcn', {}); % disable key press function

        
        % generate a button down callback
        % create a persistent variable or something to realize whether the
        % mouse click was preceded by pressing 'd' (delete point) 'a' (add
        % point) or 'm' (move point)
        

    function editRespirationButtonDownFcn(src,evnt)
            global state
            lastKey = get(state.mcViewer.mcFigure, 'CurrentCharacter');
            cp = get(src, 'CurrentPoint');
            cp = cp(1,1); % only take x coordinate
            respTimes = state.mcViewer.features.respiration.times{1, state.mcViewer.fileCounter};
            switch lastKey
                case 'z' % add respiration point
                    bracketIndices = surroundingPoints(respTimes,  cp);
                    respTimes = [respTimes(1:bracketIndices(1)) cp respTimes(bracketIndices(2):end)];
                case 'x' % deletez respiration point
                    if length(respTimes) == 1
                        return
                    end
                    nearestIndex = closestPoint(respTimes, cp);
                    respTimes = respTimes(setdiff(1:length(respTimes), nearestIndex));
                case 'c' % exit editRespiration mode
%                     set(state.mcViewer.mcFigure, 'KeyPressFcn', 'mcFigurekeyPressFunction'); % restore key press function
                    set(state.mcViewer.mcFigure, 'Pointer', 'arrow'); % set to crosshair signifying edit mode
                    set(state.mcViewer.axes, 'ButtonDownFcn', {}); % disable button down function
                otherwise
                    return
            end
            state.mcViewer.features.respiration.times{1, state.mcViewer.fileCounter} = respTimes;            
            mcUpdateRespirationLines;

    function updateFigures(show) % show is a vector of channels to display
        global state        
        for i = 1:18
            mcFlipCurrentChannel(i);
            state.mcViewer.currentChannelmcFigureInclude=ismember(i, show);
            updateGUIByGlobal('state.mcViewer.currentChannelmcFigureInclude');
            updateChannelStruct;
        end        

        mcMakeChannelPlots;    
        filterChannels=find(find(mcChannelFieldToVector('ShowFilter')) > state.mcViewer.nChannels); %only filter aux channels with filtering on...
        mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, filterChannels);        
    function index = closestPoint(xdata, x) % xdata is xdata, x is a scalar x location
        [B, IX] = sort(abs(xdata - x));
        index = IX(1);
        
    function indices = surroundingPoints(xdata,  x) % assumes xdata is ascending (monotonic)
        xdata = xdata - x;
        before = find(xdata < 0, 1, 'last');
        after = find(xdata > 0, 1, 'first');
        indices = [before after];
        
    function updateChannelStruct
        global state
        fields = fieldnames(state.mcViewer.channel);
        for i = 1:length(fields)
            field = fields{i};
            state.mcViewer.channel(state.mcViewer.currentChannel).(field) = ...
                state.mcViewer.(['currentChannel' field]);
        end