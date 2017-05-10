function makeTuningCurve(indices, useCycles)

    global clusters
    
    if nargin < 2 || isempty(useCycles)
        useCycles = [];
    elseif rem(useCycles, 2) ~= 0
        disp('error in makeConcCurve: useCycles must be even');
        return
    end

    if isempty(useCycles)
        numCycles = size(clusters(indices(1)).analysis.SpikeRate.data, 1);
        useCycles = [2:numCycles/2 numCycles/2+2:numCycles];
    end
    
    rates = zeros(length(indices), length(useCycles));
    for i = 1:length(indices)
        clust = indices(i);
        rates(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 1).avg];
        ratesBL(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 2).avg];            
    end
    
    
    % reshape rates in 3 dimensions so that different units corresponds to rows, different
    % odors corresponds to columns, and +/- LED corresponds to 3rd
    % dimension
    rates = reshape(rates, [length(indices) length(useCycles)/2 2]);
    ratesBL = reshape(ratesBL, [length(indices) length(useCycles)/2 2]);
    % sort by ctl conditions (non-LED)
    sizeRates = size(rates);
    
    % sort by columns (2nd dimension) and obtain column subscripts
    [sorted sortKey] = sort(rates(:,:,1), 2);
    
    % separate colum subscripts into odds and evens and then concatenate them with
    % odd's reversed, i.e. for 1:10 --> [ 1:2:9 10:2:2 ]  
    % -->  1 3 5 7 9 10 8 6 4 2,   to generate a pseudo-tuning curve
 
    evens = sortKey(:, 2:2:size(rates, 2));
    odds = sortKey(:, 1:2:size(rates, 2));
    sortKey2 = [odds fliplr(evens)];
    sortKey = sub2ind(size(rates), repmat([1:sizeRates(1)]', [1 sizeRates(2) 2]), repmat(sortKey, [1 1 2]), cat(3, ones(size(rates, 1), size(rates, 2)),...
        ones(size(rates, 1), size(rates, 2)) + 1));
    sortKey2 = sub2ind(size(rates), repmat([1:sizeRates(1)]', [1 sizeRates(2) 2]), repmat(sortKey2, [1 1 2]), cat(3, ones(size(rates, 1), size(rates, 2)),...
        ones(size(rates, 1), size(rates, 2)) + 1));
    
    ratesSorted = rates(sortKey);  % do I need this?
    ratesBlended = rates(sortKey2); % "blended" means turned into a pseudo-tuning curve
    
    % generate baseline and max response arrays for baselining and
    % normalization
    
    BLarray = repmat(mean(ratesBL(:,:,1), 2), [1 size(ratesBL, 2) 2]);  % average together all baseline periods for ctl (NOT LED) condition
    MAXarray = repmat(max(rates(:,:,1), [], 2), [1 size(ratesBL, 2) 2]);
    
    % baseline by mean spontaneous rate for control condition condition for every unit
    ratesBlendedBL = ratesBlended - BLarray;

    
    % normalize by baseline subtracted max rate, control condition for every unit
    ratesBlendedNorm = ratesBlendedBL ./ (MAXarray - BLarray);

    
   % make mosaic figure
    mosaicFig = figure;
    for i = 1:length(indices)
        axes; hold on;
        plot([ratesBlendedBL(i, :, 1)' ratesBlended(i, :, 2)']);
        clust = indices(i);
        textBox({[clusters(clust).experiment],...
            [clusters(clust).trodeName ' C' num2str(clusters(clust).cluster) ' I' num2str(clust)]...
            }, [], [], 5);
    end
    splayAxisTile;
    
    %make average figure
    avgFigure = figure;
    

    rates_norm_avg = squeeze(mean(ratesBlendedNorm));
    rates_norm_n = zeros(size(rates_norm_avg)) + size(ratesBlendedNorm, 1);
    rates_norm_sem = squeeze(std(ratesBlendedNorm)) ./ sqrt(rates_norm_n);
    
%     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
    h = errorbar([1:length(rates_norm_avg); 1:length(rates_norm_avg)]' , rates_norm_avg, rates_norm_sem);
    set(gca, 'TickDir', 'out');
    set(h(1), 'Color', 'k');
    set(h(2), 'Color', 'r');
    
    
    
    