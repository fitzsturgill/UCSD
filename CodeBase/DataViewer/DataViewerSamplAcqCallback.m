function DataViewerSamplAcqCallback(obj, event, hDataViewer)
	global state
% Get all plot vectors (stored in the struct, dv)
dv = dvCallbackHelper(hDataViewer);

dv.MaxPoints = 20000;
dv.Fs = obj.SampleRate;
Fs = dv.Fs;

% FS MOD

    state.DaqControllerAux.currentAcq = state.DaqControllerAux.currentAcq + 1;
    updateGUIByGlobal('state.DaqControllerAux.currentAcq');
    state.DaqControllerAux.currentCycle = mod(state.DaqControllerAux.currentAcq - 1, state.DaqControllerAux.nCycles) + 1;
    updateGUIByGlobal('state.DaqControllerAux.currentCycle');
%
% Get data
% WB - 8/6/10 - if n > 1 triggers elapsed before this callback ran, we must
% loop through them (fixing our TriggerNum index each time) since online analysis functions (e.g. PSTH) expect to
% be run every trigger

while (obj.SamplesAvailable >= obj.SamplesPerTrigger) || (~doOnce)
    
    TriggerNum = obj.TriggersExecuted;
    %disp(['DataViewerSampleAcqCallback: TriggerNum = ', num2str(TriggerNum), ' .'])
    if(obj.SamplesAvailable > obj.SamplesPerTrigger)
        triggersMissed = ceil(obj.SamplesAvailable / obj.SamplesPerTrigger) - 1; 
        TriggerNum = TriggerNum - triggersMissed;
        %disp(['Samples acquired callback missed ', num2str(triggersMissed) , ' triggers, & is now catching up: proc. trigger ', num2str(TriggerNum)]);
    end

    
    sizeData = min(obj.SamplesPerTrigger, obj.SamplesAvailable);
    data = getdata(obj,sizeData);    

    % Process and display data
    spiketimes = dvProcessDisplay(dv,data,hDataViewer); % spiketimes is a cell array
    drawnow
    tic

    % --- Online analysis --- %

    % full stimulus / led condition matrices containing data for all triggers
    stimconds = getappdata(hDataViewer, 'StimCondData');
    ledconds = getappdata(hDataViewer, 'LEDCondData');
    
    % stimulus / led condition for this trigger
%     thisStimCond = stimconds(:,TriggerNum);
    if getappdata(hDataViewer,'bLED');
        thisLEDCond = ledconds(2,TriggerNum);
    else
        thisLEDCond = NaN;
    end
    
    % PSTH
    if getappdata(hDataViewer,'psthON')
%         cond.stim = thisStimCond;
        cond.led = thisLEDCond;
        % FS MOD
        cond.led = 1; % not using LED conditions
        cond.stim = state.DaqControllerAux.currentCycle;
        disp(['Current cycle is ' num2str(cond.stim)]);
        temp = guidata(hDataViewer);
        h = guidata(temp.psth.psthFig);
        h = updateOnlinePSTH(h,spiketimes,cond);
        guidata(h.psthFig,h);
    end

    % Mean firing rate vs time
    if getappdata(hDataViewer,'frON')
        temp = guidata(hDataViewer);
        h = guidata(temp.fr.frFig);
        h = updateOnlineFR(h,spiketimes);
        guidata(h.frFig,h);
    end

    % LFP analysis
    if getappdata(hDataViewer,'lfpON')
        cond.stim = thisStimCond;
        cond.led = thisLEDCond;
        temp = guidata(hDataViewer);
        h = guidata(temp.lfp.lfpFig);
        h = updateOnlineLFP(h,data,cond);
        guidata(h.lfpFig,h);
    end
    
    % Spatial receptive field
    if getappdata(hDataViewer,'srfON')
        matPos = thisStimCond(2,:);
        temp = guidata(hDataViewer);
        h = guidata(temp.srf.srfFig);
        h = updateOnlineSRF(h,spiketimes,matPos);
        guidata(h.srfFig,h);
    end
    %disp(['Finished processing TriggerNum = ', num2str(TriggerNum), ', samples remaining/samples per trigger = ', num2str(obj.SamplesAvailable/obj.SamplesPerTrigger)])
    doOnce = 1;
end

% now we draw / update GUI
drawnow

% --- End online analysis --- %

% Update GUI objects
hTriggerNum = getappdata(hDataViewer,'hTriggerNum');
TriggerNum = obj.TriggersExecuted-1;
set(hTriggerNum,'String',TriggerNum);
drawnow
  
