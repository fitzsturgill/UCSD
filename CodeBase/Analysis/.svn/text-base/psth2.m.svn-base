function [n centers edges] = psth2(spikes,binsize)
% function [n centers edges] = psth2(spikes,binsize)
%
%
%
%

% Created: SRO - 5/5/11

if nargin < 2
    binsize = 50;
end


% Set duration and number of trials
duration = max(spikes.info.detect.dur);     % Maybe add checking for equal sweep durations?
numtrials = length(spikes.sweeps.trials);

% Set spiketimes
spiketimes = spikes.spiketimes;

% Convert binsize from s to ms
binsize = binsize/1000;

% Get counts
edges = 0:binsize:duration;
n = histc(spiketimes,edges);
n = n/numtrials/binsize;

if all(isnan(n))
    n = 0;
end

% Compute center of bins
centers = edges + diff(edges(1:2))/2;

% Output (Remove last point, which contains values that fall directly on
% edge of last bin)
n = (n(1:end-1))';
centers = (centers(1:end-1))';
edges = edges';



