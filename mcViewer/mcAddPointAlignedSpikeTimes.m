function mcAddPointAlignedSpikeTimes
    % Adds a new field to spikes structure "spiketimes_aligned" which
    % matches xData as accomplished in parallel within
    % ss_makeClusterStructure.  These new spikeTimes can be used to index
    % into xData.
    global state
    
    
    for i = 1:length(state.mcViewer.trode)
        if isempty(state.mcViewer.trode(i)) || isfield(state.mcViewer.trode(i).spikes, 'spiketimes_aligned');  % if trode is empty or aligned spike times already generated
            continue
        end
        
        spikeTimes = state.mcViewer.trode(i).spikes.spiketimes;
        spikeTimes = double(spikeTimes)* 1000 * 10 - 1/state.mcViewer.sampleRate * 10;
        spikeTimes = round(spikeTimes)/10;
        state.mcViewer.trode(i).spikes.spiketimes_aligned = spikeTimes;
    end