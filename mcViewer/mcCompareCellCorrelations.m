function mcCompareCellCorrelations(cycle1, cycle2, x1, x2, binSize)
    global state
    disp('this function needs to be changed- see mcCellCorrelations');
    return
    if nargin < 6
        binSize = 100;  % 100msec bins for instantaneous spike rate determination
    end
    R1 = mcCellCorrelations(cycle1, x1, x2, binSize);
    R2 = mcCellCorrelations(cycle2, x1, x2, binSize);
    
    figure('Name', ['CellCorrelations_' 'c' num2str(cycle1) '_vs_c' num2str(cycle2)]);
    scatter(R1, R2);
    set(gca, 'XLim', [-1 1], 'YLim', [-1 1]);
    addUnityLine;