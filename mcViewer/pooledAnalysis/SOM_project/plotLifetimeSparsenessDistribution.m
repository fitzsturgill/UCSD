


function [ls_raw ls_raw_LED] = plotLifetimeSparsenessDistribution(indices, ZScoreField)

    global clusters
    
    if islogical(indices)
        indices = find(indices);
    end
    
    if nargin < 2
        ZScoreField = 'SpikesByCycleShifted';
    end
    rates_bl = zeros(11, length(indices));
    rates_odor = zeros(11, length(indices));
    rates_delta = zeros(11, length(indices));
    LED_zscore = zeros(1, length(indices));
    for i = 1:length(indices)
        clust = indices(i);
        ncyc = size(clusters(clust).analysis.SpikeRate.data, 1);
        rates_bl(:,i) = [clusters(clust).analysis.SpikeRate.data(2:ncyc/2, 2).avg]';
        rates_odor(:,i) = [clusters(clust).analysis.SpikeRate.data(2:ncyc/2, 1).avg]';
        LED_zscore(1, i) = clusters(clust).analysis.(ZScoreField).LEDZScore;
        rates_bl_LED(:,i) = [clusters(clust).analysis.SpikeRate.data(ncyc/2+1:ncyc, 2).avg]';
        rates_odor_LED(:,i) = [clusters(clust).analysis.SpikeRate.data(ncyc/2+1:ncyc, 1).avg]';
    end
    
%     rates_delta = rates_odor - rates_delta;  % formerly had this line,
%     totally wrong, at least I was calculating LS of unsubtracted....
    rates_delta = rates_odor - rates_bl;
    rates_delta_LED = rates_odor_LED - rates_bl_LED;

     
    %clip negative values
    rates_delta(rates_delta < 0) = 0;
    rates_delta_LED(rates_delta_LED < 0) = 0;
    
    %calc lifetime sparseness
    ls = lifetimeSparseness(rates_delta);
    ls_raw = lifetimeSparseness(rates_odor);
    
    ls_LED = lifetimeSparseness(rates_delta_LED);
    ls_raw_LED = lifetimeSparseness(rates_odor_LED);    
    
    figure; 
    hist(ls);
    xlabel('Lifetime Sparseness: delta FR');
    
    figure; 
    hist(ls_raw);
    xlabel('Lifetime Sparseness: raw FR');
    
    figure;
    hist([ls_raw' ls_raw_LED']);
    xlabel('Lifetime Sparseness: Combined');
    figure; hist(ls_raw'); xlabel('LS ctl');
    figure; hist(ls_raw_LED');xlabel('LS LED');
    
    figure; hold on
    scatter(ls_raw, LED_zscore);
    cfun = fit(ls_raw', LED_zscore', 'poly1');
    plot(cfun, 'predfunc');
    [RHO,PVAL] = corr(ls_raw', LED_zscore');
    textBox({['R=' num2str(RHO)], ['P=', num2str(PVAL)]});
end
    