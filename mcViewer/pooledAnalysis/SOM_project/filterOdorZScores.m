function out = filterOdorZScores(indices, revThresh, showDistribution, zThresh)


    global clusters
    
    
    if nargin < 2
        revThresh = 0;  % bool to change to 
    end
    
    if nargin < 3
        showDistribution = 0;
    end
    
    if nargin < 4
        zThresh = 0.2;
    end
    
    zscorefield = 'SpikeRate';
    odorZScores = zeros(24, length(indices));

    out=[];
    for i = 1:length(indices)
        clust = indices(i);
        zscores = clusters(clust).analysis.(zscorefield).OdorZScores;
        odorZScores(:, i) = zscores;
        if ~revThresh
            if mean(zscores) >= zThresh
                out = [out clust];
            end
        else
            if mean(zscores) <= -zThresh
                out = [out clust];
            end      
        end
    end
    
    if showDistribution
        figure; hist(mean(odorZScores));
        xlabel('Distribution across clusters of mean odor z scores');
        ylabel('# clusters');
        set(gca, 'TickDir', 'out');
    end