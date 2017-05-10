function mcMakeMUAHist(channels, autoMode, thresh)
% function mcMakeMUAHist(channels, autoMode, thresh)

% automode == 0,     manual threshold, nargin must == 3 (threshold must be
% specified) 
% automode == 1,     autothreshold determined for each channel, 3xSD
% automode == 2,     autothreshold determined across all channels (irrespective of channels parameter), 3xSD
    global state
    
    state.mcViewer.showThresh = 1;
    updateGUIByGlobal('state.mcViewer.showThresh');
    
    if nargin < 3
        thresh = [];
    end
    
    if nargin < 2
        autoMode = 2;
    end
    
    if nargin < 1
        channels = 1:state.mcViewer.nChannels;
    end
    
    mcFindPeaks([], autoMode, thresh); %find peaks using threshold determined across all channels
    mcFlipTimeSeries;
    
    if isempty(state.mcViewer.MUAHist) || ~ishandle(state.mcViewer.MUAHist.figure)
        state.mcViewer.MUAHist.figure =figure('Name', 'Multi-Unit Activity Trial Histogram', 'NumberTitle', 'off');
    else
        oldHandle = state.mcViewer.MUAHist.figure;
        state.mcViewer.MUAHist = [];
        state.mcViewer.MUAHist.figure = oldHandle;
        clf(state.mcViewer.MUAHist.figure);
    end
    
    % cycle position of every acquisition
    mcUpdateCyclesByTable;
    cycleLookup = state.mcViewer.tsCyclePos;
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    
    % set up figure spacing
    gap=.05;
    start=.05;
    height = 1 - start*2;
    delta=(height-gap*(size(state.mcViewer.ssb_cycleTable, 1) -1))/size(state.mcViewer.ssb_cycleTable, 1);  %for Histograms and PSTHs'  
    start = 1 - delta - start;
    
    % line colors
    lineColor = state.mcViewer.lineColor;
    
    trialLength = state.mcViewer.tsXData{1,1}(1, end); %assumes trials/acquisitions start at t = 0 and all trials are same length
    binEdges = 0:250:trialLength;
    for i = 1:size(state.mcViewer.ssb_cycleTable, 1);     
        
        state.mcViewer.MUAHist.axes(i) = axes(...
            'Parent', state.mcViewer.MUAHist.figure,...
            'Position', [0.1 start - (i-1) * (delta + gap) 0.8 delta],...
            'XLim', [0 trialLength]...
            );      
        % iterate over elements of each row vector
        for j = 1:size(state.mcViewer.ssb_cycleTable, 2);
            cycle = state.mcViewer.ssb_cycleTable(i, j);
            filtTrials = trialLookup(cycleLookup == cycle);           
            MUAHist = histc(cat(2, state.mcViewer.analysis.tsSpikeTimes{channels, filtTrials}), binEdges); %combine all channels and acquisitions matching a particular cycle into a single vector
            MUAHist = MUAHist (1:end - 1);
            
            state.mcViewer.MUAHist.lines(i, j) = line(...
                binEdges(1:end - 1),...
                MUAHist,...
                'Parent', state.mcViewer.MUAHist.axes(i),...
                'Color', lineColor{min(j, length(lineColor))}...
                );
        end
    end