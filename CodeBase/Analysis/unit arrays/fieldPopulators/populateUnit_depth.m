function unit = populateUnit_depth(unit, curExpt, curTrodeSpikes,varargin)


% Abbreviate
expt = curExpt;
s = curTrodeSpikes;

% Get unit trode number and assign
trode_num = unit.trode_num;
assign = unit.assign;

% Filter spikes on assign
s = filtspikes(s,0,'assigns',assign);

% Find depth
unit.depth = getDepth(expt,s,trode_num);


% Subfunction
function depth = getDepth(expt,spikes,trode_num)

% Compute average waveform
avgwv = mean(spikes.waveforms);
avgwv = squeeze(avgwv);

% Get max channel
temp = min(min(avgwv));
k = find(min(avgwv) == temp);
maxch = k;

probe = expt.probe;
trodeSites = expt.sort.trode(trode_num).channels;
siteNum = trodeSites(maxch);
if ~isempty(probe.sitedepth)
    depth = round(probe.sitedepth(probe.channelorder == siteNum));
else
    depth = NaN;
end








