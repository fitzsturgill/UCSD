function makeConcCurve(indices, useCycles, odorEvokedLED, concentrations)

% June 2014- bug doesn't seem to be present now- good... not sure what the
% deal is...   be careful though...

% concentrations- concentrations on X axis

% CODE HAS BUG IN IT FROM NEW BASELININIG METHOD- MAY 2014, DON'T USE UNTIL
% FIXED
    % for 7 odors experiments, leaving out cycle 2 which had residual odor
    % in the tubing
    
    % NOW BASELINED BY AVERAGE OF BASELINE PERIOD FIRING RATES INSTEAD OF
    % AIR TRIAL SO THAT FIRST CONCENTRATION (Oppm) HAS VARIABILITY BUT AN
    % AVERAGE == 0
    global clusters
    
%     disp('this code has a bug in it from changing to new baselining method');
    if nargin < 2 || isempty(useCycles)
        useCycles = [1 3:7 8 10:14]; 
    elseif rem(useCycles, 2) ~= 0
        disp('error in makeConcCurve: useCycles must be even');
        return
    end
    
    if nargin < 3
        odorEvokedLED = 0;  % also calculate odor evoked, normalized curve for LED condition and plot as dashed red line
    end
    
    if nargin < 4
        concentrations=[];
    end

    
    rates = zeros(length(indices), length(useCycles));
    ratesBL = zeros(length(indices), length(useCycles));    
    
    for i = 1:length(indices)
        clust = indices(i);
        rates(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 1).avg];
        ratesBL(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 2).avg];        
    end
    
    % reshape rates in 3 dimensions so that different units corresponds to rows, different
    % concentrations corresponds to columns, and +/- LED corresponds to 3rd
    % dimension
    rates = reshape(rates, [length(indices) length(useCycles)/2 2]);
    ratesBL = reshape(ratesBL, [length(indices) length(useCycles)/2 2]);    
    BLarray = repmat(mean(ratesBL(:,:,1), 2), [1 size(ratesBL, 2) 2]);
    BLarray2 = repmat(mean(ratesBL(:,:,:), 2), [1 size(ratesBL, 2)]);    
    % baseline by null odor control condition for every unit
    rates_baseline = rates - BLarray;
    % baseline by each condition independently for odorEvokedLED
    % null odor control condition = column 1    null odor LED condition =
    % column 8
    rates_baseline2 = rates - BLarray2;
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
    % for odorEvokedLED
    rates_norm_avg2 = squeeze(mean(rates_norm2));    
    
%     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
    if isempty(concentrations)
        errorbar([1:size(rates_norm_avg, 1); 1:size(rates_norm_avg, 1)]' , rates_norm_avg, rates_norm_sem);
        if odorEvokedLED
            plot(1:size(rates_norm_avg2, 1), rates_norm_avg2(:,2), '--r', 'LineWidth', 2);
        end
    else
        errorbar([concentrations; concentrations]' , rates_norm_avg, rates_norm_sem);
        if odorEvokedLED
            plot(concentrations, rates_norm_avg2(:,2), '--r', 'LineWidth', 2);
        end
    end
    
    %% old way of baselinning by air trial, new way is with baseline period
   
%     function makeConcCurve(indices, useCycles, odorEvokedLED)
%     % for 7 odors experiments, leaving out cycle 2 which had residual odor
%     % in the tubing
%     global clusters
%     
%     if nargin < 2 || isempty(useCycles)
%         useCycles = [1 3:7 8 10:14]; 
%     elseif rem(useCycles, 2) ~= 0
%         disp('error in makeConcCurve: useCycles must be even');
%         return
%     end
%     
%     if nargin < 3
%         odorEvokedLED = 0;  % also calculate odor evoked, normalized curve for LED condition and plot as dashed red line
%     end
% 
%     
%     rates = zeros(length(indices), length(useCycles));
%     for i = 1:length(indices)
%         clust = indices(i);
%         rates(i, :) = [clusters(clust).analysis.SpikeRate.data(useCycles, 1).avg];
%     end
%     
%     % reshape rates in 3 dimensions so that different units corresponds to rows, different
%     % concentrations corresponds to columns, and +/- LED corresponds to 3rd
%     % dimension
%     rates = reshape(rates, [length(indices) length(useCycles)/2 2]);
%     
%     % baseline by null odor control condition for every unit
%     rates_baseline = rates - repmat(rates(:,1,1), [1 size(rates, 2) size(rates, 3)]);
%     % baseline by each condition independently for odorEvokedLED
%     % null odor control condition = column 1    null odor LED condition =
%     % column 8
%     rates_baseline2 = rates - repmat(rates(:,1,:), [1 size(rates, 2)]);
%     % normalize by highest concentration, control condition for every unit
%     rates_norm = rates_baseline ./ repmat(rates_baseline(:, size(rates_baseline, 2), 1), [1 size(rates, 2) size(rates, 3)]);
%     % for odorEvokedLED
%     rates_norm2 = rates_baseline2 ./ repmat(rates_baseline2(:, size(rates_baseline2, 2), 1), [1 size(rates, 2) size(rates, 3)]);
%     
%     % make mosaic figure
%     mosaicFig = figure;
%     for i = 1:length(indices)
%         axes; hold on;
%         plot([rates(i, :, 1)' rates(i, :, 2)']);
%     end
%     splayAxisTile;
%     
%     %make average figure
%     avgFigure = figure; hold on
%     
%     rates_norm_avg = squeeze(mean(rates_norm));
%     rates_norm_n = zeros(size(rates_norm_avg)) + size(rates_norm, 1);
%     rates_norm_sem = squeeze(std(rates_norm)) ./ sqrt(rates_norm_n);
%     % for odorEvokedLED
%     rates_norm_avg2 = squeeze(mean(rates_norm2));    
%     
% %     errorbar(repmat((useCycles(1:length(useCycles)/2))', 1, 2) , rates_norm_avg, rates_norm_sem);
%     errorbar([1:size(rates_norm_avg, 1); 1:size(rates_norm_avg, 1)]' , rates_norm_avg, rates_norm_sem);
%     if odorEvokedLED
%         plot(1:size(rates_norm_avg2, 1), rates_norm_avg2(:,2), '--r', 'LineWidth', 2);
%     end
%     
%     
%     
%     
%     
%     