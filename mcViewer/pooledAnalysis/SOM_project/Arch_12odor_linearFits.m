function varargout = Arch_12odors_linearFits(indices, Rthresh)

% works to generate plots for conc. experiments in which cycle 
% order is, for example, 1 --> 7 for control and 8 --> 14 for LED

% First, generate a single graph in which a linear fit for every unit is
% determined and then the average linear fit across all units calculated

% output arguments- specify either 2 or 4
% 2   [slopes intercepts]
% 4   [slopes intercepts 

    global clusters
   
       
    
%     Rthresh- threshold R value for units to include in grandAverage
    %% make a mosaic of all the individual fits
        mosaicFig = figure;

        if islogical(indices)
            indices = find(indices);
        end

        count = 0;
        
        Rvalues = zeros(1, numel(indices));
        for j = 1:length(indices)
            ind = indices(j);
            numconc = size(clusters(ind).analysis.SpikeRate.data, 1) / 2;

            count = count + 1;
            xData = [clusters(ind).analysis.SpikeRate.data([1:numconc], 1).avg];
            yData = [clusters(ind).analysis.SpikeRate.data([1:numconc] + numconc, 1).avg];

            % linear fit
            axes; hold on;

            cfun = fit(xData', yData', 'poly1');
            plot(cfun, xData, yData, 'k.'); legend('off'); 
            if (max(xData) <= 15 && max(yData) <=15)
                set(gca, 'XLim', [0 15], 'YLim', [0 15]);
            else
                setXYsameLimit;
            end
            addUnityLine;            
            
            rho = corr(xData', yData');
            Rvalues(1, j) = rho;
            textBox({[clusters(indices(j)).experiment],... 
                [clusters(indices(j)).trodeName...
                ' C' num2str(clusters(indices(j)).cluster)],...
                ['R=' num2str(rho)]...
                }, [], [], 5);




        end
    
    splayAxisTile;
    
    
    %% now select units according to linear correlation strength and
    % calculate a grand average fit
    
    
    summaryFig = figure;

    

        condition = 'SOM';
        ax = axes('Parent', summaryFig, 'FontSize', 8);
        hold on;

        if islogical(indices)
            indices = find(indices);
        end
        slopes = [];
        intercepts = [];
        basalRates = [];
        count = 0;
        

        for j = 1:length(indices)
            
            % skip clusters without sufficient linear correlation
            if abs(Rvalues(1, j)) < Rthresh
                continue
            end
            ind = indices(j);
            numconc = size(clusters(ind).analysis.SpikeRate.data, 1) / 2;

            count = count + 1;
            xData = [clusters(ind).analysis.SpikeRate.data([1:numconc], 1).avg];
            yData = [clusters(ind).analysis.SpikeRate.data([1:numconc] + numconc, 1).avg];


            % linear fit
            cfun = fit(xData', yData', 'poly1');
            h = plot(cfun, xData, yData, 'o'); legend('off');
            % h from cfit.plot is a 2 element vector, h(1) is line
            % corresponding to data points, h(2) is line corresponding to
            % the fit
            set(h(1), 'MarkerSize', 4);
            set(h, 'Color', [0.6 0.6 0.6]); % set color for both lines
            cv = coeffvalues(cfun);
            basalRates(end + 1) = mean([clusters(ind).analysis.SpikeRate.data(:,2).avg]);

            slopes(end + 1) = cv(1);
            intercepts(end + 1) = cv(2);
        end
        disp(['Count for Condition ' condition ' is ' num2str(count)]);
        m = mean(slopes);
        b = mean(intercepts);
        [X,Y] = fplot(@(x)m*x+b, get(gca, 'XLim'));
        plot(X, Y, 'b', 'LineWidth', 2);

        setXYsameLimit(ax);
        addUnityLine(ax, [0.6 0.6 0.6]);
        set(gca, 'TickDir', 'out');
        xlabel('Ctl: spikes/s', 'FontSize', 8);
        ylabel('LED: spikes/s', 'FontSize', 8);
        title(condition, 'FontSize', 8);
        textBox(['M=' num2str(m) ' B=' num2str(b)])      
        
        
        
        varargout{1} = slopes;
        varargout{2} = intercepts;    
        if nargout >= 4
            varargout{3}=mosaicFig;
            varargout{4}=summaryFig;
        end
        if nargout == 5
            varargout{5}=Rvalues;
        end        