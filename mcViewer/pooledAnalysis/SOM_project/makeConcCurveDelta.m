function makeConcCurveDelta(indices, useCycles, deltaMode)
    % I used this function for SOM unit concentration curve in paper


    % for 7 odors experiments, leaving out cycle 2 which had residual odor
    % in the tubing
    
    % deltaMode == 1 --> baseline by ctl rate prior to normalization
    % deltamode == 2 --> baseline by ctl or LED rate for ctl and LED
    % conditions, respectively prior to normalization
    
    % deltaMode == 3 --> like 1, but with odor evoked plotted seperately
    % for LED condition
    global clusters
    
    if nargin < 2 || isempty(useCycles)
        useCycles = [1 3:7 8 10:14]; 
    elseif rem(useCycles, 2) ~= 0
        disp('error in makeConcCurve: useCycles must be even');
        return
    end
    
    if nargin < 3
        deltaMode = 1;  % also calculate odor evoked, normalized curve for LED condition and plot as dashed red line
    end

    
    rates = zeros(length(indices), length(useCycles));
    for i = 1:length(indices)
        clust = indices(i);
        rates(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 1).avg];
    end
    
    % reshape rates in 3 dimensions so that different units corresponds to rows, different
    % concentrations corresponds to columns, and +/- LED corresponds to 3rd
    % dimension
    rates = reshape(rates, [length(indices) length(useCycles)/2 2]);
    
    % baseline by null odor control condition for every unit
    rates_baseline = rates - repmat(rates(:,1,1), [1 size(rates, 2) size(rates, 3)]);
    % baseline by each condition independently for odorEvokedLED
    % null odor control condition = column 1    null odor LED condition =
    % column 8
    rates_baseline2 = rates - repmat(rates(:,1,:), [1 size(rates, 2)]);
    % normalize by highest concentration, control condition for every unit
    rates_norm = rates_baseline ./ repmat(rates_baseline(:, size(rates_baseline, 2), 1), [1 size(rates, 2) size(rates, 3)]);
    % for odorEvokedLED
    rates_norm2 = rates_baseline2 ./ repmat(rates_baseline2(:, size(rates_baseline2, 2), 1), [1 size(rates, 2) size(rates, 3)]);
    
    % make mosaic figure
    mosaicFig = figure;
    for i = 1:length(indices)
        axes; hold on;
        plot([rates(i, :, 1)' rates(i, :, 2)']);
    end
    splayAxisTile;
    
    %make average figure
    avgFigure = figure; hold on
    
    rates_norm_avg = squeeze(mean(rates_norm));
    rates_norm_n = zeros(size(rates_norm_avg)) + size(rates_norm, 1);
    rates_norm_sem = squeeze(std(rates_norm)) ./ sqrt(rates_norm_n);
    % for deltaMode == 2 or == 3
    rates_norm_avg2 = squeeze(mean(rates_norm2));    
    rates_norm_n2 = zeros(size(rates_norm_avg2)) + size(rates_norm2, 1);    
    rates_norm_sem2 = squeeze(std(rates_norm2)) ./ sqrt(rates_norm_n2);    
    
%     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
    if deltaMode == 1 || deltaMode == 3
        errorbar([1:size(rates_norm_avg, 1); 1:size(rates_norm_avg, 1)]' , rates_norm_avg, rates_norm_sem);
    else % deltaMode is 2
        errorbar([1:size(rates_norm_avg, 1); 1:size(rates_norm_avg, 1)]' , rates_norm_avg2, rates_norm_sem2);
    end
    if deltaMode==3
        plot(1:size(rates_norm_avg2, 1), rates_norm_avg2(:,2), '--r', 'LineWidth', 2);
    end
    
    
    
    
    
    