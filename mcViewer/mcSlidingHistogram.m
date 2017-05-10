function out = mcSlidingHistogram(data, binEdges, window)
    % REPLACED BY MCSMOOTHEDHISTOGRAM


% binEdges- vector of bin edges of constant increment
% window- size of window for sliding window histogram
% window must be an (odd?) mutliple of binEdges increment
% ex- if binEdges = 1:100:10000
% window could equal 200, 300, 400 but not 450
% similar to histc 



    if ~all(binEdges(1):binEdges(2) - binEdges(1):binEdges(end) == binEdges)
        disp('Error in mcSlidingHistogram: even binEdges increments only!');
        return
    end
    
%     if rem(window, binEdges(2) - binEdges(1)) ~= 0 || rem(window, 2) ~= 1
%         disp('Error in mcSlidingHistogram:');
%         disp('window must be a multiple of binEdges increment');
%         disp('and window must be even');
%         return
%     end



    preHist = histc(data, binEdges);
    
    out = zeros(1, length(binEdges));
    binIncrement = binEdges(2) - binEdges(1);
    offset = (window - binIncrement)/binIncrement/2;  % so if binEdges increment = 5msec and window = 5msec then (5/5) - 1 = 0
    for i = 1:length(binEdges)
        out(1, i) = mean(preHist(max(1, i - offset):min(length(preHist), i + offset)));
    end


