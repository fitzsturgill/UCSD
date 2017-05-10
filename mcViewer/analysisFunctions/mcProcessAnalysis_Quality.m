    function mcProcessAnalysis_Quality(trode, clust, varargin)
        global state
        
        

        state.mcViewer.trode(trode).cluster(clust).analysis.Quality = struct(...
            'data', [],... % data field uncessary for waveform as these are generated on the fly by ultraMegaSort2000
            'displayFcnHandle', @mcShowAnalysis_Quality,...
            'settings', {varargin}...
            );
        
        %% from Kleinfeld UltraMegaSort
        spikes = state.mcViewer.trode(trode).spikes;
        cluster = state.mcViewer.trode(trode).cluster(clust).cluster;
        %% Extract # of spikes, # of refractory period violations, %
        %% percent contamination (and confidence intervals), and percent missing spikes
        
        % spike indices
        show = get_spike_indices(spikes, cluster);

        nSpikes = size(spikes.waveforms(show,:,:), 1); % # of spikes
        [expected,lb,ub,RPV] = ss_rpv_contamination( spikes, cluster); % expected- % contamination, lb and ub- confidence intervals for contamination rpv- number of refractory period violations
        [p,mu,stdev,n,x] = ss_undetected(spikes,cluster);  % probability that spike goes undetected
        p = p * 100; % convert to percentage
        
        
        tempStruct.nSpikes = nSpikes;
        tempStruct.contamination = 100 * expected;
        tempStruct.contaminationUpperBound = 100 * ub;
        tempStruct.contaminationLowerBound = 100 * lb;
        tempStruct.RPV = RPV;
        tempStruct.undetected = p;
        
        state.mcViewer.trode(trode).cluster(clust).analysis.Quality.data = tempStruct;