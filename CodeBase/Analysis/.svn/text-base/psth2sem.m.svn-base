function [n_avg n_sem centers edges n] = psth2sem(spikes,binsize)
% function [n_avg n_sem centers edges n] = psth2sem(spikes,binsize)
%
% INPUT
%
% OUTPUT
%

% Created: SRO - 6/22/11

if nargin < 2
    binsize = 50;
end


% Set duration and number of trials
duration = max(spikes.info.detect.dur);     % Maybe add checking for equal sweep durations?
numtrials = length(spikes.sweeps.trials);

% Convert binsize from s to ms
binsize = binsize/1000;

% Set edges
    edges = 0:binsize:duration;

% Make PSTH for each trial
for i = 1:numtrials
    
    s = filtspikes(spikes,0,'trials',spikes.sweeps.trials(i));
    % Set spiketimes
    spiketimes = s.spiketimes;
    
    % Get counts
    tmp_n = histc(spiketimes,edges);
    if isempty(tmp_n)
        tmp_n = size(tmp_n);
        tmp_n = zeros([1 tmp_n(1)]);
    end
    n(:,i) = tmp_n'/binsize;
    
end

if all(isnan(n))
    n = 0;
end

% Compute center of bins
centers = edges + diff(edges(1:2))/2;

% Output (Remove last point, which contains values that fall directly on
% edge of last bin)
n = n(1:end-1,:);
centers = (centers(1:end-1))';
edges = edges';

% Compute mean and sem
[n_avg n_sem] = avgSem(n,2);






