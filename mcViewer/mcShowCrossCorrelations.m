function mcShowCrossCorrelations(cycle, x1, x2, raw)
% cycle can corespond to one or more cycles
    global state
    if nargin < 4
        raw = 0;
    end
    maxLag = 200;
%     maxLag = 30;
    Fs = 2;
    
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
    h = figure('Name', 'CrossCorrelations');
    h = mcLandscapeFigSetup(h);
    
%% Next plot all corrected cross correlations (first column in every row is
%% autocorrelogram)
    rows = size(units,1);
    columns = size(units, 1);
    ax = zeros(1, factorial(length(units)) / ( factorial(2) * factorial(length(units) - 2)));
    axPositions = zeros(size(ax));
    counter = 1;
    for i = 1:size(units, 1) % - 1
        rowStart = 1 + columns * (i-1);
        first = 1;
        for j = i:size(units,1)
            [C, shiftC, rawC, lags] = mcXCorr(units(i,:), units(j,:), cycle, x1, x2, maxLag, Fs );
            ax(counter) =  axes('Parent', h, 'XTick', [], 'YTick', [], 'XTickLabel', {''}, 'YTickLabel', {''});
            axPositions(counter) = rowStart + j - 1;
            if any(lags)
                if raw
                    bar(ax(counter), lags, rawC, 1);
                else
                    bar(ax(counter), lags, C, 1);
                end
                set(ax(counter), 'XLim', maxLag * [-1 1], 'YTick', [],'YTickLabel', {''} )
                if ~first
                    set(ax(counter), 'XTick', [],  'XTickLabel', {''});
                end
            end
            if i == 1
                title(['T' num2str(units(j,1)) 'C' num2str(units(j,2))]);
            end
            counter = counter + 1;
            first = 0;
        end
    end
    params.cellmargin = [0.001 0.001 0.001 0.001];
    params.figmargin = [0 0 .05 .05];
    setaxesOnaxesmatrix(ax, rows, columns, axPositions, params);