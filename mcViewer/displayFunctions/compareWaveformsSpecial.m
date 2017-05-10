
function compareWaveformsSpecial(addTo)
    global state
    [ctlavgS ctlavgSx]=mcAverageSpikeWaveform(state.mcViewer.ssb_trode,state.mcViewer.ssb_cluster, [], [], [2000 5000], state.mcViewer.ssb_cycleTable(:, 1));
    [LEDavgS LEDavgSx]=mcAverageSpikeWaveform(state.mcViewer.ssb_trode,state.mcViewer.ssb_cluster, [], [], [2000 5000], state.mcViewer.ssb_cycleTable(:, 2));
    if nargin < 1
        addTo=0;
    end
    
    if addTo
        plot(ctlavgSx, ctlavgS, '-k', LEDavgSx, LEDavgS, '-r');
    else
        figure; plot(ctlavgSx, ctlavgS, '-k', LEDavgSx, LEDavgS, '-r');        
    end
    textBox(['Ctl vs LED, Width=' num2str(state.mcViewer.trode(state.mcViewer.ssb_trode).cluster(state.mcViewer.ssb_cluster).analysis.WaveForm.data.spikeWidth)]);
    xlabel('time (ms)');