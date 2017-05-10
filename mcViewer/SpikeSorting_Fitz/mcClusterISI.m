function mcClusterISI(trode, cluster, varargin)
    global state

    cycles = state.mcViewer.ssb_cycleTable;
    x1 = state.mcViewer.x1;
    x2 = state.mcViewer.x2;
    bl1 = state.mcViewer.bl1;
    bl2 = state.mcViewer.bl2;
    h = [];
    maxLag = 25;
	binSize = 2.5;
    nBins = round(maxLag/binSize);
    % parse input parameter pairs
    counter = 1;
    while counter+1 <= length(varargin) 
        prop = varargin{counter};
        val = varargin{counter+1};
        switch prop
            case 'cycles'
                cycles = val;
            case 'x1'
                x1 = val;
            case 'x2'
                x2 = val;
            case 'bl1'
                bl1 = val;
            case 'bl2'
                bl2 = val;
            case 'h'
                h = val;
            case 'maxLag'
                maxLag = val;
            otherwise
                error('mcClusterISI : Invalid Parameter')
        end
        counter=counter+2;
    end

    % generate wave and/or figure prefix
    prefix = mcExpPrefix;
    lineColor = state.mcViewer.lineColor;    

    % deal with parameter contingencies
    if isempty(h)
        h = figure(...
            'Name', [prefix 'T' num2str(trode) 'C' num2str(cluster) '_ISI']...
            );
        h=mcLandscapeFigSetup(h);
    else
        figure(h); % bring figure to front and make current figure
    end
        
    
    % iterate over cycle rows, one axes per row
    
    for i = 1:size(cycles, 1);
        ax(i) = axes;
        for j = 1:size(cycles, 2);
            cycle = cycles(i, j);
            acqs = mcTrialsByCycle(cycle);
            % kludge
            if cycle == 1
                trialLookup = 1:state.mcViewer.tsNumberOfFiles;
                cycleLookup = state.mcViewer.tsCyclePos;
                acqs = trialLookup(cycleLookup <= 12);
            elseif cycle == 2
                trialLookup = 1:state.mcViewer.tsNumberOfFiles;
                cycleLookup = state.mcViewer.tsCyclePos;
                acqs = trialLookup(cycleLookup > 12);
            end
            % baseline period
            ISIs = state.mcViewer.trode(trode).cluster(cluster).spikeTimes(1, acqs);
            ISIs = cell2mat(ISIs);            
            ISIs = ISIs((ISIs > bl1) & (ISIs < bl2));
            ISIs = diff(ISIs);
            ISIs = ISIs(ISIs <= maxLag & ISIs > 0);
            
            [n, x] = hist(ISIs, linspace(0, maxLag, nBins));
            n = n / trapz(x, n); % normalize
            line(... 
                x,...
                n,...
                'Parent', ax(i),...
                'Color', lineColor{j},...
                'LineStyle', '--'... % dashed
                );      
            % odor period
            ISIs = state.mcViewer.trode(trode).cluster(cluster).spikeTimes(1, acqs);
            ISIs = cell2mat(ISIs);    
            ISIs = ISIs((ISIs > x1) & (ISIs < x2));
            ISIs = diff(ISIs);
            ISIs = ISIs(ISIs <= maxLag & ISIs > 0);
            
            [n, x] = hist(ISIs, linspace(0, maxLag, nBins));
            n = n / trapz(x, n); % normalize            
            line(... 
                x,...
                n,...
                'Parent', ax(i),...
                'Color', lineColor{j},...
                'LineStyle', '-'... % solid
                );                   
        end
    end
    splayAxisTile;