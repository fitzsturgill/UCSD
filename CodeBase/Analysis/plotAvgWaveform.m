function varargout = plotAvgWaveform(spikes,hAxes)
%
%
%
%
%

% Created: 6/21/10 - SRO

if nargin < 2
    hAxes = axes;
end

[avgwv maxch] = computeAvgWaveform(spikes.waveforms);
avgwv = reshape(avgwv,numel(avgwv),1);
xdata = 1:length(avgwv);

hLine = line('Parent',hAxes,'XData',xdata,'YData',avgwv,'Color',[0.2 0.2 0.2]);
set(hAxes,'XLim',[0 max(xdata)*1.3],'YLim',[min(avgwv) max(avgwv)])

varargout{1} = hLine;
varargout{2} = hAxes;
varargout{3} = maxch;