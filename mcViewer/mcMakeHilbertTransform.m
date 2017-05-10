function mcMakeHilbertTransform(channel, low, high)
    global state
    
    state.mcViewer.hilbert.channel = channel;
    state.mcViewer.hilbert.lowPass = low;
    state.mcViewer.hilbert.highPass = high;
    
    h = waitbar(0, 'Making Hilbert Transform');
    for i = 1:state.mcViewer.tsNumberOfFiles        
        
        
        filtered = mcFilter(state.mcViewer.tsData{1,i}(:,channel), low, high, state.mcViewer.sampleRate);
        tsHilbert = hilbert(filtered);
        phase = angle(tsHilbert);
        amp = abs(tsHilbert);
        
        if i == 1
            tsPhase = repmat(phase, 1, state.mcViewer.tsNumberOfFiles);
            tsAmp = repmat(phase, 1, state.mcViewer.tsNumberOfFiles);
            tsFiltered = repmat(filtered, 1, state.mcViewer.tsNumberOfFiles);
        end
        
        tsPhase(:,i) = phase;
        tsAmp(:,i) = amp;
        tsFiltered(:,i) = filtered;
        waitbar(i/state.mcViewer.tsNumberOfFiles);            
    end
    
    state.mcViewer.tsHilbertPhase = tsPhase;
    state.mcViewer.tsHilbertFiltered = tsFiltered;
    state.mcViewer.tsHilbertAmp = tsAmp;
    
    close(h);
    
    
    
    
    
%     function mcMakeHilbertTransform(channel, low, high)
%     global state
%     
%     state.mcViewer.hilbert.channel = channel;
%     state.mcViewer.hilbert.lowPass = low;
%     state.mcViewer.hilbert.highPass = high;
%     
%     h = waitbar(0, 'Making Hilbert Transform');
%     for i = 1:state.mcViewer.tsNumberOfFiles        
%         [phase, filtered_sig] = phase_from_hilbert(state.mcViewer.tsData{1, i}(:, channel), state.mcViewer.sampleRate * 1000, [high low]);
%         state.mcViewer.tsHilbertPhase{1, i} = phase;
%         state.mcViewer.tsHilbertFiltered{1, i} = filtered_sig;
%         waitbar(i/state.mcViewer.tsNumberOfFiles);            
%     end
%     
%     
%     close(h);