function ax=mcScatterPlot(trode, clust, cycles, fig, corrInfo, bounds)
    global state
    
    if nargin == 0 || isempty(trode)
        trode = state.mcViewer.ssb_trode;
    end
    
    if nargin == 0 || isempty(clust)
        clust = state.mcViewer.ssb_cluster;
    end
    
    if nargin < 4 || isempty(fig)                
        prefix = mcExpPrefix;
        fig = figure(...
            'Name', [prefix 'T' num2str(trode) 'C' num2str(clust) '_Scatter']...
            );
    end
    
    if nargin < 3 || isempty(cycles)
        cycles = state.mcViewer.ssb_cycleTable';
    end
    
    if nargin < 5
        corrInfo = 1;
    end
    
    if nargin < 6
        bounds = 0; % whether to plot confidence intervals for linear fit
    end

    
    if size(cycles, 1) ~= 2
        disp('error in mcScatterplot: cycles must be a 2 row matrix, 1st row- xaxis, 2nd row- yaxis');
        return
    end
    

    
    xData = [state.mcViewer.trode(trode).cluster(clust).analysis.SpikeRate.data(cycles(1, :), 1).avg];
    yData = [state.mcViewer.trode(trode).cluster(clust).analysis.SpikeRate.data(cycles(2, :), 1).avg];    
%     xData = [state.mcViewer.trode(trode).cluster(clust).analysis.SpikeRate.data(cycles(1, :), :).avg];
%     yData = [state.mcViewer.trode(trode).cluster(clust).analysis.SpikeRate.data(cycles(2, :), :).avg];        
%     
        
    ax = axes(...
        'Parent', fig...
        );    
    
    hold on;
    
    scatter(xData, yData);
    
        % linear fit
    cfun = fit(xData', yData', 'poly1');
    if bounds
        try
            plot(cfun, 'predfunc');
        catch
            plot(cfun);
        end
    else
        plot(cfun);
    end

    legend('off');
    if corrInfo 
        [r, p] = corr(xData', yData');
        cv = coeffvalues(cfun);
        ci = confint(cfun);
        str = {['m=' num2str(cv(1)) ' (' num2str(ci(1,1)) ', ' num2str(ci(2,1)) ')'],...
            ['b=' num2str(cv(2)) ' (' num2str(ci(1,2)) ', ' num2str(ci(2,2)) ')']};
%         str = {['R=' num2str(r)], ['P=' num2str(p)]};
        textBox(str);
    end
    
    setXYsameLimit(ax);
    addUnityLine(ax);
    xlabel('spikes/s (ctl or other)', 'FontSize', 8);
    ylabel('spikes/s (LED or other)', 'FontSize', 8);
    
    
   