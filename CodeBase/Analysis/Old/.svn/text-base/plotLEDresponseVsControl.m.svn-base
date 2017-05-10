function plotLEDresponseVsControl(r)
%
% INPUT:
%   r: response matrix. Rows are different stimuli/cells; columns are
%   different LED conditions. Control vector is column 1. 

hfig = figure;
addSaveFigTool(hfig)

x = r(:,1);
for i = 2:size(r,2)
    y = r(:,i);
    minLim = floor(min(min([x y])));
    maxLim = ceil(max(max([x y])));
    h(i-1) = axes('Parent',hfig);
    l(i-1) = line('XData',x,'YData',y,'Marker','o','MarkerFaceColor','k',...
        'MarkerSize',2,'LineStyle','none','Parent',h(i-1));
    xlim([minLim maxLim]); ylim([minLim maxLim]);
    l_unity(i-1) = line('XData',[minLim maxLim],'YData',[minLim maxLim],'Color',[.5 .5 .5],...
        'Parent',h(i-1));
    axis square
end

% params.matpos = [];                              % [left top width height]
% params.figmargin = [];                           % [left right top bottom]
% params.matmargin = [];                      % [left right top bottom]
params.cellmargin = [.05 .05 .05 .05];        % [left right top bottom]

setaxesOnaxesmatrix(h,1,length(h),1:length(h),params);
defaultAxes(h);
set(h,'XColor','k','YColor','k');

set(hfig,'Position',[-1013 635 800 369]);


