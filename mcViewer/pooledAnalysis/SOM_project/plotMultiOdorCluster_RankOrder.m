
function plotMultiOdorCluster_RankOrder(indices, SpikesByRespCycle)
    global clusters
    
    if nargin < 1
        indices = 1:length(clusters)
    end
    
    if nargin < 2
        SpikesByRespCycle=0;
    end    
    
    if islogical(indices)
        indices = find(indices);
    end
    nAxes = 12; % no relation to number of odors, just number of axes on an individual page
     
%     myclusters = find(mcFilterClusters('experiment', 'PirC_94_MC_1to240_', 'label', 2, 'contamination', 30));
    
    if SpikesByRespCycle
        ZField = 'SpikesByCycleShifted';
    else
        ZField = 'SpikeRate';
    end
    [indices zscores] = sortByZScore(indices, ZField);

    axesIndices = 1:nAxes;
    while any(axesIndices <= length(indices))
        landscapeFigSetup;
        axesIndices = axesIndices(axesIndices <= length(indices));
        clusterIndices = indices(axesIndices);
        zscoreIndices = zscores(axesIndices);
        for j = 1:length(clusterIndices)
            axes; hold on
            if SpikesByRespCycle
                binnedData = clusters(clusterIndices(j)).analysis.SpikesByCycleShifted.binnedRespData;


                baseline = twoRows([binnedData(:,1).ratesCombinedAvg]);
                odor = twoRows([binnedData(:,2).ratesCombinedAvg]);

                odor_std = twoRows([binnedData(:,2).ratesCombinedStd]);
                odor_N = twoRows([binnedData(:,2).ratesCombinedN]);    
            else
                data = clusters(clusterIndices(j)).analysis.SpikeRate.data;
                baseline = twoRows([data(:, 2).avg]);
                odor = twoRows([data(:, 1).avg]);
                odor_std = twoRows([data(:, 1).std]);
                odor_N = twoRows([data(:, 1).n]);
            end 
            nOdors = length(odor);
            deltaRate = odor - repmat(mean(baseline, 2), 1, nOdors);

            [B IX] = sort(deltaRate(1, 2:end));
            IX = [IX+1 1];   % append air trial to end and increment IX + 1 because these indices should start at 2 since I excluded air trial in sort
            deltaRate = deltaRate(:, IX);
            odor_std = odor_std(:, IX);
            odor_N = odor_N(:, IX);
            odor_sem = odor_std ./ sqrt(odor_N);
%             errorbar([1:11;1:11]', deltaRate', odor_sem');            
            errorbar(1:nOdors, deltaRate(1, :), odor_sem(1, :), 'k');
            errorbar(1:nOdors, deltaRate(2, :), odor_sem(2, :), 'r');
            title(gca,...
                [clusters(clusterIndices(j)).experiment ' '... 
                clusters(clusterIndices(j)).trodeName...
                ' C' num2str(clusters(clusterIndices(j)).cluster)...
                ' #' num2str(clusterIndices(j))],...
                'FontSize', 7,...
                'Interpreter', 'none'...
                );
            textBox(['LED ZScore: ' num2str(zscoreIndices(j))]);
            xlabel('odor #', 'FontSize', 7);
            ylabel('\DeltaFiring Rate', 'FontSize', 7);
        end
        splayAxisTile;
        axesIndices = axesIndices + nAxes;
    end
    
end

function [reordered scores] = sortByZScore(indices, ZField)
    global clusters
    scores = zeros(1, length(indices));
    for i=1:length(indices)
        clust = indices(i);
        scores(i) = clusters(clust).analysis.(ZField).LEDZScore;
    end
    [scores IX] = sort(scores);
    reordered = indices(IX);
end
        

function out = twoRows(m)  % gets rid of null odor

    m = reshape(m', length(m) / 2, 2);
    out = m';
%     out = out(:, 2:end); % by commenting preceding line out, now include air trial but append it at end
%     during sorting, air trial is 1st column
end


       