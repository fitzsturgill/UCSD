function h = mcMakeHistogram(fileNumbers, binEdges, figName)
% add additional rows to fileNumbers to group, for example, by condition.
    global state
    
    mcFindPeaks;
    state.mcViewer.showThresh = 1;
    updateGUIByGlobal('state.mcViewer.showThresh');
    h.figure = figure('Name', figName);
    
    spikeHist = cell(state.mcViewer.nChannels, 1);
    lineColor = {'b', 'g', 'r', 'm', 'b'};
    gap=.005;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(state.mcViewer.nChannels-1))/state.mcViewer.nChannels;
    start = 1 - delta - start;
    
    
    for i = 1:state.mcViewer.nChannels
         h.axes(i) = axes(...       
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [.1 start - (i - 1) * (delta + gap) .8 delta]...
            );
        for j = 1:size(fileNumbers, 1)
            allSpikes = cat(2, state.mcViewer.analysis.tsSpikeTimes{i, fileNumbers(j, :)});
            spikeHist{i, 1}(j,:) = histc(allSpikes, binEdges);
            line(binEdges, spikeHist{i, 1}(j, :), 'Parent', h.axes(i), 'Color', lineColor{min(j, length(lineColor))});       
        end

%         h.bar(i) = bar(h.axes(i), binEdges, spikeHist{i, 1}');
%         bar(h.axes(i), binEdges, spikeHist{i, 1}');
        if i == state.mcViewer.nChannels
            set(h.axes(i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
        end
        ylabel(h.axes(i), ['Ch' num2str(i)]);
    end
%     h.spikeHist = spikeHist;
    h.fileNames = fileNumbers;
    h.binEdges = binEdges;

            
            