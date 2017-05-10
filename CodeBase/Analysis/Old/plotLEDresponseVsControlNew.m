function plotLEDresponseVsControlNew(ua,rType)
%
% INPUT
%   ua: unit array
%   rType: Set which response to analyze -- 'all' stimuli, 'avg' across
%   stimulus, or 'best' stimulus.

% Created: SRO - 4/26/11

% Make response matrix
[rmat nrmat] = makeResponseMatrix(ua,rType);

% Make figure
hfig = landscapeFigSetup;
addSaveFigTool(hfig)
color = {[0 0 0],[1 0.25 0.25],[0 0 1],[1 0.5 0],[1 0 1],[0 1 0]};
group = {'RS','L2/3','L4','L5','L6','FS'};

% Plot LED on vs off
for m = 1:length(rmat)
    r = rmat{m};
    x = r(:,1);
    for n = 2:size(r,2)
        y = r(:,n);
        minLim = floor(min(min([x y])));
        maxLim = ceil(max(max([x y])));
        if maxLim > 20
            minLim = 0; maxLim = 20;
        end
        h(m,n-1) = axes('Parent',hfig);
        l(m,n-1) = line('XData',x,'YData',y,'Marker','o','MarkerFaceColor','k',...
            'MarkerSize',2,'LineStyle','none','Parent',h(m,n-1));
        xlim([minLim maxLim]); ylim([minLim maxLim]);
        l_unity(m,n-1) = line('XData',[minLim maxLim],'YData',[minLim maxLim],'Color',[.5 .5 .5],...
            'Parent',h(m,n-1));
        [tempfit c d] = fit(x,y,'poly1');
        f(n-1) = line('XData',minLim:maxLim,'YData',feval(tempfit,minLim:maxLim),'Color',[0.6 0.9 1]);
        axis square
        title(['r2 = ' num2str(c.rsquare,2)],'FontSize',6)
    end
    
end

% Plot response as function of LED
if ~strcmp(rType,'all')
    
    for m = 1:length(nrmat)
        r = nrmat{m};
        avg = mean(r);
        sem = std(r)/sqrt(size(r,1));
       
        temp = axes('Parent',hfig);
        h(m,size(rmat,2)) = temp;
        hl = plotCategories(avg,{'','low','','med','','high'},sem,'',temp);  
        set(hl,'Color',color{m});
        title([group{m} ' ' ' n = ' num2str(size(r,1),'%d')],'FontSize',6,'Color',color{m});
        axis square
    end
    
    set(h(:,end),'YLim',[0 1.1])
end


% Position axes

% params.matpos = [];                              % [left top width height]
% params.figmargin = [];                           % [left right top bottom]
% params.matmargin = [];                      % [left right top bottom]
params.cellmargin = [.05 .05 .05 .05];        % [left right top bottom]

setaxesOnaxesmatrix(h,size(h,2),size(h,1),1:numel(h),params);
defaultAxes(h);
set(h,'XColor','k','YColor','k');
