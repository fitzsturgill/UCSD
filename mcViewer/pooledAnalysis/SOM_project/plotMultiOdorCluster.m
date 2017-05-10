function plotMultiOdorCluster(clust, nOdors)
    global clusters
    if nargin < 2
        nOdors = 12;
    end
    figure; 

    binnedData = clusters(clust).analysis.SpikesByCycleShifted.binnedRespData;
    yMax=0;
    for i = 1:nOdors
        a(i) = axes; hold on
        if i==2
            title(['I' num2str(clust) ' ' strrep(clusters(clust).experiment, '_', ' ') ' T:' clusters(clust).trodeName ' C:' num2str(clusters(clust).cluster)]);
        end
        ylabel(['cyc:' num2str(i) ', ' num2str(i+nOdors)]);
        errorbar(binnedData(i,1).binTimes, binnedData(i,1).ratesAvg, binnedData(i,1).ratesStd ./ sqrt(binnedData(i,1).ratesN), 'k')
        errorbar(binnedData(i+nOdors,1).binTimes, binnedData(i+nOdors,1).ratesAvg, binnedData(i+nOdors,1).ratesStd ./ sqrt(binnedData(i+nOdors,1).ratesN), 'r')

        errorbar(binnedData(i,2).binTimes, binnedData(i,2).ratesAvg, binnedData(i,2).ratesStd ./ sqrt(binnedData(i,2).ratesN), 'k')
        errorbar(binnedData(i+nOdors,2).binTimes, binnedData(i+nOdors,2).ratesAvg, binnedData(i+nOdors,2).ratesStd ./ sqrt(binnedData(i+nOdors,2).ratesN), 'r')
        axLims = get(gca, 'YLim');
        if axLims(2) > yMax
            yMax = axLims(2);
        end
    end
    for i = 1:length(a)
        set(a(i), 'YLim', [0 yMax]);
    end
        
    splayAxisTile;