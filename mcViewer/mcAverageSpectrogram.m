
function [ax im] = mcAverageSpectrogram(channel, cyclePositions, h)
% function [ax im] = mcAverageSpectrogram(channel, cyclePositions, h)
% creates a spectrogram (chronux derived) for every cycle position.  Color
% scale determined within mcViewer according to sg LUT property... (or
% whatever it is called)
% ax - row vector of axes handles
% im-  row vector of image handles
% h -- handle of figure, if not provided a figure is created
    global state gh
    
    
    if nargin < 3
        figName = [mcExpPrefix 'Spectrogram'];
        h = figure('Name', figName);
    end
    
    if nargin < 2
        cyclePositions = state.mcViewer.ssb_cycleTable;
    end
    
    if nargin < 1
        channel = state.mcViewer.sg_channel;
    end
    

    
    TW = state.mcViewer.sg_TW;
    p = state.mcViewer.sg_p;
    params = struct(...
        'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
        'Fs', state.mcViewer.sampleRate * 1000,...
        'fpass', [0 100],...
        'trialave', 1 ...
        );
    movingwin = [state.mcViewer.sg_width state.mcViewer.sg_step];  
    
    % parameters for ticks on spectrogram
%     nTicksY = round((params.fpass(2) - params.fpass(1))/10) + 1;
%     nTicksX = round((state.mcViewer.endX - state.mcViewer.startX)/1000) + 1;    
    
    % invert to draw cycles by rows rather than columns in case
    % cyclePositions is derived from ssb_cycleTable
    cyclePositions = cyclePositions';
    for i = 1:numel(cyclePositions)
        trials  = mcTrialsByCycle(cyclePositions(i));
        if i==1 && isempty(trials)
            return 
        end
        data = cat(3, state.mcViewer.tsData{1, trials});
        data = squeeze(data(:, channel, :));
        data = diff(data);
        [sg, tg, fg] = mtspecgramc(data, movingwin, params);
        
%         sg = mean(sg, 3);
%         ax(1, i) = axes('YDir', 'reverse');
          ax(1, i) = axes;
        
        im(1, i) = image(tg, fg, sg', 'CDataMapping', 'Scaled', 'Parent', ax(1, i));
        

        
        set(ax(1, i), 'Clim', [0 get(gh.sgBrowser.sg_ClimSlider, 'Value')], 'YDir', 'normal', 'TickDir', 'out');  % set Clim to current sgBrowser setting
%         Xticks = round(linspace(0, (state.mcViewer.endX - state.mcViewer.startX)/1000, nTicksX) * 10) / 10;
%         Yticks = round(linspace(params.fpass(1), params.fpass(2), nTicksY) * 10) / 10;
%         set(ax(1, i),...
%             'XTick', Xticks,...
%             'YTick', Yticks...
%             );
        title(['Ch' num2str(channel) ' Cycle:' num2str(cyclePositions(i))]);
    end
    if nargin < 3
        params.matpos = [0.02 0.02 .96 .96];
        params.cellmargin = [.05 .05 .05 .05];
%         rows=size(cyclePositions, 2); % remember- we've inverted cyclePositions
%         columns=size(cyclePositions, 1); % ditto
        rows=ceil(sqrt(numel(cyclePositions))); 
        columns=rows;
        setaxesOnaxesmatrix(ax, rows, columns, 1:length(find(cyclePositions)), params, h, 1);
    end
    
    
    
    

% function [ax im] = mcAverageSpectrogram(channel, cyclePositions, h)
% % function [ax im] = mcAverageSpectrogram(channel, cyclePositions, h)
% % creates a spectrogram (chronux derived) for every cycle position.  Color
% % scale determined within mcViewer according to sg LUT property... (or
% % whatever it is called)
% % ax - row vector of axes handles
% % im-  row vector of image handles
% % h -- handle of figure, if not provided a figure is created
%     global state gh
%     
%     
%     if nargin < 3
%         figName = [mcExpPrefix 'Spectrogram'];
%         h = figure('Name', figName);
%     end
%     
%     if nargin < 2
%         cyclePositions = state.mcViewer.ssb_cycleTable;
%     end
%     
%     if nargin < 1
%         channel = state.mcViewer.sg_channel;
%     end
%     
% 
%     
%     TW = state.mcViewer.sg_TW;
%     p = state.mcViewer.sg_p;
%     params = struct(...
%         'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
%         'Fs', state.mcViewer.sampleRate * 1000,...
%         'fpass', [0 80],...
%         'trialave', 1 ...
%         );
%     movingwin = [state.mcViewer.sg_width state.mcViewer.sg_step];  
%     
%     % parameters for ticks on spectrogram
%     nTicksY = round((params.fpass(2) - params.fpass(1))/10) + 1;
%     nTicksX = round((state.mcViewer.endX - state.mcViewer.startX)/1000) + 1;    
%     
%     % invert to draw cycles by rows rather than columns in case
%     % cyclePositions is derived from ssb_cycleTable
%     cyclePositions = cyclePositions';
%     for i = 1:numel(cyclePositions)
%         trials  = mcTrialsByCycle(cyclePositions(i));
%         if i==1 && isempty(trials)
%             return 
%         end
%         data = cat(3, state.mcViewer.tsData{1, trials});
%         data = squeeze(data(:, channel, :));
%         data = diff(data);
%         [sg, tg, fg] = mtspecgramc(data, movingwin, params);
%         
% %         sg = mean(sg, 3);
% %         ax(1, i) = axes('YDir', 'reverse');
%           ax(1, i) = axes;
%         
%         im(1, i) = image(sg', 'CDataMapping', 'Scaled', 'Parent', ax(1, i));
%         
%         set(ax(1, i), 'Clim', [0 get(gh.sgBrowser.sg_ClimSlider, 'Value')], 'YDir', 'normal', 'TickDir', 'out');  % set Clim to current sgBrowser setting
%         Xticks = linspace(1, length(tg), nTicksX);
%         Yticks = linspace(1, length(fg), nTicksY);
%         XtickLabels = round(linspace(0, (state.mcViewer.endX - state.mcViewer.startX)/1000, nTicksX) * 10) / 10;
%         YtickLabels = round(linspace(params.fpass(1), params.fpass(2), nTicksY) * 10) / 10;
%         set(ax(1, i),...
%             'XTick', Xticks,...
%             'YTick', Yticks,...
%             'XTickLabel', XtickLabels,...
%             'YTickLabel', YtickLabels...
%             );
%         title(['Ch' num2str(channel) ' Cycle:' num2str(cyclePositions(i))]);
%     end
%     if nargin < 3
%         params.matpos = [0.02 0.02 .96 .96];
%         params.cellmargin = [.05 .05 .05 .05];
%         rows=size(cyclePositions, 2); % remember- we've inverted cyclePositions
%         columns=size(cyclePositions, 1); % ditto
%         setaxesOnaxesmatrix(ax, rows, columns, 1:length(find(cyclePositions)), params, h);
%     end
%     
%         
    