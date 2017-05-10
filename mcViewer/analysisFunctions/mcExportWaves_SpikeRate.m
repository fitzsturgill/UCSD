    function saveCycles = mcExportWaves_SpikeRate(trode, clusterIndex)
        % requires a row vector of cycles
        % no use for varargin right now, keeping to maintain format for
        % parameters
        global state
        
        if ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, 'SpikeRate')
            ax=[];
            return
        end
        prefix=mcExpPrefix;
        cycles = reshape(state.mcViewer.ssb_cycleTable, 1, numel(state.mcViewer.ssb_cycleTable)); % generate row vector from cycles
        cluster = state.mcViewer.trode(trode).cluster(clusterIndex).cluster;
        
%         Y = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,:).avg], length(cycles), 2);
%         Yerr = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,:).sem], length(cycles), 2);
        Y = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,:).avg], length(cycles)/2, 4);
        Yerr = reshape([state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate.data(cycles,:).sem], length(cycles)/2, 4);
        saveCycles = [cycles cycles];
        saveCycles = reshape(saveCycles, length(cycles)/2, 4);
        
        
        variableName = [prefix 't' num2str(trode) 'c' num2str(cluster) '_SpikeRate'];
        eval([variableName '=Y']);
%         waveo([prefix 't' num2str(trode) 'c' num2str(cluster) '_Rate_od_bl'], Y(:,1)');
%         waveo([prefix 't' num2str(trode) 'c' num2str(cluster) '_cycles'], cycles);

%         waveo([prefix 't' num2str(trode) 'c' num2str(cluster) '_Rate_od'], Y(:,2)');
%         waveo([prefix 't' num2str(trode) 'c' num2str(cluster) '_Rate_od_bl'], Y(:,1)');
%         waveo([prefix 't' num2str(trode) 'c' num2str(cluster) '_cycles'], cycles);
        
%         waveList = {...
%             [prefix 't' num2str(trode) 'c' num2str(cluster) '_Rate_od'],...
%             [prefix 't' num2str(trode) 'c' num2str(cluster) '_Rate_od_bl'],...
%             [prefix 't' num2str(trode) 'c' num2str(cluster) '_cycles'],...
%             };
        mkdir(state.mcViewer.filePath,'analysis');
        save(fullfile(state.mcViewer.filePath, 'analysis', variableName), variableName); 
        disp(['*** Saving: ' variableName '***']);
%         saveWave(waveList{i}, fullfile(state.mcViewer.filePath, 'analysis', waveList{i}));

%         outputFile=fullfile(state.mcViewer.filePath, [prefix 't' num2str(trode) 'c' num2str(cluster) '_SpikeRate.itx']);
%         exportWave(waveList, '', outputFile);
%         disp(['*** Saving: ' prefix 't' num2str(trode) 'c' num2str(cluster) '_SpikeRate.itx']);
            