    function mcProcessAnalysis_SpikeLFPCoherence(trode, clusterIndex, varargin)
        global state
% skip garbage clusters as these aren't relevent and are computationally
% intensive due to excessive numbers of spikes
% also skip MUA clusters
        if state.mcViewer.trode(trode).cluster(clusterIndex).label == 4 || strcmpi(state.mcViewer.trode(trode).name, 'MUATrode') 
            return
        end
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence = struct(...
            'data', [],... %array of size in 1st dimension of # of included spikes
            'displayFcnHandle', @mcShowAnalysis_SpikeLFPCoherence,...
            'settings', {varargin}...                
            );    

        %default values    
        LFPChannel = state.mcViewer.sg_channel;
        cycles = sort(unique(state.mcViewer.tsCyclePos)); %here you want to process all cycles, not just those specified by cycle table as for displaying the data
        x1 = state.mcViewer.x1; % now x1, x2, bl1 and bl2 are global variables that are common to multiple analysis types and manually or externally set
        x2 = state.mcViewer.x2;
        bl1 = state.mcViewer.bl1;
        bl2 = state.mcViewer.bl2;
        TW = state.mcViewer.sg_TW;
        p = state.mcViewer.sg_p;
        fpass = [0 80];
        % p stands for p value used in calculation of error bars
        err = [2 .05]; % options  1) [1 p]- theoretical error bars,  [2 p]- jackknife error bars, [0 p] or 0- no error bars

        % parse input parameter pairs
        counter = 1;
        while counter+1 <= length(varargin) 
            prop = varargin{counter};
            val = varargin{counter+1};
            switch prop
                case 'x1'
                    x1 = val;
                case 'x2'
                    x2 = val;
                case 'bl1'
                    bl1=val;
                case 'bl2'
                    bl2=val;
                case 'TW'
                    TW=val;
                case 'p'
                    p=val;                    
                case 'window'
                    window = val;
                case 'cycles'
                    cycles = val;
                case 'LFPChannel'
                    LFPChannel=val;
                case 'fpass'
                    fpass=val;
                case 'err'
                    err=val;                    
                otherwise
            end
            counter=counter+2;
        end
        
        params = struct(...
            'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
            'Fs', state.mcViewer.sampleRate * 1000,...
            'fpass', fpass,...
            'trialave', 1, ...
            'err', err...
            );        
        
        mcAddPointAlignedSpikeTimes; %equivalent to spikes.spiketimes but in msec and scaled for indexing into tsXData (see ss_makeClusterStructure)
        spikes = state.mcViewer.trode(trode).spikes; 
        cycleLookup = state.mcViewer.tsCyclePos;
        trialLookup = 1:state.mcViewer.tsNumberOfFiles;
        cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster;
        
        
        %preallocate structure to contain SpikeLFPAverage data
        state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data = struct(...
            'C', {cell(length(cycles), 2)},...
            'phi', {cell(length(cycles), 2)},...
            'S12', {cell(length(cycles), 2)},...
            'S1', {cell(length(cycles), 2)},...
            'S2', {cell(length(cycles), 2)},...
            'f', {cell(length(cycles), 2)},...
            'zerosp', {cell(length(cycles), 2)},...
            'confC', zeros(length(cycles), 2),... % ****************************    always a scalar
            'phistd', {cell(length(cycles), 2)},...            
            'Cerr', {cell(length(cycles), 2)},... % lower and upper confidence lines
            'Cerr2', {cell(length(cycles), 2)}... % the lower and upper error magnitudes
            );
        
        
        h=waitbar(0, ['SpikeLFPCoherence: Trode-' num2str(trode) ' Cluster-' num2str(cluster)]);
        waitCount = 1;
        for i = 1:length(cycles)
            cycle = cycles(i);
            filtTrials = trialLookup(cycleLookup == cycle);            
            for j = 1:2 % testPeriod and baselinePeriod
                if j == 1
                    startTime = x1;
                    stopTime = x2;
                else
                    startTime = bl1;
                    stopTime = bl2;
                end
                % gather continuous data in a time x trials array- this is
                % a memory intensive way of doing this as I combine all
                % channels and then cull unwanted channels
%                 contData =  cat(3, state.mcViewer.tsData{1, filtTrials}(mcX2pnt(startTime):mcX2pnt(stopTime)));
%                 contData = squeeze(data(:, LFPChannel, :));
                
                % preallocate continuous data array
                contData = zeros(length(filtTrials), round((stopTime - startTime)/state.mcViewer.deltaX));
                spikeData(1, length(filtTrials)).data = []; %preallocate structure- see "creating a structure"
                for k = 1:length(filtTrials)
                    trial = filtTrials(k);
                    filtInd = spikes.assigns == cluster & spikes.trials==trial & spikes.spiketimes_aligned > startTime & spikes.spiketimes_aligned < stopTime;
                    % FS MOD below: spikes.spiketimes_aligned(filtInd) -->
                    % spikes.spiketimes_aligned(filtInd)'
%                     spikeData(1, k).data = spikes.spiketimes_aligned(filtInd)' - startTime; % I need to subtract startTime because spike times should be relative to beginning of baseline or odor period not beginning of trial
                    %Kludge: spikes.spiketimes_aligned(filtInd)/1000
                    spikeData(1, k).data = (spikes.spiketimes_aligned(filtInd)' - startTime)/1000; % I need to subtract startTime because spike times should be relative to beginning of baseline or odor period not beginning of trial                    
                    contData(k, :) = state.mcViewer.tsData{1, trial}(mcX2pnt(startTime):mcX2pnt(stopTime)-1 , LFPChannel)';
                end
                
                if err(1) == 0 % no error estimation
                    [C,phi,S12,S1,S2,f,zerosp]=coherencycpt(contData',spikeData,params); %kludge!!!!!- use of ' to correct dimensions
                elseif err(1) == 1 % theoretical
                    [C,phi,S12,S1,S2,f,zerosp,confC,phistd]=coherencycpt(contData',spikeData,params);
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.confC(i, j) = confC;
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.phistd{i, j} = phistd;
                elseif err(1) == 2; % jackknife 
                    [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencycpt(contData',spikeData,params);
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.confC(i, j) = confC;
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.phistd{i, j} = phistd;
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.Cerr{i, j} = Cerr'; % Cerr' --> convention such that dimensionality of Cerr and Cerr2 match
                end
                
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.C{i, j} = C';  % C' --> convention and used for calculation of Cerr2 (this way both C and f are row vectors)
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.phi{i, j} = phi;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.S12{i, j} = S12;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.S1{i, j} = S1;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.S2{i, j} = S2;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.f{i, j} = f;
                state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.zerosp{i, j} = zerosp;
                
                if err(1) == 2
                    state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeLFPCoherence.data.Cerr2{i, j} = abs(Cerr - repmat(C', 2, 1))';
                end
                waitCount = max(i*j, waitCount);
                waitbar(waitCount/length(cycles)/ 2); 
            end
        end

        close(h);
                
        