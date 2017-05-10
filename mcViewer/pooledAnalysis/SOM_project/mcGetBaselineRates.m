function [bl contamination undetected] = mcGetBaselineRates(indices)
    % returns array of average baseline firing rates
    % operates on clusters global variable
    global clusters
    
    if islogical(indices)
        indices = find(indices);
    end
    
    bl = zeros(1, length(indices));
    contamination = bl;
    undetected = bl;
    for i = 1:length(indices)
        clust = indices(i);
        bl(i) = mean([clusters(clust).analysis.SpikeRate.baseline(:, :).data]);
        contamination(i) = clusters(clust).analysis.Quality.data.contamination;
        undetected(i) = clusters(clust).analysis.Quality.data.undetected;    
    end