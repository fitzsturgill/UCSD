

function h = makeRawRateScatterPlots(indices)

    h = landscapeFigSetup;
    
    for i = 1:length(indices)
        ax(i) = makeRawRateScatterPlot(indices(i), h);
    end
    splayAxisTile;
end







function ax = makeRawRateScatterPlot(clust, h)

    global clusters
    
    if nargin < 2 || isempty(h)
        h = figure;
    end
    try
        ctl = [clusters(clust).analysis.SpikeRate.data(1:12, :).avg];
        led = [clusters(clust).analysis.SpikeRate.data(13:24, :).avg];
    catch
        ctl = [clusters(clust).analysis.SpikeRate.data([1 3:7], 1).avg];
        led = [clusters(clust).analysis.SpikeRate.data([8 10:14], 1).avg];
    end
    
    ax = axes; hold on
    scatter(ctl, led);
    % linear fit
    cfun = fit(ctl', led', 'poly1');
    plot(cfun, 'predfunc');
    setXYsameLimit(ax);
    addUnityLine(ax);
    xlabel('spikes/s (ctl)', 'FontSize', 8);
    ylabel('spikes/s (LED)', 'FontSize', 8);
    title(['Indx' num2str(clust) ' ' clusters(clust).experiment ' ' clusters(clust).trodeName ' C:' num2str(clusters(clust).cluster)],...
        'Interpreter', 'none',...
        'FontSize', 8);
end