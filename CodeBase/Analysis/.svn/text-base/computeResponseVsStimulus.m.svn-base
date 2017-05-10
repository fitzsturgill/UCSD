function varargout = computeResponseVsStimulus(spikes,stim,cond,w)
% function varargout = computeResponseVsStimulus(spikes,stim,cond,w)
%
% INPUT
%   spikes: spikes struct
%   stim: stimulus struct with fields: .type, .values, .code (cell array for
%   holding multiple code values)
%   cond: condition struct with fields: .type, .values
%   w: window struct with windows for analysis.  If not supplied entire
%   sweep will be used as window.
%
% OUTPUT
%   varargout{1} = fr: firing rate
%   varargout{2} = nfr: normalized firing rate

% Created: 5/16/10 - SRO


% Make make spikes substruct for each stimulus value and condition value
for m = 1:length(stim.values)
    for n = 1:length(cond.values)
        if strcmp(cond.type,'led')
            spikes = makeTempField(spikes,'led',cond.values{n});
            cspikes(m,n) = filtspikes(spikes,0,'stimcond',stim.code{m},'temp',1);
        else
            cspikes(m,n) = filtspikes(spikes,0,'stimcond',stim.code{m},cond.type,cond.values{n});
        end
    end
end

% Compute average firing rate for each time window
wnames = fieldnames(w);
for m = 1:size(cspikes,1)
    for n = 1:size(cspikes,2)
        for i = 1:length(wnames)
            temp = wnames{i};
            [fr.(temp)(m,n) sem.(temp)(m,n)] = computeFR(cspikes(m,n),w.(temp)); 
        end
    end
end


% Compute normalized firing rate
wnames = fieldnames(fr);
for i = 1:length(wnames)
    temp = wnames{i};
    for n = 1:size(fr.(temp),2)
        nfr.(temp)(:,n) = fr.(temp)(:,n)/max(fr.(temp)(:,n));
    end
end

% Outputs
varargout{1} = fr;
varargout{2} = nfr;
varargout{3} = sem;