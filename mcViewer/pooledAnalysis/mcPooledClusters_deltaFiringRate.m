function [cyc1 cyc2] = mcPooledClusters_deltaFiringRate(show) % just assuming that I'm usting an odor trapezoid protocol, 2 cycles
% returns cyc1 cyc2 as arrays of size  2, length(clusters) First row contains
% basline period, second row contains odor period.  x denotes cycle 1 y
% denotes cycle 2
    global clusters
    
    if nargin < 1
        show = ones(1, length(clusters)); % just show them all
    end
    
    cyc1 = zeros(2,length(show));
    cyc2 = zeros(2, length(show));
    
    for i = 1:length(show)
        baseline = [clusters(i).analysis.SpikeRate.baseline(:).avg]; % should be size 1,2
        rates = [clusters(i).analysis.SpikeRate.data(:).avg]; % should be size 1,4
        
        cyc1(1, i) = rates(1, 3) - baseline(1,1);
        cyc2(1, i) = rates(1, 4) - baseline(1,2);
    
        cyc1(2, i) = rates(1, 1) - baseline(1,1);
        cyc2(2, i) = rates(1, 2) - baseline(1,2);
    end
    
    
    