function mcMakeChannelPlots
    global state
    
    if ishandle(state.mcViewer.mcFigure)
        clf(state.mcViewer.mcFigure);
    else
        state.mcViewer.mcFigure = figure(...
            'doublebuffer', 'on',...
            'KeyPressFcn', 'mcFigureKeyPressFunction',...
            'Tag', 'mcFigure',...
            'Name', 'mcFigure',...
            'MenuBar', 'figure',...
            'CloseRequestFcn', 'set(gcf, ''visible'', ''off'')'...
            );
    end
    validChannels=find(mcChannelFieldToVector('mcFigureInclude'));
    state.mcViewer.displayedChannels = validChannels;
    nValidChannels = length(validChannels);
    gap=.005;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(nValidChannels-1))/nValidChannels;    
    start = 1 - delta - start;
    

    state.mcViewer.axes = zeros(1, nValidChannels) + -1;
    state.mcViewer.lines = zeros(1, nValidChannels) + -1;
    state.mcViewer.threshLines = zeros(1, nValidChannels) + -1;
    state.mcViewer.respirationLines = zeros(1, nValidChannels) + -1;
    state.mcViewer.respirationLinesShifted = zeros(1, nValidChannels) + -1;    

%     subplot(gh.mcFigure.figure1);
% Plot multichannel channels selected for display
    for i = 1:nValidChannels
        channel = validChannels(i);
%         state.mcViewer.axes(1, i) = subplot(state.mcViewer.nChannels, 1, i,...
        state.mcViewer.axes(1, i) = axes(...
            'NextPlot', 'add',...
            'Parent', state.mcViewer.mcFigure,...
            'Xtick', [],...
            'XTickLabel', {''}...
            );
%         startX = state.mcViewer.startX;
%         deltaX = 1/state.mcViewer.sampleRate;
%         endX = state.mcViewer.startX + deltaX * (size(state.mcViewer.displayData, 2)-1);
        state.mcViewer.lines(1, i) = line(...
            state.mcViewer.displayXData, ... % xdata scaled appropriately
            state.mcViewer.displayData(:, channel),... % ydata FS MOD
            'Parent', state.mcViewer.axes(1, i)...
            );
        if channel <= state.mcViewer.nChannels
            state.mcViewer.threshLines(1, i) = line(...
                state.mcViewer.displayXData, ... % xdata scaled appropriately
                state.mcViewer.displayThreshData(:, channel),... % ydata FS MOD
                'Parent', state.mcViewer.axes(1, i),...
                'Color', 'm',...
                'LineStyle', ':'...
                );
        end
        set(state.mcViewer.axes(1, i), ...
            'Xtick', [],...
            'XTickLabel', {''},...
            'Position', [.1 start - (i - 1) * (delta + gap) .8 delta]...
            );
%         get(state.mcViewer.axes(1, i), 'Position')
        ylabel(state.mcViewer.axes(1, i), state.mcViewer.channel(channel).Name);
        if i == nValidChannels
            set(state.mcViewer.axes(1, i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
        end        
    end
            

% axes(h, 'Position', [left bottom width height]);


%% Backup: before implementation of channel structure
% function mcMakeChannelPlots
%     global state
%     
%     if ishandle(state.mcViewer.mcFigure)
%         clf(state.mcViewer.mcFigure);
%     else
%         state.mcViewer.mcFigure = figure(...
%             'doublebuffer', 'on',...
%             'KeyPressFcn', 'mcFigureKeyPressFunction',...
%             'Tag', 'mcFigure',...
%             'Name', 'mcFigure',...
%             'MenuBar', 'figure',...
%             'CloseRequestFcn', 'set(gcf, ''visible'', ''off'')'...
%             );
%     end
%     
%     gap=.005;
%     start=.05;
%     height = 1 - start*2;
%     delta=(height-gap*(state.mcViewer.nChannels-1))/state.mcViewer.nChannels;    
%     start = 1 - delta - start;
%     
% 
%     state.mcViewer.axes = zeros(1, state.mcViewer.nChannels);
%     state.mcViewer.lines = zeros(1, state.mcViewer.nChannels);
%     state.mcViewer.threshLines = zeros(1, state.mcViewer.nChannels);
% 
% %     subplot(gh.mcFigure.figure1);
%     for i = 1:state.mcViewer.nChannels
% %         state.mcViewer.axes(1, i) = subplot(state.mcViewer.nChannels, 1, i,...
%         state.mcViewer.axes(1, i) = axes(...
%             'NextPlot', 'add',...
%             'Parent', state.mcViewer.mcFigure,...
%             'Xtick', [],...
%             'XTickLabel', {''}...
%             );
%         
% %         startX = state.mcViewer.startX;
% %         deltaX = 1/state.mcViewer.sampleRate;
% %         endX = state.mcViewer.startX + deltaX * (size(state.mcViewer.displayData, 2)-1);
%         state.mcViewer.lines(1, i) = line(...
%             state.mcViewer.displayXData, ... % xdata scaled appropriately
%             state.mcViewer.displayData(:, i),... % ydata FS MOD
%             'Parent', state.mcViewer.axes(1, i)...
%             );
%         state.mcViewer.threshLines(1, i) = line(...
%             state.mcViewer.displayXData, ... % xdata scaled appropriately
%             state.mcViewer.displayThreshData(:, i),... % ydata FS MOD
%             'Parent', state.mcViewer.axes(1, i),...
%             'Color', 'm',...
%             'LineStyle', ':'...
%             );        
%         set(state.mcViewer.axes(1, i), ...
%             'Xtick', [],...
%             'XTickLabel', {''},...
%             'Position', [.1 start - (i - 1) * (delta + gap) .8 delta]...
%             );
% %         get(state.mcViewer.axes(1, i), 'Position')
%         ylabel(state.mcViewer.axes(1, i), ['Ch' num2str(i)]);
%         if i == state.mcViewer.nChannels
%             set(state.mcViewer.axes(1, i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
%         end        
%     end
%             
% 
% % axes(h, 'Position', [left bottom width height]);
            