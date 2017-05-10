function mcFindRespTimes_old(channel, thresh, direction)
    global state
    
    if nargin == 0 || isempty(channel)
        channel = [];
        for i = 1:length(state.mcViewer.channel)
            if strcmpi(state.mcViewer.channel(i).Name, 'resp')
                channel = i;
                break
            end
        end
        if isempty(channel)
            disp('Error in mcFindRespTimes: channel not specified')
            return
        end
    end
    
    if nargin<2 || isempty(thresh)
        thresh = [];
    end
    
    if nargin < 3 || isempty(direction)
        direction = 1;
    end
    % ensure that state.mcViewer.features.respiration is initialized
    if isempty(state.mcViewer.features.respiration)
        state.mcViewer.features.respiration = struct(...
            'times', {cell(1, state.mcViewer.tsNumberOfFiles)},...
            'indices', {cell(1, state.mcViewer.tsNumberOfFiles)},...
            'channel', channel...
            );
    end
    h = waitbar(0, 'Finding Respiration');    
    % extract respiration times from resp channel for all acquisitions
    for i=1:state.mcViewer.tsNumberOfFiles
        data = state.mcViewer.tsData{1, i}(:, channel)'; % convert into a row vector
        data = mcFilter(data, 20, 0, state.mcViewer.sampleRate); % lowpass filter
        data = detrend(data); % subtract baseline and/or linear trend
        data = data .* direction; % peaks up
        data = diff(data); % derivative
        % just calculate auto threshold on a trial by trial basis- adequate
        if isempty(thresh)
            [pks, locs] = mc_findpeaks(data, 'MINPEAKHEIGHT', std(data).*2);
        else
            [pks, locs] = mc_findpeaks(data, 'MINPEAKHEIGHT', thresh);
        end
        state.mcViewer.features.respiration.indices{1, i} = locs;
        state.mcViewer.features.respiration.times{1, i} = state.mcViewer.tsXData{1, i}(locs);
        waitbar(i/state.mcViewer.tsNumberOfFiles);        
    end
    close(h);
        
        