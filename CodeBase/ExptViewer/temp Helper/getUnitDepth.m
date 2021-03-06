function depth = getUnitDepth(expt,unitTag,maxch,method)
%
%
%
%

% Created: SRO - 7/7/10

if nargin < 4
    method = 1;
end

try
    
switch method
    
    case 1

% Get tetrode number and unit index from unit tag
loc = strfind(unitTag,'_');
trodeNum = str2num(unitTag(loc-1));
unitInd = str2num(unitTag(loc+1:end));

% Get probe struct
probe = expt.probe;
trodeSites = expt.sort.trode(trodeNum).channels;
siteNum = trodeSites(maxch);
if ~isempty(probe.sitedepth)
    depth = round(probe.sitedepth(probe.channelorder == siteNum));
else
    depth = NaN;
end

    case 2
        probe = expt.probe;
        k = find(probe.channelorder == maxch);
        depth = round(probe.sitedepth(k));
end

catch
    depth = 0;
    disp('Site depth not computed')
end




