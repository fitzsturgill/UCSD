function mcBuildPCAInput


    global clusters
    global PCAInput_odor
    evalin('base', 'global PCAInput_odor');    
    
    % initialize data matrix- variables go in columns, observations in rows
    PCAInput_odor = zeros(size(clusters(1).analysis.SpikeRate.data, 1), length(clusters));
    for i = 1:length(clusters)
        for j = 1:size(clusters(i).analysis.SpikeRate.data, 1)
            PCAInput_odor(i, j) = clusters(i).analysis.SpikeRate.data(j, 1).avg;
        end
    end