function slope_basal_activity_correlation(conditions)

% works to generate plots for conc. expeimrents in which cycle 
% order is, for example, 1 --> 7 for control and 8 --> 14 for LED
    global clusters
    fig = mcLandscapeFigSetup;

    
    for i = 1:length(conditions)
        condition = conditions{1, i};
        ax(i) = axes('Parent', fig, 'FontSize', 8);
        hold on;


        indices = mcFilterClusters('tag', condition, 'contamination', 40, 'undetected', 40, 'LEDZValue', 0.5, 'LEDEffect', 1);
        indices = find(indices);
        slopes = [];
        intercepts = [];
        basalRates = [];
        count = 0;
        
        %% lets gather slopes and intercepts vs basal firing rate and plot
        %% those too
        for j = 1:length(indices)
            ind = indices(j);
            numconc = size(clusters(ind).analysis.SpikeRate.data, 1) / 2;
%             if numconc ~= 7
%                 continue
%             end
%               if strcmp(clusters(ind).experiment, 'PirC_12_MC_1to168_')
%                   continue
%               end
            count = count + 1;
            xData = [clusters(ind).analysis.SpikeRate.data(1:numconc, 1).avg];
            yData = [clusters(ind).analysis.SpikeRate.data([1:numconc] + numconc, 1).avg];
%             scatter(xData, yData, 'MarkerEdgeColor', [0.3 0.3 0.3]);

            % linear fit
            cfun = fit(xData', yData', 'poly1');
            plot(cfun, xData, yData, 'k.'); legend('off');
            cv = coeffvalues(cfun);
            basalRates(end + 1) = mean([clusters(ind).analysis.SpikeRate.data(:,2).avg]);

            slopes(end + 1) = cv(1);
            intercepts(end + 1) = cv(2);
        end
        disp(['Count for Condition ' condition ' is ' num2str(count)]);
        m = mean(slopes);
        b = mean(intercepts);
        fplot(@(x)m*x+b, get(gca, 'XLim'));    

        setXYsameLimit(ax(i));
        addUnityLine(ax(i));
        xlabel('spikes/s (ctl or other)', 'FontSize', 8);
        ylabel('spikes/s (LED or other)', 'FontSize', 8);
        title(condition, 'FontSize', 8);
        textBox(['M=' num2str(m) ' B=' num2str(b)])
        
        [basalRates, IX] = sort(basalRates);
        slopes = slopes(IX);
        intercepts = intercepts(IX);
        
        axes('FontSize', 8); hold on
        slopeFun = fit(basalRates', slopes', 'poly1');
        plot(slopeFun, basalRates, slopes, 'k.', 'predfunc'); legend off;
        xlabel('baseline firing rate');
        ylabel('slope');
        textBox([condition ': slopes']);
        
        axes('FontSize', 8); hold on
        intFun = fit(basalRates', intercepts', 'poly1');
        plot(intFun, basalRates, intercepts, 'k.', 'predfunc'); legend off;
        xlabel('baseline firing rate');
        ylabel('slope');
        textBox([condition ': intercepts']);        
        
    end
    splayAxisTile;