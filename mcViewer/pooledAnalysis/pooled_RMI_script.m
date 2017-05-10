
%     show = 1:length(clusters); % show all clusters

% test to make sure numbers are right
%     show = mcFilterClusters('experiment', 'Bulb_411_120to147_', 'cluster', 13);
%     show = find(show);

%stringent below
    show = mcFilterClusters('nSpikes', 1000, 'contamination', 20);
    show = mcFilterClusters('nSpikes', 1000, 'contamination', 20, 'undetected', 20);
    show = find(show);

    RMI_odor_cyc1 = zeros(1,length(show));
    RMI_odor_cyc2 = zeros(1, length(show));
    RMI_baseline_cyc1 = zeros(1,length(show));
    RMI_baseline_cyc2 = zeros(1, length(show));
    CI_odor = zeros(1, length(show)); % change index   (rate LED - rate no LED) / (rate LED + rate no LED)
    CI_baseline = zeros(1, length(show));
    
    for i = 1:length(show)
        RMI_odor_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg)...
            /(clusters(show(i)).analysis.SpikeRate.data(1,1).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg);
        RMI_odor_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg)...
            /(clusters(show(i)).analysis.SpikeRate.data(2,1).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg);
        RMI_baseline_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg)...
            /(clusters(show(i)).analysis.SpikeRate.data(1,2).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg);
        RMI_baseline_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg)...
            /(clusters(show(i)).analysis.SpikeRate.data(2,2).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg);
        
        CI_odor(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.data(1,1).avg)...
            / (clusters(show(i)).analysis.SpikeRate.data(2,1).avg + clusters(show(i)).analysis.SpikeRate.data(1,1).avg);
        CI_baseline(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,2).avg - clusters(show(i)).analysis.SpikeRate.data(2,2).avg)...
            / (clusters(show(i)).analysis.SpikeRate.data(1,2).avg + clusters(show(i)).analysis.SpikeRate.data(2,2).avg);
    end
    
    
    
%     for i = 1:length(show)
%         RMI_odor_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg)...
%             /(clusters(show(i)).analysis.SpikeRate.data(1,1).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg);
%         RMI_odor_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg)...
%             /(clusters(show(i)).analysis.SpikeRate.data(2,1).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg);
%         RMI_baseline_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg)...
%             /(clusters(show(i)).analysis.SpikeRate.data(1,2).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,1).avg);
%         RMI_baseline_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,2).avg - clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg)...
%             /(clusters(show(i)).analysis.SpikeRate.data(2,2).avg + clusters(show(i)).analysis.SpikeRate.baseline(1,2).avg);
%     end
    



    
    % make odor period scatter plot
    fig = figure('Name', 'RMI_odorPeriod');
    scatter(RMI_odor_cyc1, RMI_odor_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('RMI Odor Period - LED');
    ylabel('RMI Odor Period + LED')
    title('RMI Odor Period');

    % make baseline period scatter plot    
    fig = figure('Name', 'RMI_baselinePeriod_raw');
    scatter(RMI_baseline_cyc1, RMI_baseline_cyc2);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('RMI Baseline Period - LED');
    ylabel('RMI Baseline Period + LED')
    title('RMI Baseline Period');
    
    

    % make combined period scatter plot    
    fig = figure('Name', 'RMI_combined_raw');
    scatter(RMI_baseline_cyc2, RMI_baseline_cyc1, 'CData', [0 0 0]);
    hold on
    scatter(RMI_odor_cyc1, RMI_odor_cyc2, 'CData', [1 0 0]);    
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('RMI - LED');
    ylabel('RMI + LED')
    title('RMI Baseline and Odor Period');