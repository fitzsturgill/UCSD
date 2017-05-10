
%     show = 1:length(clusters); % show all clusters

% test to make sure numbers are right
%     show = mcFilterClusters('experiment', 'Bulb_411_120to147_', 'cluster', 13);
%     show = find(show);

%stringent below
%     show = mcFilterClusters('nSpikes', 1000, 'contamination', 20, 'undetected', 20);
%     show = find(show);
show = enhanced_clusters;

    deltaRate_odor_cyc1 = zeros(1,length(show));
    deltaRate_odor_cyc2 = zeros(1, length(show));
    deltaRate_baseline_cyc1 = zeros(1,length(show));
    deltaRate_baseline_cyc2 = zeros(1, length(show));
    
    for i = 1:length(show)
        deltaRate_odor_cyc1(1, i) = clusters(show(i)).analysis.SpikeRate.data(1,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg;
        deltaRate_odor_cyc2(1, i) = clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg;
        deltaRate_baseline_cyc1(1, i) = clusters(show(i)).analysis.SpikeRate.data(1,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg;
        deltaRate_baseline_cyc2(1, i) = clusters(show(i)).analysis.SpikeRate.data(2,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg;        
    end



    
    % make odor period scatter plot
    fig = figure('Name', 'deltaFiringRate_odorPeriod_raw');
    scatter(deltaRate_odor_cyc1, deltaRate_odor_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Delta Firing Rate Odor Period - LED (Hz)');
    ylabel('Delta Firing Rate Odor Period + LED (Hz)')
    title('Delta Firing Rate Odor Period');

    % make baseline period scatter plot    
    fig = figure('Name', 'deltaFiringRate_baselinePeriod_raw');
%     scatter(deltaRate_baseline_cyc1, deltaRate_baseline_cyc2); % how it
%     was before 8/8/12
    scatter(deltaRate_baseline_cyc2, deltaRate_baseline_cyc1); 
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Delta Firing Rate Baseline Period - LED (Hz)');
    ylabel('Delta Firing Rate Baseline Period + LED (Hz)')
    title('Delta Firing Rate Baseline Period');