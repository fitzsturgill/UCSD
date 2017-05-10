function mcPlotCellCorr(cycle1, cycle2, contamination, nSpikes, undetected)
    % use in conjunction with mcImportCorrelations
    global cellCorr
    
    if nargin < 5
        undetected = 20;
    end
    if nargin < 4
        nSpikes = 1000;
    end
    if nargin < 3
        contamination = 20;
    end
        
    % note: cycles are in 1st dimension, odor and basline period in 2nd
    % dimension
    % E.g. size(cellCorr(i).quality.contamination)  =  8 2   ... This would
    % mean that there are 8 cycles and (as always) a odor and baseline
    % period, baseline period is second.
    cyc1=[];
    cyc2=[];
    cyc1Eq=[];
    cyc2Eq=[];
    
    cyc1BL=[];
    cyc2BL=[];
    cyc1EqBL=[];
    cyc2EqBL=[];
    for i = 1:length(cellCorr)
        % generate indices of cell-cell correlations that meet criteria for
        % every experiment
        
        a = cellCorr(i).quality.contamination < contamination;
        b = cellCorr(i).quality.nSpikes > nSpikes;
        c = cellCorr(i).quality.undetected < undetected;
        indices = a .* b .* c;
        indices = indices(:,1) .* indices(:,2); % both elements of pair must meet criteria
        indices = logical(indices'); % convert to row vector
        
        cyc1 = [cyc1 cellCorr(i).R{cycle1, 1}(indices)];
        cyc2 = [cyc2 cellCorr(i).R{cycle2, 1}(indices)];
        cyc1Eq = [cyc1Eq cellCorr(i).REq{cycle1, 1}(indices)];
        cyc2Eq = [cyc2Eq cellCorr(i).REq{cycle2, 1}(indices)];
        
        cyc1BL = [cyc1BL cellCorr(i).R{cycle1, 1}(indices)];
        cyc2BL = [cyc2BL cellCorr(i).R{cycle2, 1}(indices)];
        cyc1EqBL = [cyc1EqBL cellCorr(i).REq{cycle1, 1}(indices)];
        cyc2EqBL = [cyc2EqBL cellCorr(i).REq{cycle2, 1}(indices)];        
        
    end
    
    assignin('base', ['cellCorr_cyc' num2str(cycle1) '_odor'], cyc1);
    assignin('base', ['cellCorr_cyc' num2str(cycle2) '_odor'], cyc2);
    assignin('base', ['cellCorr_cyc' num2str(cycle1) '_odor_Eq'], cyc1Eq);
    assignin('base', ['cellCorr_cyc' num2str(cycle2) '_odor_Eq'], cyc2Eq);

    assignin('base', ['cellCorr_cyc' num2str(cycle1) '_BL'], cyc1BL);
    assignin('base', ['cellCorr_cyc' num2str(cycle2) '_BL'], cyc2BL);
    assignin('base', ['cellCorr_cyc' num2str(cycle1) '_BL_Eq'], cyc1EqBL);
    assignin('base', ['cellCorr_cyc' num2str(cycle2) '_BL_Eq'], cyc2EqBL);
    
    
    figure('Name', ['cellCorrelations_cyc' num2str(cycle1) '_VS_cyc' num2str(cycle2) '_odor']);
    scatter(cyc1, cyc2);
    title(['Cell Correlations: cyc' num2str(cycle1) ' vs. ' 'cyc' num2str(cycle2) ' Odor Period']);
    xlabel(['cycle '  num2str(cycle1)]);
    ylabel(['cycle '  num2str(cycle2)]);
    set(gca, 'XLim', [-1 1]);
    set(gca, 'YLim', [-1 1]);    
    addUnityLine;
    
    figure('Name', ['cellCorrelations_cyc' num2str(cycle1) '_VS_cyc' num2str(cycle2) '_odor_Eq']);
    scatter(cyc1Eq, cyc2Eq);
    title(['Cell Correlations: cyc' num2str(cycle1) ' vs. ' 'cyc' num2str(cycle2) ' Odor Period, Spike Rate Normalized']);    
    xlabel(['cycle '  num2str(cycle1)]);
    ylabel(['cycle '  num2str(cycle2)]);
    set(gca, 'XLim', [-1 1]);
    set(gca, 'YLim', [-1 1]);    
    addUnityLine;    
    
    figure('Name', ['cellCorrelations_cyc' num2str(cycle2) '_VS_cyc' num2str(cycle1) '_BL']);
    scatter(cyc2BL, cyc1BL);
    title(['Cell Correlations: cyc' num2str(cycle2) ' vs. ' 'cyc' num2str(cycle1) ' Baseline Period']);    
    xlabel(['cycle '  num2str(cycle2)]);
    ylabel(['cycle '  num2str(cycle1)]);
    set(gca, 'XLim', [-1 1]);
    set(gca, 'YLim', [-1 1]);    
    addUnityLine;   
    
    figure('Name', ['cellCorrelations_cyc' num2str(cycle2) '_VS_cyc' num2str(cycle1) '_BL_Eq']);
    scatter(cyc2EqBL, cyc1EqBL);    
    title(['Cell Correlations: cyc' num2str(cycle2) ' vs. ' 'cyc' num2str(cycle1) ' Baseline Period, Spike Rate Normalized']);    
    xlabel(['cycle '  num2str(cycle2)]);
    ylabel(['cycle '  num2str(cycle1)]);
    set(gca, 'XLim', [-1 1]);
    set(gca, 'YLim', [-1 1]);    
    addUnityLine;    
        
        