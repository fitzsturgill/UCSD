function [respIndices respTimes] = mcFindRespAdvanced(fileCounter, stringency, displayOnly)
    global state

%   Use wrapper (mcFindRespTimes) when detecting respiration
% when simply updating respiration figure (mcFlipTimeSeriess) it is OK just
% to use mcFindRespAdvanced

% this function does not actually write respiration locations to
% state.mcViewer.features.respiration
    
    % 
    slopeSpacerX = 50; % 50msec
    slopeSpacer = round(slopeSpacerX / state.mcViewer.deltaX);
    if nargin < 2
        stringency = 1; % multiple of standard deviation of slope of data
    end
    
    if nargin < 3
        displayOnly = 0; % don't force (optional) if you want to regenerate display data for resp window without affecting respiration peaks
    end
    

    minSeparation = 100; % 100msec at least in between respiration peaks
    respData = mcFilter(state.mcViewer.tsData{1, fileCounter}(:, state.mcViewer.respirationChannel), 20, 0, state.mcViewer.sampleRate)'; % now dealing with row vector, slower, but easier for met to think about
    respData = respData .* state.mcViewer.respirationDirection; % FS MOD 4/22/2013
%     respData = detrend(respData);
%     waveo('respWave', respData, 'xscale', [0 state.mcViewer.deltaX]);
%     global respWave
%     duplicateo(respWave, 'respWave_for');
%     duplicateo(respWave, 'respWave_rev');
%     duplicateo(respWave, 'respWave_peaks');    
%     global respWave_for respWave_rev respWave_peaks

    
    respSlope_for = (respData - [respData(1, 1 + slopeSpacer : end) repmat(respData(1, end), 1, slopeSpacer)]) / slopeSpacerX;  % forward looking slope
    respSlope_rev = (respData - [repmat(respData(1, 1), 1, slopeSpacer) respData(1, 1:end - slopeSpacer)]) / slopeSpacerX;      % back looking slope
    respMask = (respSlope_for > 0) .* (respSlope_rev > 0);
    peakFinder = diff(respMask);
    peakStarts = find(peakFinder == 1) + 1;
    peakEnds = find(peakFinder == -1);
    thresh = std(respSlope_rev) * stringency;
    thresh2 = std(respSlope_for) * stringency;
    
    if peakEnds(1,1) < peakStarts(1,1)
        peakEnds = peakEnds(1, 2:end); % trim off first point if falling phase of respiration is at beginning of acquisition
    end
    
    if ~displayOnly
        respIndices=[]; % can't initialize as number of respiration cycles as yet unknown
        respHeights=[];
        for i=1:length(peakStarts)
            [peakY, peakPoint] = max(respData(1, peakStarts(1, i) : peakEnds(1, i)));
            peakPoint = peakStarts(1, i) + peakPoint - 1;

            if (respSlope_rev(1, peakPoint) < thresh) || (respSlope_for(1, peakPoint) < thresh2)
                continue
            end
            
            if ~isempty(respIndices) && respIndices(end) + 50/state.mcViewer.deltaX > peakPoint
                continue
            end
            % need to add something to screen for peak separation
            respIndices = [respIndices peakPoint];
            respHeights = [respHeights peakY];
        end
    elseif ~isempty(state.mcViewer.features.respiration)
        respIndices = state.mcViewer.features.respiration.indices{1, fileCounter};
        respHeights = respData(respIndices);
    else
        respIndices = [];
        respHeights = [];
    end
    respTimes = state.mcViewer.displayXData(respIndices);
    % create/overwrite resp waves for monitoring/verification purposes
    waveo('respWave', scaleRespDataForDisplay(respData), 'xscale', [0 state.mcViewer.deltaX]);

    waveo('respSlopeWave_for', scaleRespDataForDisplay(respSlope_for, -1), 'xscale', [0 state.mcViewer.deltaX]);
    waveo('respSlopeWave_rev', scaleRespDataForDisplay(respSlope_rev, -1), 'xscale', [0 state.mcViewer.deltaX]);
    waveo('respMaskWave', respMask*2 - 1, 'xscale', [0 state.mcViewer.deltaX]);
    

    respHeightsNorm = respHeights - min(respData);
    respHeightsNorm = respHeightsNorm / max(respData - min(respData));
    waveo('respPeaksWaveY', respHeightsNorm);
    waveo('respPeaksWaveX', respTimes);

end


function data = scaleRespDataForDisplay(data, offset)
    if nargin < 2
        offset = 0;
    end
    data = data - min(data);
    data = data / max(data);
    data = data + offset;
end
        
%         state.mcViewer.features.respiration.indices{1, fileCounter} = respIndices;
%         state.mcViewer.features.respiration.times{1, fileCounter} = state.mcViewer.tsXData{1, fileCounter}(respIndices);        
        
%     	out=xs(1)+xs(2)*(p-1);
    
    






%% old, wave version

% function respIndices = mcFindRespAdvanced(fileCounter)
%     global state
% 
%     slopeSpacerX = 50; % 50msec
%     slopeSpacer = round(slopeSpacerX / state.mcViewer.deltaX);
%     stringency = 1; % multiple of standard deviation of data
%     minSeparation = 100; % 100msec at least in between respiration peaks
%     respData = mcFilter(state.mcViewer.tsData{1, fileCounter}(:, state.mcViewer.respirationChannel), 20, 0, state.mcViewer.sampleRate)'; % now dealing with row vector, slower, but easier for met to think about
% %     respData = detrend(respData);
%     waveo('respWave', respData, 'xscale', [0 state.mcViewer.deltaX]);
%     global respWave
%     duplicateo(respWave, 'respWave_for');
%     duplicateo(respWave, 'respWave_rev');
%     duplicateo(respWave, 'respWave_peaks');    
%     global respWave_for respWave_rev respWave_peaks
% 
%     
%     respWave_for.data = (respData - [respData(1, 1 + slopeSpacer : end) repmat(respData(1, end), 1, slopeSpacer)]) / slopeSpacerX;  % forward looking slope
%     respWave_rev.data = (respData - [repmat(respData(1, 1), 1, slopeSpacer) respData(1, 1:end - slopeSpacer)]) / slopeSpacerX;      % back looking slope
%     respWave_peaks.data = (respWave_for.data > 0) .* (respWave_rev.data > 0);
%     peakFinder = diff(respWave_peaks.data);
%     peakStarts = find(peakFinder == 1) + 1;
%     peakEnds = find(peakFinder == -1);
%     thresh = std(respWave_rev.data) * stringency;
%     
%     if peakEnds(1,1) < peakStarts(1,1)
%         peakEnds = peakEnds(1, 2:end); % trim off first point if falling phase of respiration is at beginning of acquisition
%     end
%     
% 
%     respIndices=[];
%     for i=1:length(peakStarts)
%         [peakY, peakPoint] = max(respData(1, peakStarts(1, i) : peakEnds(1, i)));
%         peakPoint = peakStarts(1, i) + peakPoint - 1;
%         
%         % need to add something to screen for peak separation
%         respIndices = [respIndices peakPoint];
%     end
%         
% %         state.mcViewer.features.respiration.indices{1, fileCounter} = respIndices;
% %         state.mcViewer.features.respiration.times{1, fileCounter} = state.mcViewer.tsXData{1, fileCounter}(respIndices);        
%         
% %     	out=xs(1)+xs(2)*(p-1);
%     
    