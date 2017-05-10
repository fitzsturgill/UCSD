function respFigureButtonDownFunction
    global state
    lastKey = get(state.mcViewer.respirationFigure, 'CurrentCharacter');
    cp = get(state.mcViewer.respirationAxis, 'CurrentPoint');
    cp = cp(1,1); % only take x coordinate
    cp = state.mcViewer.displayXData(1, closestPoint(state.mcViewer.displayXData, cp)); % set cp equal to nearest time sample
    respTimes = state.mcViewer.features.respiration.times{1, state.mcViewer.fileCounter};
    respIndices = state.mcViewer.features.respiration.indices{1, state.mcViewer.fileCounter};    
    switch lastKey
        case 'z' % add respiration point
            [before after] = surroundingPoints(respTimes,  cp);
            if isempty(before) && isempty(after)
                respTimes = cp;
            elseif isempty(before)
                respTimes = [cp respTimes];
            elseif isempty(after)
                respTimes = [respTimes cp];                
            else
                respTimes = [respTimes(1:before) cp respTimes(after:end)];
            end
        case 'x' % delete respiration point  
            if length(respTimes) == 1
                return
            end
            nearestIndex = closestPoint(respTimes, cp);
            respTimes = respTimes(setdiff(1:length(respTimes), nearestIndex));
        otherwise
            return
    end
    state.mcViewer.features.respiration.times{1, state.mcViewer.fileCounter} = respTimes;            
%     state.mcViewer.features.respiration.indices{1, state.mcViewer.fileCounter} = find(ismember(respTimes, state.mcViewer.displayXData));
    state.mcViewer.features.respiration.indices{1, state.mcViewer.fileCounter} = find(ismember(state.mcViewer.displayXData, respTimes));
    [shiftedTimes shiftedIndices] = calcShiftedRespiration(respTimes, state.mcViewer.sampleRate, state.mcViewer.respirationOffset, state.mcViewer.displayXData);
    state.mcViewer.features.respiration.timesShifted{1, state.mcViewer.fileCounter} = shiftedTimes;
    state.mcViewer.features.respiration.indicesShifted{1, state.mcViewer.fileCounter} = shiftedIndices;    
    state.mcViewer.features.respiration.tsRespirationLock(1, state.mcViewer.fileCounter) = 1;
    state.mcViewer.respirationLock=1;
    updateGUIByGlobal('state.mcViewer.respirationLock');
    mcFlipTimeSeries; % update plots

%     function updateFigures(show) % show is a vector of channels to display
%         global state        
%         for i = 1:18
%             mcFlipCurrentChannel(i);
%             state.mcViewer.currentChannelmcFigureInclude=ismember(i, show);
%             updateGUIByGlobal('state.mcViewer.currentChannelmcFigureInclude');
%             updateChannelStruct;
%         end        
% 
%         mcMakeChannelPlots;    
%         filterChannels=find(find(mcChannelFieldToVector('ShowFilter')) > state.mcViewer.nChannels); %only filter aux channels with filtering on...
%         mcFilterData(1:state.mcViewer.tsNumberOfFiles, 1, filterChannels);        
    
    function index = closestPoint(xdata, x) % xdata is xdata, x is a scalar x location
        [B, IX] = sort(abs(xdata - x));
        index = IX(1);
        
        
    function [before after] = surroundingPoints(xdata,  x) % assumes xdata is ascending (monotonic)
        xdata = xdata - x;
        before = find(xdata < 0, 1, 'last');
        after = find(xdata > 0, 1, 'first');
        indices = [before after];
        