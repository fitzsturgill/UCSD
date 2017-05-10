function mcFindRespTimes(channel, files, force, stringency)
% OLD form: function mcFindRespTimes(channel, thresh, direction)
    global state
    
%     if nargin == 0 || isempty(channel)
%         channel = [];
%         for i = 1:length(state.mcViewer.channel)
%             if strcmpi(state.mcViewer.channel(i).Name, 'resp')
%                 channel = i;
%                 break
%             end
%         end
%         if isempty(channel)
%             disp('Error in mcFindRespTimes: channel not specified')
%             return
%         end
%     end
%   
    if nargin < 4
        stringency = state.mcViewer.respirationStringency; % global stringency setting
    end
    
    if nargin < 3 || isempty(force)
        force=0;
    end
    
    if nargin < 2 || isempty(files)
        files = state.mcViewer.fileCounter;
    end
    
    if nargin < 1 || isempty(channel)
        channel = state.mcViewer.respirationChannel;
    end
    

%     if nargin<2 || isempty(thresh)
%         thresh = [];
%     end
%     
%     if nargin < 3 || isempty(direction)
%         direction = 1;
%     end
    % ensure that state.mcViewer.features.respiration is initialized
    if isempty(state.mcViewer.features.respiration)
        state.mcViewer.features.respiration = struct(...
            'times', {cell(1, state.mcViewer.tsNumberOfFiles)},...
            'indices', {cell(1, state.mcViewer.tsNumberOfFiles)},...
            'timesShifted', {cell(1, state.mcViewer.tsNumberOfFiles)},...
            'indicesShifted', {cell(1, state.mcViewer.tsNumberOfFiles)},...            
            'channel', channel,...
            'tsRespirationStringency', ones(1, state.mcViewer.tsNumberOfFiles) * state.mcViewer.respirationStringency,...
            'tsRespirationLock', zeros(1, state.mcViewer.tsNumberOfFiles)...
            );
    end
    if length(files) > 1
        h = waitbar(0, 'Finding Respiration');    
    end
    % extract respiration times from resp channel for all acquisitions
    for i=1:length(files)
        fileCounter = files(i);
        if ~force && state.mcViewer.features.respiration.tsRespirationLock(1, fileCounter)
            continue
        end
        
        if nargin == 4  % particular respiration stringency is specified
            state.mcViewer.features.respiration.tsRespirationStringency(1, fileCounter) = stringency;
            state.mcViewer.features.respiration.tsRespirationLock(1, fileCounter) = 1;
            state.mcViewer.respirationLock=1;
            updateGUIByGlobal('state.mcViewer.respirationLock');
        end
        
        [indices times ] = mcFindRespAdvanced(fileCounter, stringency);
        state.mcViewer.features.respiration.indices{1, fileCounter} = indices;
        state.mcViewer.features.respiration.times{1, fileCounter} = times;
        [shiftedTimes shiftedIndices] = calcShiftedRespiration(times, state.mcViewer.sampleRate, state.mcViewer.respirationOffset, state.mcViewer.displayXData);
        state.mcViewer.features.respiration.timesShifted{1, fileCounter} = shiftedTimes;
        state.mcViewer.features.respiration.indicesShifted{1, fileCounter} = shiftedIndices;
        if length(files) > 1
            waitbar(fileCounter/state.mcViewer.tsNumberOfFiles);        
        end
    end
    if length(files) > 1
        close(h);
    end
    mcUpdateRespirationLines;
        
        