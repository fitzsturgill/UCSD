function ax = mcChannelHistograms(cycles, h, force)
    global state
    
    if nargin == 0 || isempty(cycles)
        cycles = state.mcViewer.ssb_cycleTable;
    end
    
    if nargin < 2
        figName = [mcExpPrefix 'ChannelHistograms'];
        h = figure('Name', figName);
    end
    
    if nargin < 3
        force = 0;
    end
    
    if ~isempty(state.mcViewer.analysis.tsSpikeTimes) || force
        mcFindPeaks;
        disp('hello');
    end
    state.mcViewer.showThresh = 1;
    updateGUIByGlobal('state.mcViewer.showThresh');
    
    spikeHist = cell(state.mcViewer.nChannels, 1);
    lineColor =state.mcViewer.lineColor;
    gap=.005;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(state.mcViewer.nChannels-1))/state.mcViewer.nChannels;
    start = 1 - delta - start;
    
    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    binEdges = 1:100:state.mcViewer.endX;
    for i = 1:state.mcViewer.nChannels
        if nargin < 2
             ax(i) = axes(...       
                'Parent', h,...
                'XTickLabel', {''},...
                'XTick', [],...
                'Position', [.1 start - (i - 1) * (delta + gap) .8 delta]...
                );
        else
             startX = state.mcViewer.startX / 1000;
             endX = state.mcViewer.endX / 1000;
             ax(i) = axes(...       
                'Parent', h,...
                'YTickLabel', {''},...
                'YTick', [],...
                'XLim', [startX endX]...
                );
        end
        lineStyles = {':', '-', '--', '-.'}; %only so long, doesn't allow for possigbiliity of more than 4 cycles on a row in mcViewer, whatever.
        for j = 1:size(cycles, 1)
            for k = 1:size(cycles, 2)
                if size(cycles, 1) > 1
                    thisColor = lineColor{j};
                    thisStyle = lineStyles{k};
                else
                    thisColor = lineColor{k};
                    thisStyle = '-'; % solid line
                end
                cycle = cycles(j,k);
                filtTrials = trialLookup(cycleLookup == cycle);                
                allSpikes = cat(2, state.mcViewer.analysis.tsSpikeTimes{i, filtTrials});
                spikeHist{i, 1}(j,:) = histc(allSpikes, binEdges);
                line(binEdges(1:end-1)/1000, spikeHist{i, 1}(j, 1:end-1), 'Parent', ax(i), 'Color', thisColor, 'LineStyle', thisStyle);
            end
        end


%         if i == state.mcViewer.nChannels
%             set(h.axes(i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
%         end
%         xlabel('Time (sec)');
        title(['Ch' num2str(i)]);
    end    
    
    
    