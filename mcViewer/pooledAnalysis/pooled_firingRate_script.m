
%     show = 1:length(clusters); % show all clusters

% test to make sure numbers are right
%     show = mcFilterClusters('experiment', 'Bulb_411_120to147_', 'cluster', 13);
%     show = find(show);

% stringent below
%     show = mcFilterClusters('nSpikes', 1000, 'contamination', 20, 'undetected', 20);
%     show = find(show);
    show = mcFilterClusters('nSpikes', 1000, 'contamination', 50, 'undetected', 50);
    show = find(show);
    
    
    rate_odor_cyc1 = zeros(1,length(show));
    rate_odor_cyc2 = zeros(1, length(show));
    pV_odor = zeros(1,length(show));
    pV_baseline = zeros(1,length(show));
    rate_baseline_cyc1 = zeros(1,length(show));
    rate_baseline_cyc2 = zeros(1, length(show));
    sanity=[];
    for i = 1:length(show)
        rate_odor_cyc1(1, i) = clusters(show(i)).analysis.SpikeRate.data(1,1).avg;
        rate_odor_cyc2(1, i) = clusters(show(i)).analysis.SpikeRate.data(2,1).avg;
        % calculate p values for FDR
        [h, p] = ttest2(clusters(show(i)).analysis.SpikeRate.data(1,1).data, clusters(show(i)).analysis.SpikeRate.data(2,1).data);
        pV_odor(1, i) = p;
        sanity(i).p=p;
        sanity(i).exp=clusters(show(i)).experiment;
        sanity(i).trodeName=clusters(show(i)).trodeName;
        sanity(i).cluster=clusters(show(i)).cluster;
        sanity(i).r1=clusters(show(i)).analysis.SpikeRate.data(1,1).avg;
        sanity(i).r2=clusters(show(i)).analysis.SpikeRate.data(2,1).avg;
        sanity(i).index=show(i);
        rate_baseline_cyc1(1, i) = clusters(show(i)).analysis.SpikeRate.data(1,2).avg;
        rate_baseline_cyc2(1, i) = clusters(show(i)).analysis.SpikeRate.data(2,2).avg;
        % calculate p values for FDR
        [h, p] = ttest2(clusters(show(i)).analysis.SpikeRate.data(1,2).data, clusters(show(i)).analysis.SpikeRate.data(2,2).data);
        pV_baseline(1, i) = p;
        
        rate_preBaseline_cyc1(1, i) = clusters(show(i)).analysis.SpikeRate.baseline(1, 1).avg;
        rate_preBaseline_cyc2(1, i) = clusters(show(i)).analysis.SpikeRate.baseline(1, 2).avg;
        variance_baseline_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,2).avg * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(1,2).data)))^2;
        variance_baseline_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,2).avg * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(2,2).data)))^2;        
        variance_odor_cyc1(1, i) = (clusters(show(i)).analysis.SpikeRate.data(1,1).avg * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(1,1).data)))^2;
        variance_odor_cyc2(1, i) = (clusters(show(i)).analysis.SpikeRate.data(2,1).avg * sqrt(length(clusters(show(i)).analysis.SpikeRate.data(2,1).data)))^2;                
    end
    %% odor period
    % now perform Benjamini and Hochberg FDR procedure
    
    [sorted, indices] = sort(pV_odor, 'descend');
    elements = length(pV_odor):-1:1;
    alpha = .1; % critical value
    CrV = ones(1, length(pV_odor)) * alpha; 
    CrV = CrV .* (elements ./ length(pV_odor));
    
    % step through sorted testing whether null hypothesis is rejected
    rate_odor_H0 = sorted < CrV;
    % find the first rejected null hypothesis and reject the remaining as
    % well
    rate_odor_H0(find(rate_odor_H0, 1):end) = 1;
    % restore original sorting
%     rate_odor_CrV = CrV(indices);
%     rate_odor_H0 = rate_odor_H0(indices);
    unsorted=1:length(indices);
    indices2(indices)=unsorted;
    rate_odor_CrV = CrV(indices2);
    rate_odor_H0 = rate_odor_H0(indices2);
    sorted=sorted(indices2);
    for i=1:length(rate_odor_CrV)
        sanity(i).CrV=rate_odor_CrV(i);
        sanity(i).H0=rate_odor_H0(i);
        sanity(i).sorted=sorted(i);
    end
    
    % make odor period scatter plot
    fig = figure('Name', 'firingRate_odorPeriod_raw');
    colormap(winter);
    scatter(rate_odor_cyc1, rate_odor_cyc2, [], rate_odor_H0);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Firing Rate Odor Period - LED (Hz)');
    ylabel('Firing Rate Odor Period + LED (Hz)')
    title('Firing Rate Odor Period');
    
    
    %% baseline period
    % now perform Benjamini and Hochberg FDR procedure
    
    [sorted, indices] = sort(pV_baseline, 'descend');
    elements = length(pV_baseline):-1:1;
    alpha = .1; % critical value
    CrV = ones(1, length(pV_baseline)) * alpha; 
    CrV = CrV .* (elements ./ length(pV_baseline));
    
    % step through sorted testing whether null hypothesis is rejected
    rate_baseline_H0 = sorted < CrV;
    % find the first rejected null hypothesis and reject the remaining as
    % well
    rate_baseline_H0(find(rate_baseline_H0, 1):end) = 1;
    % restore original sorting
    unsorted=1:length(indices);
    indices2(indices)=unsorted;
    rate_baseline_CrV = CrV(indices2);
    rate_baseline_H0 = rate_baseline_H0(indices2);
    
    % make baseline period scatter plot    
    fig = figure('Name', 'firingRate_baselinePeriod_raw');
    colormap(winter);
    scatter(rate_baseline_cyc2, rate_baseline_cyc1, [], rate_baseline_H0);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Firing Rate Baseline Period - LED (Hz)');
    ylabel('Firing Rate Baseline Period + LED (Hz)')
    title('Firing Rate Baseline Period');
    
    
    % make combined period scatter plot    
    fig = figure('Name', 'firingRate_raw_bothPeriods_stringent');
    scatter(rate_baseline_cyc2, rate_baseline_cyc1, 'CData', [0 0 0]);
    hold on;
    scatter(rate_odor_cyc1, rate_odor_cyc2, 'CData', [1 0 0]);
    ylimits = get(gca, 'YLim');
    xlimits = get(gca, 'XLim');
    low = min(ylimits(1), xlimits(1));
    high = max(ylimits(2), xlimits(2));
    set(gca, 'XLim', [low high]);
    set(gca, 'YLim', [low high]);
    addUnityLine;
    
    xlabel('Firing Rate - LED (Hz)');
    ylabel('Firing Rate  + LED (Hz)')
    title('Firing Rate Baseline and Odor Periods');    