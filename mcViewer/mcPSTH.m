function h = mcPSTH(fileNumbers, binEdges, delay, nPulses, ISI, figName)
    global state
    
    if nargin < 6
        figName = [mcExpPrefix 'PSTH'];
    end
    
    if nargin < 3 % kludgy
        delay = state.mcViewer.pulse.pulseDelay;
        nPulses =  state.mcViewer.pulse.nPulses;
        ISI = state.mcViewer.pulse.pulseISI;
        figName = [state.mcViewer.fileBaseName 'MUA_PSTH'];
    end
    
    if nargin < 2
        binEdges = 1:1:ISI;
    end
    
    if nargin < 1
        fileNumbers = 1:state.mcViewer.tsNumberOfFiles;
    end
    
    h.figure = figure('Name', figName);
    gap=.005;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(state.mcViewer.nChannels-1))/state.mcViewer.nChannels;    
    start = 1 - delta - start;
    
    
   
    spikePSTH = cell(state.mcViewer.nChannels, 1);
    lineColor = {'b', 'g', 'r', 'm', 'b'};
    for i = 1:state.mcViewer.nChannels
         h.axes(i) = axes(...       
            'Parent', h.figure,...
            'XTickLabel', {''},...
            'XTick', [],...
            'Position', [.1 start - (i - 1) * (delta + gap) .8 delta]...
            );
        for j = 1:size(fileNumbers, 1)
            allSpikes = cat(2, state.mcViewer.analysis.tsSpikeTimes{i, fileNumbers(j, :)});
            allSpikes(allSpikes < delay | allSpikes > (delay + ISI * nPulses)) = NaN; % ignore spikes before or after pulse train
            allSpikes = rem(allSpikes, ISI);
            disp('*** I think code in mcPSTH is flawed: if delay is not a multiple of ISI then the wrong times should ensue ***');
            disp(' *** I think I need to subtract off delay from spike times ... ' );
            spikePSTH{i, 1}(j,:) = histc(allSpikes, binEdges);
            h.line(i,j)= line(binEdges, spikePSTH{i, 1}(j, :), 'Parent', h.axes(i), 'Color', lineColor{min(j, length(lineColor))});
        end

%         h.bar(i) = bar(h.axes(i), binEdges, spikeHist{i, 1}');
%         bar(h.axes(i), binEdges, spikeHist{i, 1}');
        if i == state.mcViewer.nChannels
            set(h.axes(i), 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
        end
        ylabel(h.axes(i), ['Ch' num2str(i)]);
    end
            