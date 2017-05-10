

show = 1:length(clusters); % show all clusters

% test to make sure numbers are right
%     show = mcFilterClusters('experiment', 'Bulb_411_120to147_', 'cluster', 13);
%     show = find(show);

%stringent below
%     show = mcFilterClusters('nSpikes', 1000, 'contamination', 20);
%     show = mcFilterClusters('nSpikes', 1000, 'contamination', 20, 'undetected', 20);
%     show = find(show);

    z_odor_cyc1 = zeros(1,length(show));
    z_odor_cyc2 = zeros(1, length(show));
    z_odor = zeros(1,length(show));
    z_spontaneous = zeros(1, length(show));
%     CI_odor = zeros(1, length(show)); % change index   (rate LED - rate no LED) / (rate LED + rate no LED)
%     CI_baseline = zeros(1, length(show));
    
    for i = 1:length(show)
        % convert SEM back to stdev
        stdev = clusters(show(i)).analysis.SpikeRate.baseline(1,1).sem * sqrt(length(clusters(show(i)).analysis.SpikeRate.baseline(1,1).data));
        z_odor_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg) / stdev;

        stdev = clusters(show(i)).analysis.SpikeRate.baseline(1,2).sem * sqrt(length(clusters(show(i)).analysis.SpikeRate.baseline(1,2).data));
        z_odor_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg) / stdev;
        
        stdev = clusters(show(i)).analysis.SpikeRate.data(1,1).sem * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(1,1).data));
        z_odor(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.data(1,1).avg) / stdev;
        
        stdev = clusters(show(i)).analysis.SpikeRate.data(2,2).sem * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(2,2).data));
        z_spontaneous(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,2).avg - clusters(show(i)).analysis.SpikeRate.data(2,2).avg) / stdev;        
    end

    



    
    % make odor period scatter plot
    fig = figure('Name', 'Z_odorPeriod_vs_baseline');
    scatter(z_odor_cyc1, z_odor_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Zscore Odor Period - LED');
    ylabel('Zscore Odor Period + LED')
    title('Zscore Odor Period VS Baseline');

    % make zscore vs LED  scatter plot
    fig = figure('Name', 'Z_score_LED_change');
    scatter(z_spontaneous, z_odor);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('ZscoreVSLED spontaneous');
    ylabel('ZscoreVSLED odor')
    title('Zscore vs LED');
    
