function mcProcessAnalysis_WaveForm(trode, clust, varargin)
    global state

 %default values
        window = 1000; % 100msec        
%         x1 = state.mcViewer.startX; 
%         x2 = state.mcViewer.endX;
%         bl1 = state.mcViewer.startX;
%         bl2 = x2 - floor(window/2);
        timeRange=[];
        ctlCycles=[];
        LEDCycles=[];

        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'timeRange'
                    timeRange = val;
                    ctlCycles = state.mcViewer.ssb_cycleTable(:,1);
                    LEDCycles = state.mcViewer.ssb_cycleTable(:,2);
                otherwise
            end
            counter=counter+2;
        end

    state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm = struct(...
        'data', [],... %
        'displayFcnHandle', @mcShowAnalysis_WaveForm,...
        'settings', {varargin}...
        );

% Make average waveform for determination of spike width    
    cluster = state.mcViewer.trode(trode).cluster(clust).cluster;
    state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.data = makeAverageWaveform(state.mcViewer.trode(trode).spikes, cluster);
    [avgS avgSx] = mcAverageSpikeWaveform(trode, clust); % FS MOD 8/2014,  new waveform creation that uses tsFilteredData, 3ms window for avg    
    state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvg = avgS;
    state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgX = avgSx;    
    
    % kludge
    if ~isempty(timeRange)
        [ctlavgS ctlavgSx] = mcAverageSpikeWaveform(trode, clust, [], [], timeRange, ctlCycles); 
        [LEDavgS LEDavgSx] = mcAverageSpikeWaveform(trode, clust, [], [], timeRange, LEDCycles);         
        state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgCtl = ctlavgS;
        state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgXCtl = ctlavgSx;        
        state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgLED = LEDavgS;
        state.mcViewer.trode(trode).cluster(clust).analysis.WaveForm.spikeAvgXLED = LEDavgSx;                
    end
    
end

    
    
function out = makeAverageWaveform(spikes, cluster)
    

    show = get_spike_indices(spikes, cluster);
    % initialize array to contain all spikes for given cluster
    allSpikes = zeros(length(show), size(spikes.waveforms, 2), size(spikes.waveforms, 3));
    allSpikes = spikes.waveforms(show, :, :);
    avgSpike = mean(allSpikes, 1);
    avgSpike = shiftdim(avgSpike, 1); % get rid of leading singleton
    [value, maxChannel] = min(min(avgSpike));
    out.avg = avgSpike(:, maxChannel);
    out.std = std(allSpikes(:, :, maxChannel), 1)';
    [v1 i1] = min(out.avg);
    [v2 i2] = max(out.avg(i1:end, 1));
    i2 = i1 + i2 - 1;
    out.spikeWidth = (i2 - i1) * 1 / spikes.params.Fs * 1000;
end

% %% now lets do the same thing but get the waveforms out manually
% 
% function out = makeAverageWaveform2
%     global state
%     
    
    
    