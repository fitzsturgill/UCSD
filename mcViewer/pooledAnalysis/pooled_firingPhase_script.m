
%     show = 1:length(clusters); % show all clusters

    
% test to make sure numbers are right
%     show = mcFilterClusters('experiment', {'Bulb_417_103to152_', 'Bulb_417_153to198_'});
%     show = find(show);

% stringent below
    show = mcFilterClusters('nSpikes', 1000, 'contamination', 20, 'undetected', 20);
    show = find(show);
    cyclesBaseline = 6; % every cluster should have at least this many cycles per baseline period, lets just pick a number of cycles for simplicity
    cyclesOdor = 6;

    phase_odor_cyc1 = [];
    phase_odor_cyc2 = [];
    phase_baseline_cyc1 = [];
    phase_baseline_cyc2 = [];
    
    for i = 1:length(show)
        % baseline average
        clust = show(i);
        if size(clusters(clust).analysis.SpikesByCycle.groupedData, 2) == 5 % exclude Bulb_405 which doesn't have great respiration and a slightly different protocol
            phase_baseline_cyc1(end + 1) = mean(clusters(clust).analysis.SpikesByCycle.groupedData(1,2).respSpikeAvgPhase(1, 1:cyclesBaseline));
            phase_baseline_cyc2(end + 1) = mean(clusters(clust).analysis.SpikesByCycle.groupedData(2,2).respSpikeAvgPhase(1, 1:cyclesBaseline));       
            phase_odor_cyc1(end + 1) = mean(clusters(clust).analysis.SpikesByCycle.groupedData(1,4).respSpikeAvgPhase(1, 1:cyclesOdor));
            phase_odor_cyc2(end + 1) = mean(clusters(clust).analysis.SpikesByCycle.groupedData(2,4).respSpikeAvgPhase(1, 1:cyclesOdor));            
        end
    end



    
    % make odor period scatter plot
    fig = figure('Name', 'phase_odorPeriod');
    scatter(phase_odor_cyc1, phase_odor_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Phase Odor Period - LED (Hz)');
    ylabel('Phase Odor Period + LED (Hz)')
    title('Phase Odor Period');

    % make baseline period scatter plot    
    fig = figure('Name', 'phase_baselinePeriod_raw');
    scatter(phase_baseline_cyc1, phase_baseline_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Phase Baseline Period - LED (Hz)');
    ylabel('Phase Baseline Period + LED (Hz)')
    title('Phase Baseline Period');