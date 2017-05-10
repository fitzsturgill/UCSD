function plotLEDresponseVsControlFit(r)
%
% INPUT:
%   r: response matrix. Rows are different stimuli/cells; columns are
%   different LED conditions. Control vector is column 1. 

hfig = figure;
addSaveFigTool(hfig)
hax = axes('Parent',hfig);

x = r(:,1);
for i = 3:4
    y = r(:,i);
    minLim = floor(min(min([x y])));
    maxLim = ceil(max(max([x y])));
    l(i-2) = line('XData',x,'YData',y,'Marker','o','MarkerFaceColor','k',...
        'MarkerSize',2,'LineStyle','none','Parent',hax);
    xlim([minLim maxLim]); ylim([minLim maxLim]);
    [tempfit c d] = fit(x,y,'poly1');
    f(i-2) = line('XData',minLim:maxLim,'YData',feval(tempfit,minLim:maxLim));
end

set([l(1) f(1)],'Color','b','MarkerFaceColor','b');
set([l(2) f(2)],'Color','r','MarkerFaceColor','r');

  line('XData',[minLim maxLim],'YData',[minLim maxLim],'Color',[.5 .5 .5],...
        'Parent',hax);
    axis square

% params.matpos = [];                              % [left top width height]
% params.figmargin = [];                           % [left right top bottom]
% params.matmargin = [];                      % [left right top bottom]
params.cellmargin = [.05 .05 .05 .05];        % [left right top bottom]

% setaxesOnaxesmatrix(h,1,length(h),1:length(h),params);
defaultAxes(hax);
set(hax,'XColor','k','YColor','k');

xlabel('LED off (spikes/s)')
ylabel('LED on (spikes/s)')

set(hfig,'Position',[-1013 635 800 369]);


