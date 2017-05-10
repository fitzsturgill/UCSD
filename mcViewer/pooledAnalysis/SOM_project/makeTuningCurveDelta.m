function h = makeTuningCurveDelta(indices, useCycles, deltaMode, revSort, ax)

% make pseudo-tuning curves for odors
% indices-   indices into global "clusters"
% useCycles-   which cycles to use, must be even, should be symetrical,
% i.e. first n/2 are for ctl condition, last n/2 are for LED condition
% deltaMode-  default 1, seperately baseline ctl and LED conditions to
% isolate odor-evoked firing, if 0, baselines by ctl baseline firing rate

% deltaMode- if set to 3 similar to 0, yet it displays as a dotted line the
% seperately baselined LED condition responses

% baseline firing rate used is prior to odor period
% revSort-  reverses sort, useful in case of suppressive odor responses,
% default is 0 for revSort
    global clusters
    
    if nargin < 2 || isempty(useCycles)
        useCycles = [];
    elseif rem(useCycles, 2) ~= 0
        disp('error in makeConcCurve: useCycles must be even');
        return
    end
    
    if nargin < 3
        deltaMode = 1;
    end
    
    if nargin < 4
        revSort = 0;
    end
    
    if nargin < 5
        ax = [];
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
    if ~revSort
        [sorted sortKey] = sort(rates(:,:,1), 2);
    else
        [sorted sortKey] = sort(rates(:,:,1), 2, 'descend');
    end
    
    % separate colum subscripts into odds and evens and then concatenate them with
    % odd's reversed, i.e. for 1:10 --> [ 1:2:9 10:2:2 ]  
    % -->  1 3 5 7 9 10 8 6 4 2,   to generate a pseudo-tuning curve
 
    evens = sortKey(:, 2:2:size(rates, 2));
    odds = sortKey(:, 1:2:size(rates, 2));
    sortKey2 = [odds fliplr(evens)];
    sortKey2 = sub2ind(size(rates), repmat([1:sizeRates(1)]', [1 sizeRates(2) 2]), repmat(sortKey2, [1 1 2]), cat(3, ones(size(rates, 1), size(rates, 2)),...
        ones(size(rates, 1), size(rates, 2)) + 1));
    
    ratesBlended = rates(sortKey2); % "blended" means turned into a pseudo-tuning curve
    
    % generate baseline and max response arrays for baselining and
    % normalization
    if deltaMode == 1
        BLarray = repmat(mean(ratesBL(:,:,:), 2), [1 size(ratesBL, 2)]);
    elseif deltaMode == 0 || deltaMode == 3
        BLarray = repmat(mean(ratesBL(:,:,1), 2), [1 size(ratesBL, 2) 2]);
    end
    % kludge below for deltamode == 3
    BLarray2 = repmat(mean(ratesBL(:,:,:), 2), [1 size(ratesBL, 2)]);
    
    
    MAXarray = repmat(max(rates(:,:,1), [], 2), [1 size(ratesBL, 2) 2]);
    
    % baseline by mean spontaneous rate for control condition condition for every unit
    ratesBlendedBL = ratesBlended - BLarray;
    
    % for deltaMode 3
    ratesBlendedBL2 = ratesBlended - BLarray2;

    
    % normalize by baseline subtracted max rate, control condition for every unit
    ratesBlendedNorm = ratesBlendedBL ./ (MAXarray - BLarray);
    ratesBlendedNorm2 = ratesBlendedBL2 ./ (MAXarray - BLarray);
   % make mosaic figure
   mosaicFig=[]; % kludge for axis specified mode where we don't want mosaicFig handle
   if isempty(ax)
        mosaicFig = figure;
        for i = 1:length(indices)
            axes; hold on;
            plot(1:length(useCycles)/2, ratesBlended(i, :, 1), 'k', 1:length(useCycles)/2, ratesBlended(i, :, 2), 'r',...
                1:length(useCycles)/2, zeros(1, length(useCycles)/2) + BLarray(i, 1, 1), '--k',...
                1:length(useCycles)/2, zeros(1, length(useCycles)/2) + BLarray(i, 1, 2), '--r'); % raw + baseline values for ctl and LED
    %         plot(1:length(useCycles)/2, ratesBlendedBL(i, :, 1), 'k', 1:length(useCycles)/2, ratesBlendedBL(i, :, 2), 'r'); % baselined
            clust = indices(i);
            textBox({[clusters(clust).experiment],...
                [clusters(clust).trodeName ' C' num2str(clusters(clust).cluster) ' I' num2str(clust)]...
                }, [], [], 5);
        end
        splayAxisTile;
    end
    
    %make average figure
    if isempty(ax)
        avgFigure = figure;
    else
        avgFigure = ax;
    end
    
    rates_norm_avg = squeeze(mean(ratesBlendedNorm));
    rates_norm_n = zeros(size(rates_norm_avg)) + size(ratesBlendedNorm, 1);
    rates_norm_sem = squeeze(std(ratesBlendedNorm)) ./ sqrt(rates_norm_n);
    
    % for deltaMode == 3
    rates_norm_avg2 = squeeze(mean(ratesBlendedNorm2));
    
%     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
    h = errorbar([1:length(rates_norm_avg); 1:length(rates_norm_avg)]' , rates_norm_avg, rates_norm_sem);
    hold on;
    if deltaMode == 3
        % old way
        %         plot(1:length(rates_norm_avg2), rates_norm_avg2(:,2), '--r', 'LineWidth', 2);  
        % for figure:
        errorbar(1:length(rates_norm_avg2), rates_norm_avg2(:,2), rates_norm_sem(:,2), 'b');        
    end
    set(gca, 'TickDir', 'out');
    if isempty(ax)
        set(h(1), 'Color', 'k');
    else
        set(h(1), 'Color', 'b');
    end
    set(h(2), 'Color', 'r');
    h = [mosaicFig h];
    
    
%     
%     function h = makeTuningCurveDelta(indices, useCycles, deltaMode, revSort)
% 
% % make pseudo-tuning curves for odors
% % indices-   indices into global "clusters"
% % useCycles-   which cycles to use, must be even, should be symetrical,
% % i.e. first n/2 are for ctl condition, last n/2 are for LED condition
% % deltaMode-  default 1, seperately baseline ctl and LED conditions to
% % isolate odor-evoked firing, if 0, baselines by ctl baseline firing rate
% 
% % deltaMode- if set to 3 similar to 0, yet it displays as a dotted line the
% % seperately baselined LED condition responses
% 
% % baseline firing rate used is prior to odor period
% % revSort-  reverses sort, useful in case of suppressive odor responses,
% % default is 0 for revSort
%     global clusters
%     
%     if nargin < 2 || isempty(useCycles)
%         useCycles = [];
%     elseif rem(useCycles, 2) ~= 0
%         disp('error in makeConcCurve: useCycles must be even');
%         return
%     end
%     
%     if nargin < 3
%         deltaMode = 1;
%     end
%     
%     if nargin < 4
%         revSort = 0;
%     end
% 
%     if isempty(useCycles)
%         numCycles = size(clusters(indices(1)).analysis.SpikeRate.data, 1);
%         useCycles = [2:numCycles/2 numCycles/2+2:numCycles];
%     end
%     
%     rates = zeros(length(indices), length(useCycles));
%     for i = 1:length(indices)
%         clust = indices(i);
%         rates(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 1).avg];
%         ratesBL(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 2).avg];            
%     end
%     
%     
%     % reshape rates in 3 dimensions so that different units corresponds to rows, different
%     % odors corresponds to columns, and +/- LED corresponds to 3rd
%     % dimension
%     rates = reshape(rates, [length(indices) length(useCycles)/2 2]);
%     ratesBL = reshape(ratesBL, [length(indices) length(useCycles)/2 2]);
%     % sort by ctl conditions (non-LED)
%     sizeRates = size(rates);
%     
%     % sort by columns (2nd dimension) and obtain column subscripts
%     if ~revSort
%         [sorted sortKey] = sort(rates(:,:,1), 2);
%     else
%         [sorted sortKey] = sort(rates(:,:,1), 2, 'descend');
%     end
%     
%     % separate colum subscripts into odds and evens and then concatenate them with
%     % odd's reversed, i.e. for 1:10 --> [ 1:2:9 10:2:2 ]  
%     % -->  1 3 5 7 9 10 8 6 4 2,   to generate a pseudo-tuning curve
%  
%     evens = sortKey(:, 2:2:size(rates, 2));
%     odds = sortKey(:, 1:2:size(rates, 2));
%     sortKey2 = [odds fliplr(evens)];
%     sortKey = sub2ind(size(rates), repmat([1:sizeRates(1)]', [1 sizeRates(2) 2]), repmat(sortKey, [1 1 2]), cat(3, ones(size(rates, 1), size(rates, 2)),...
%         ones(size(rates, 1), size(rates, 2)) + 1));
%     sortKey2 = sub2ind(size(rates), repmat([1:sizeRates(1)]', [1 sizeRates(2) 2]), repmat(sortKey2, [1 1 2]), cat(3, ones(size(rates, 1), size(rates, 2)),...
%         ones(size(rates, 1), size(rates, 2)) + 1));
%     
%     ratesSorted = rates(sortKey);  % do I need this?
%     ratesBlended = rates(sortKey2); % "blended" means turned into a pseudo-tuning curve
%     
%     % generate baseline and max response arrays for baselining and
%     % normalization
%     if deltaMode == 1
%         BLarray = repmat(mean(ratesBL(:,:,:), 2), [1 size(ratesBL, 2)]);
%     elseif deltaMode == 0 || deltaMode == 3
%         BLarray = repmat(mean(ratesBL(:,:,1), 2), [1 size(ratesBL, 2) 2]);
%     end
%     BLarray2 = repmat(mean(ratesBL(:,:,:), 2), [1 size(ratesBL, 2)]);
% %     MAXarray = repmat(max(rates(:,:,1), [], 2), [1 size(ratesBL, 2) 2]);
%     
%     % baseline by mean spontaneous rate for control condition condition for every unit
%     ratesBlendedBL = ratesBlended - BLarray;
%     
%     % for deltaMode 3
%     ratesBlendedBL2 = ratesBlended - BLarray2;
% 
%     
%     % normalize by baseline subtracted max rate, control condition for every unit
% %     ratesBlendedNorm = ratesBlendedBL ./ (MAXarray - BLarray);
%     
%    % make mosaic figure
%     mosaicFig = figure;
%     for i = 1:length(indices)
%         axes; hold on;
%         plot(1:length(useCycles)/2, ratesBlended(i, :, 1), 'k', 1:length(useCycles)/2, ratesBlended(i, :, 2), 'r',...
%             1:length(useCycles)/2, zeros(1, length(useCycles)/2) + BLarray(i, 1, 1), '--k',...
%             1:length(useCycles)/2, zeros(1, length(useCycles)/2) + BLarray(i, 1, 2), '--r'); % raw + baseline values for ctl and LED
% %         plot(1:length(useCycles)/2, ratesBlendedBL(i, :, 1), 'k', 1:length(useCycles)/2, ratesBlendedBL(i, :, 2), 'r'); % baselined
%         clust = indices(i);
%         textBox({[clusters(clust).experiment],...
%             [clusters(clust).trodeName ' C' num2str(clusters(clust).cluster) ' I' num2str(clust)]...
%             }, [], [], 5);
%     end
%     splayAxisTile;
%     
%     %make average figure
%     avgFigure = figure;
%     
%     rates_BL_avg = squeeze(mean(ratesBlendedBL));
%     rates_BL_n = zeros(size(rates_BL_avg)) + size(ratesBlendedBL, 1);
%     rates_BL_sem = squeeze(std(ratesBlendedBL)) ./ sqrt(rates_BL_n);
%     
%     % for deltaMode == 3
%     rates_BL_avg2 = squeeze(mean(ratesBlendedBL2));
%     
% %     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
%     h = errorbar([1:length(rates_BL_avg); 1:length(rates_BL_avg)]' , rates_BL_avg, rates_BL_sem);
%     if deltaMode == 3
%         line
%     set(gca, 'TickDir', 'out');
%     set(h(1), 'Color', 'k');
%     set(h(2), 'Color', 'r');
%     h = [mosaicFig h];
%     
%     
%     
%     