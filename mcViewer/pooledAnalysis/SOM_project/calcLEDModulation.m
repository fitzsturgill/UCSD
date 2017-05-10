function [modulation zscores] = calcLEDModulation(indices)
% for every cluster, 
    global clusters
    
    if nargin < 1
        indices = 1:length(clusters);
    end
    modulation = zeros(length(indices), 1);
    zscores = modulation;
    
    for i=1:length(indices)
        clust = indices(i);
        data = clusters(clust).analysis.SpikeRate.data;
        odorPeriod  = twoColumns([data(:, 1).avg]);        
%         modulation(i) = mean(odorPeriod(:, 2)) / mean(odorPeriod(:, 1)); % taking means prior to ratioing to avoid INF or NaN
        LEDMod=(mean(odorPeriod(:, 2)) - mean(odorPeriod(:, 1))) / (mean(odorPeriod(:, 2)) + mean(odorPeriod(:, 1))); % taking means prior to ratioing to avoid INF or NaN        
        modulation(i) = LEDMod;
        zscores(i) = clusters(clust).analysis.SpikeRate.LEDZScore;
        clusters(clust).analysis.SpikeRate.LEDMod=LEDMod;
    end
end

function out = twoColumns(m)
    % returns 2 column matrix
    m = reshape(m', length(m) / 2, 2);
    out = m;
end