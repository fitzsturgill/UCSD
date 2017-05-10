function tempObject = mcCellCorrelations(bl1, bl2, x1, x2, binSize)

    global state
    if nargin == 0
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;
        x1 = state.mcViewer.x1;
        x2 = state.mcViewer.x2;
    end
    if nargin < 5
        binSize = 100; % 100msec bins for instantaneous spike rate
    end
    
    exportDirectory = 'C:\Fitz\Data\Analysis_centrifugal_manuscript\bulb_cell_correlations';    
    
%% First generate a vector with all clusters (not garbage or MUAtrode)
    units = [];
    for i = 1:length(state.mcViewer.trode)
        trode = i;
        for j = 1:length(state.mcViewer.trode(i).cluster)
            if ismember(state.mcViewer.trode(i).cluster(j).label, [2 3])
                units = [units; [i j]];
            end
        end
    end
    
%% create figure
%     h = figure('Name', 'CellCorrelations');
%     h = mcLandscapeFigSetup(h);
    
%% Next plot all corrected cross correlations (first column in every row is
%% autocorrelogram)
%     rows = size(units,1);
%     columns = size(units, 1);
%     ax = zeros(1, factorial(length(units)) / ( factorial(2) * factorial(length(units) - 2)));
%     axPositions = zeros(size(ax));
    
    cycles = sort(unique(state.mcViewer.tsCyclePos));
    for i = 1:length(cycles)
        cycle = cycles(i);
        allPairs = [];
        allPairsEq = [];
        allPairsBl=[]; % baseline period
        allPairsEqBl=[]; % baseline period
        count = 1;
        fields = {'nSpikes', 'contamination', 'contaminationUpperBound', 'contaminationLowerBound', 'RPV', 'undetected'}; % fields for quality
        for j = 1:size(units, 1) - 1
    %         rowStart = 1 + columns * (i-1);
    %         first = 1;
            for k = j+1:size(units,1)
                % first odor period...
                [Ravg, R] = mcCorr(units(j,:), units(k,:), cycle, x1, x2, binSize);
                allPairs= [allPairs Ravg];
                [Ravg, R] = mcCorr(units(j,:), units(k,:), cycle, x1, x2, binSize, 1); % spike rate equalized correlation
                allPairsEq = [allPairsEq Ravg];
                % now baseline period...
                [Ravg, R] = mcCorr(units(j,:), units(k,:), cycle, bl1, bl2, binSize);
                allPairsBl= [allPairsBl Ravg];
                [Ravg, R] = mcCorr(units(j,:), units(k,:), cycle, bl1, bl2, binSize, 1); % spike rate equalized correlation
                allPairsEqBl = [allPairsEqBl Ravg];                
                if i == 1 % get descriptions of pair
                    for l = 1:length(fields)
                        quality.(fields{1, l})(count, 1) = state.mcViewer.trode(units(j,1)).cluster(units(j,2)).analysis.Quality.data.((fields{1, l}));
                        quality.(fields{1, l})(count, 2) = state.mcViewer.trode(units(k,1)).cluster(units(k,2)).analysis.Quality.data.((fields{1, l}));                   
                    end
                end
                count = count + 1;
            end
        end
        % first odor period
        tempObject.Ravg(i,1) = mean(allPairs);
        tempObject.R{i,1} = allPairs;
        tempObject.RavgEq(i,1) = mean(allPairsEq);
        tempObject.REq{i,1}  = allPairsEq;
        % now baseline period
        tempObject.Ravg(i,2) = mean(allPairsBl);
        tempObject.R{i,2} = allPairsBl;
        tempObject.RavgEq(i,2) = mean(allPairsEqBl);
        tempObject.REq{i,2}  = allPairsEqBl;        
        % cycle
        tempObject.cycle(i) = cycle;
    end
    
    tempObject.x1 = x1;
    tempObject.x2 = x2;
    tempObject.bl1=bl1;
    tempObject.bl2=bl2;
    tempObject.binSize = binSize;
    tempObject.experiment=mcExpPrefix;
    tempObject.quality = quality;
    
%     thisCluster = state.mcViewer.trode(trode).cluster(clusterIndex);
%     tempObject = struct();
%     
%     tempObject.experiment = mcExpPrefix;
%     tempObject.maxChannel = thisCluster.maxChannel;
%     tempObject.analysis = thisCluster.analysis;
%     tempObject.probe = state.mcViewer.probeName;
%     tempObject.label = thisCluster.label;
%     tempObject.cluster=thisCluster.cluster;
%     tempObject.trodeName = state.mcViewer.trode(trode).name; % kind of a kludge- I'm labelling MUA trodes as "MUATrode"

    saveName = fullfile(exportDirectory, [mcExpPrefix 'correlations']);
    
    save(saveName, 'tempObject');
    disp(['*** mcCellCorrelations: Saving ' saveName '  ***']); 