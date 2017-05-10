function mcProcessAllAnalysis(short)
    global state
    if nargin < 1
        short = 1;
    end

    mcProcessAnalysis('WaveForm');
    mcProcessAnalysis('SpikeRate');
    mcProcessAnalysis('Quality');
    mcProcessAnalysis('SpikeBursts');
    if isfield(state.mcViewer.features, 'respiration') && ~isempty(state.mcViewer.features.respiration)
        try
            mcProcessAnalysis('SpikesByRespCycleShifted');
        catch
        end
    else
        disp('skipping spikes by respiration cycle');
    end
    
    % skip spikeLFPaverage and spikeLFPcoherence most of hte time
    % I'm assuming that I've done these already and I'm just tacking on
    % analysis for MUATrode
    if short
        disp('*** Skipping Analysis for SpikeLFPAverage and SpikeLFPCoherence***');
        return
    end
    mcProcessAnalysis('SpikeLFPAverage');
    mcProcessAnalysis('SpikeLFPCoherence');
%     mcMakeHilbertTransform;
%     mcProcessAnalysis('HilbertTransform');