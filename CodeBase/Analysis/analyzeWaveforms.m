function ua = analyzeWaveforms(ua)
%
%
%
%
%
%

% Created: SRO - 4/26/11


% Extract spike parameters
tpratio = [];
tp_time = [];
width = [];
all_avgwaves = [];
for i = 1:length(ua)
    tpratio = [tpratio; ua(i).waveform.troughpeakratio];
    tp_time = [tp_time; ua(i).waveform.tp_time];
    width = [width; ua(i).waveform.width];
    all_avgwaves = [all_avgwaves ua(i).waveform.avgwave];  
end

% Plot data
if bplot
    hfig = figure;
    ax(1) = axes('Parent',hfig);
    l(1) = line('XData',tp_time,'YData',tpratio,'LineStyle','none','Marker','o');
    ax(2) = axes('Parent',hfig);
    l(2) = line('XData',width,'YData',tpratio,'LineStyle','none','Marker','o');
    
    setAxesOnaxesmatrix(ax,2,1,1:2);
    figure; hist(width,10)
end


