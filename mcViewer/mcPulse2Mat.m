function out = mcPulse2Mat(pulse, channel, x1, x2)
    % returns an array with unfiltered data from trials matching pulse concatenated along the
    % 1st dimension
    % pulse --> cycle or pulse number
    % channel --> channel
    % x1 --> time in msec of beginning of 
    global state
    
    if nargin < 3 || isempty(x1)
        x1 = state.mcViewer.startX;
    end
    
    if nargin < 4 || isempty(x2)
        x2 = state.mcViewer.startX;
    end
    
    p1 = mcX2pnt(x1);
    p2 = mcX2pnt(x2);
    
    out = cat(3, state.mcViewer.tsData{1, state.mcViewer.tsCyclePos == pulse});
    out = squeeze(out(:,channel,:));
%     out = out(:, p1:p2);
    
    
    
    
function p = mcX2pnt(x)
    global state

    startX = state.mcViewer.startX;
    deltaX = state.mcViewer.deltaX;
    
    p = min(max(round(1+(x-startX)/deltaX), 1), size(state.mcViewer.tsData{1,1}, 2));