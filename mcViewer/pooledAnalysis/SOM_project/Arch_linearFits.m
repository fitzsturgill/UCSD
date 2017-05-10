function [slopes intercepts fig] = Arch_linearFits(indices, Rthresh)
% handles clusters with different numbers of cycles, e.g. combining concentration series and 12 odors experiments 


% works to generate plots for experiments in which cycle
% order is, for example, 1 --> 7 for control and 8 --> 14 for LED,
% requires an even number of cycles split into a control and
% LED/experimental segments




    global clusters
   
       
    
%     Rthresh- threshold R value for units to include in grandAverage
        if nargin < 2
            Rthresh = 0;
        end
        
        if islogical(indices)
            indices = find(indices);
        end
        

        nAxes = 25; % max number of axes per page for mosaic display of individual scatter plots
        %%
        axesIndices = 1:nAxes;
        while any(axesIndices <= length(indices))
            axesIndices = axesIndices(axesIndices <= length(indices));
            clusterIndices = indices(axesIndices);
            mosaicFig = landscapeFigSetup;

            for i = 1:length(clusterIndices)
                ind = clusterIndices(i);
                numconc = size(clusters(ind).analysis.SpikeRate.data, 1) / 2;
                xData = [clusters(ind).analysis.SpikeRate.data([1:numconc], 1).avg];
                yData = [clusters(ind).analysis.SpikeRate.data([1:numconc] + numconc, 1).avg];

                % kludge to skip 2nd cycle for AA concentration series
                if numconc == 7
                    xData = [xData(1) xData(3:end)];
                    yData = [yData(1) yData(3:end)];
                end

                rho = corr(xData', yData');   
                if abs(rho) < Rthresh  % don't include if insufficient correlation
                    continue
                end            

                % linear fit
%                 if i>40 
%                     continue % kludge when you are plotting tons of clusters to avoid splayAxisTile errror
%                 end
                axes; hold on;

                cfun = fit(xData', yData', 'poly1');
                plot(cfun, xData, yData, 'k.'); legend('off'); 

                setXYsameLimit;

                addUnityLine;            



                cv = coeffvalues(cfun); 
                ci = confint(cfun);            
    %             str = {['m=' num2str(round(cv(1)*100)/100) ' (' num2str(round(ci(1,1)*100)/100) ', ' num2str(round(ci(2,1)*100)/100) ')'],...
    %                 ['b=' num2str(round(cv(2)*100)/100) ' (' num2str(round(ci(1,2)*100)/100) ', ' num2str(round(ci(2,2)*100)/100) ')']};            

                textBox({[clusters(ind).experiment],... 
                    [clusters(ind).trodeName...
                    ' C' num2str(clusters(ind).cluster)],...
                    ['R=' num2str(rho)],...
                    ['m=' num2str(round(cv(1)*100)/100) ' (' num2str(round(ci(1,1)*100)/100) ', ' num2str(round(ci(2,1)*100)/100) ')'],...
                    ['b=' num2str(round(cv(2)*100)/100) ' (' num2str(round(ci(1,2)*100)/100) ', ' num2str(round(ci(2,2)*100)/100) ')']...                
                    }, [], [], 5);
            end

            splayAxisTile;
            axesIndices = axesIndices + nAxes;
        end
        %%
        
        % grand fit figure
        fig = figure;
        ax = axes('Parent', fig, 'FontSize', 8);
        hold on;
        % vectors to hold slope and intercept values
        slopes = [];
        intercepts = []; 

        for i = 1:length(indices)
            ind = indices(i);
            numconc = size(clusters(ind).analysis.SpikeRate.data, 1) / 2;
            
            xData = [clusters(ind).analysis.SpikeRate.data([1:numconc], 1).avg];
            yData = [clusters(ind).analysis.SpikeRate.data([1:numconc] + numconc, 1).avg];
            
            % kludge to skip 2nd cycle for AA concentration series
            if numconc == 7
                xData = [xData(1) xData(3:end)];
                yData = [yData(1) yData(3:end)];
            end
            
            rho = corr(xData', yData');
            if abs(rho) < Rthresh  % don't include if insufficient correlation
                continue
            end
            
            % linear fit
            cfun = fit(xData', yData', 'poly1');
            h = plot(cfun, xData, yData, 'o'); legend('off');
            set(h(1), 'MarkerSize', 4);
            set(h, 'Color', [0.6 0.6 0.6]); % set color for both lines            
            cv = coeffvalues(cfun);

            slopes(end + 1) = cv(1);
            intercepts(end + 1) = cv(2);
        end

        m = mean(slopes);
        b = mean(intercepts);
        [X,Y] = fplot(@(x)m*x+b, get(gca, 'XLim'));
        plot(X, Y, 'b', 'LineWidth', 2);

        setXYsameLimit(ax);
        addUnityLine(ax);
        set(gca, 'TickDir', 'out');
        xlabel('Ctl: spikes/s', 'FontSize', 8);
        ylabel('LED: spikes/s', 'FontSize', 8);
        textBox(['M=' num2str(m) ' B=' num2str(b)])      
