function mcFlipTimeSeries(fileCounter, force)
    global state
    
    if nargin == 0
        fileCounter = state.mcViewer.fileCounter;
    end
    
    if nargin < 2
        force = 0;
    end
    
    if state.mcViewer.fileCounter > state.mcViewer.tsNumberOfFiles
        state.mcViewer.fileCounter = state.mcViewer.tsNumberOfFiles;
        updateGUIByGlobal('state.mcViewer.fileCounter');
        return
    end
    state.mcViewer.rejectAcq = state.mcViewer.tsRejectAcq(1, state.mcViewer.fileCounter);
    updateGUIByGlobal('state.mcViewer.rejectAcq');
    
    if force
        mcFilterData(fileCounter, 1); % force not really used often with mcFlipTimeSeries
    else
        mcFilterData(fileCounter, 1, state.mcViewer.nChannels + 1 : state.mcViewer.totalChannels);
        mcFilterData(fileCounter, 0, 1:state.mcViewer.nChannels); % only filter mcChannels if needed
    end

    updateGUIByGlobal('state.mcViewer.fileCounter');
    state.mcViewer.fileName = state.mcViewer.tsFileName{1, fileCounter};
    updateGUIByGlobal('state.mcViewer.fileName');
    try
        state.mcViewer.currentCyclePos=state.mcViewer.tsCyclePos(1, fileCounter);
    catch
        state.mcViewer.currentCyclePos = 0;
    end
    updateGUIByGlobal('state.mcViewer.currentCyclePos');
    
    try
        state.mcViewer.respirationLock=state.mcViewer.features.respiration.tsRespirationLock(1, fileCounter);
        updateGUIByGlobal('state.mcViewer.respirationLock');
        state.mcViewer.acqStringency=state.mcViewer.features.respiration.tsRespirationStringency(1, fileCounter);
        updateGUIByGlobal('state.mcViewer.respirationStringency');        
    catch
    end
    %update display data for multichannel channels
%     if state.mcViewer.displayFiltered
%         state.mcViewer.displayData = state.mcViewer.tsFilteredData{1, fileCounter}(:, 1:state.mcViewer.nChannels);
%     else
%         state.mcViewer.displayData = state.mcViewer.tsData{1, fileCounter}(:, 1:state.mcViewer.nChannels);
%     end

    %update display data separately for channels displayed as filtered and
    %raw data
    showFiltered = logical(mcChannelFieldToVector('ShowFilter'));
    showRaw = isnan(showFiltered ./ 0);
    state.mcViewer.displayData(:, showFiltered) = state.mcViewer.tsFilteredData{1, fileCounter}(:, showFiltered);
    state.mcViewer.displayData(:, showRaw) = state.mcViewer.tsData{1, fileCounter}(:, showRaw);
    
    %for mcChannels with alternative display filter settings set by the
    %channelControl GUIs, filter these channels using alternative settings
    %for display only (tsFilteredData stays the same)
    for i = 1:state.mcViewer.nChannels
        if state.mcViewer.channel(i).ShowFilter && (state.mcViewer.channel(i).LowPass > 0 || state.mcViewer.channel(i).HighPass > 0)
            state.mcViewer.displayData(:, i) = mcFilter(state.mcViewer.tsData{1, fileCounter}(:, i), state.mcViewer.channel(i).LowPass, state.mcViewer.channel(i).HighPass, state.mcViewer.sampleRate);
        end
    end
    
    state.mcViewer.displayThreshData = repmat(state.mcViewer.analysis.tsThresholds(:, fileCounter)', size(state.mcViewer.displayData, 1), 1);
    state.mcViewer.displayXData = state.mcViewer.tsXData{1, fileCounter};
    
    mcUpdateFigures;
    mcUpdateSgFigure;
    if ~isempty(state.mcViewer.features.respiration) && isfield(state.mcViewer.features.respiration, 'tsRespirationStringency')
        mcFindRespAdvanced(fileCounter, state.mcViewer.features.respiration.tsRespirationStringency(1, fileCounter), 1); % update for display only
    else
        mcFindRespAdvanced(fileCounter, state.mcViewer.respirationStringency, 1); % update for display only        
    end
    try
        if isfield(state.mcViewer, 'tsHilbertFiltered')
            waveo('hilbertFiltered', state.mcViewer.tsHilbertFiltered(:, fileCounter),'xscale', [0 state.mcViewer.deltaX]);
            waveo('hilbertPhase', state.mcViewer.tsHilbertPhase(:, fileCounter),'xscale', [0 state.mcViewer.deltaX]);       
            waveo('hilbertAmp', state.mcViewer.tsHilbertAmp(:, fileCounter),'xscale', [0 state.mcViewer.deltaX]);           
        end
    catch
    end