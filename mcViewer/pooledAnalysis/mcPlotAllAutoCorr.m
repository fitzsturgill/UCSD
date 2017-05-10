function [autoCorr burstIndex] = mcPlotAllAutoCorr(indices, h)

    global clusters
    
    if nargin < 1
        indices = 1:length(clusters);
    elseif islogical(indices)
        indices = find(indices);
    end
    
    if nargin < 2
        h = figure;
    end
    figure(h); 
    
    maxLag = 0.05;
    corrBinSize = 2;
    Fs = round(1000 / corrBinSize);
%     meanISI = zeros(size(clusters));
    burstIndex = zeros(size(indices));
    autoCorr = zeros(length(indices), 2 * Fs * maxLag + 1);
    
    % see Royer et al. 2012, Nature Neuroscience (Buzsaki) for burst index
    % explanation
    burstWinA = [0 10]/1000;
    burstWinB = [40 50]/1000;
    
    for i = 1:length(indices)
        clust = indices(i);
%         ISIs = diff(clusters(1,i).analysis.SpikeBursts.data.unwrapped_times);
%         ISIs = ISIs(ISIs < maxLag);
%         meanISI(1, i) = mean(ISIs);
        [cross, lags] = pxcorr(clusters(1,clust).analysis.SpikeBursts.data.unwrapped_times, Fs, maxLag);
        cross(find(lags==0)) = 0;
        cross = cross ./ max(cross);
        autoCorr(i, :) = cross;
        A = max(cross(lags > burstWinA(1) & lags <= burstWinA(2)));
        B = mean(cross(lags >= burstWinB(1) & lags <= burstWinB(2)));
        burstIndex(1, i) = (A - B) / max(A,B);
    end
    
    [burstIndex, IX] = sort(burstIndex, 'descend');
    autoCorr = autoCorr(IX, :);
    
    
    axes;
    image(lags, [], autoCorr, 'CDataMapping', 'scaled');