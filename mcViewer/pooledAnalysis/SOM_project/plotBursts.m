


function plotBursts(indices)
    
    % plots singlets, doublets, triplets and 4+ events on separate axes
    % then generates average normalized by number of singlets for ctl and
    % LED conditions
    global clusters
    bursts_ctl = [];
    bursts_led = [];
    landscapeFigSetup;
    for i = 1:length(indices)
        index = indices(i);
        unit_ctl = reshape([clusters(index).analysis.SpikeBursts.groupedData(1:12,:).bursts], 4, 24);
        unit_ctl_avg = mean(unit_ctl');
        unit_ctl_sem = std(unit_ctl') / sqrt(size(unit_ctl', 1));
        unit_ctl = sum(unit_ctl');
        bursts_ctl(i, :) = unit_ctl;

        unit_led = reshape([clusters(index).analysis.SpikeBursts.groupedData(13:24,:).bursts], 4, 24);
        unit_led_avg = mean(unit_led');
        unit_led_sem = std(unit_led') / sqrt(size(unit_led', 1));    
        unit_led = sum(unit_led');
        bursts_led(i, :) = unit_led;    


    %     figure; hold on
        axes; hold on
        clusterInfoBox(index);

    % make zeros be slightly + so that I can put them on a log scale
    % (log(0) = -inf)
        unit_ctl_avg = fixZeros(unit_ctl_avg);
        unit_led_avg = fixZeros(unit_led_avg);        
        unit_ctl_sem = fixZeros(unit_ctl_sem);
        unit_led_sem = fixZeros(unit_led_sem);        
        
        errorbar(unit_ctl_avg, unit_ctl_sem, 'k');
        errorbar(unit_led_avg, unit_led_sem, 'r');
        set(gca, 'YScale', 'log');
        xlabel('burst order');
    %     title([clusters(index).experiment ' C:' num2str(clusters(index).cluster)]);
    %     removeAxesLabels(gca);
    end
    splayAxisTile;
    bursts_ctl_norm = bursts_ctl ./ repmat(bursts_ctl(:, 1), 1, 4);
    bursts_led_norm = bursts_led ./ repmat(bursts_led(:, 1), 1, 4); 

    bursts_ctl_norm_avg = mean(bursts_ctl_norm);
    bursts_ctl_norm_sem = std(bursts_ctl_norm) / sqrt(size(bursts_ctl_norm, 1));
    bursts_led_norm_avg = mean(bursts_led_norm);
    bursts_led_norm_sem = std(bursts_led_norm) / sqrt(size(bursts_led_norm, 1));

    figure; hold on

    errorbar(bursts_ctl_norm_avg(1:end), bursts_ctl_norm_sem(1:end), 'k');
    errorbar(bursts_led_norm_avg(1:end), bursts_led_norm_sem(1:end), 'r');
    set(gca, 'YScale', 'log');    
    xlabel('burst order');
    title('Burst incidence normalized to singlets');
    textAxes(gcf, {'Burst Plots for'; 'LED Enhanced Clusters'; 'ZScore > 0.75'});
    % set(gca, 'YScale', 'log');
end

function out = fixZeros(in)
% if there are no 4+ events
    zs = in == 0;
    in(zs) = NaN;
    out = in;
end
