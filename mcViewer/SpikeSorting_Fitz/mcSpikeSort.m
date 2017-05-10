function mcSpikeSort(channels, trodeName, MUA)
    global state
    tic;
    if nargin < 3
        MUA = 0;
    end
    %find structure element to replace or append to structure if not found
    if isempty(state.mcViewer.tsData)
        return
    end
    if isempty(state.mcViewer.trode)
        index = 1;
        state.mcViewer.trode = mcEmptyTrodeStructure;
    else
        index = [];
        for i = 1:length(state.mcViewer.trode)
            if strcmp(state.mcViewer.trode(i).name, trodeName)
                index = i;
                break
            end
        end
        if isempty(index)
            index = length(state.mcViewer.trode) + 1;        
            state.mcViewer.trode(index) = mcEmptyTrodeStructure; %supply empty structure to be filled, preallocation not implemented              
        end
    end
    if MUA
        trodeName = 'MUATrode';
    end
    state.mcViewer.trode(index).name = trodeName;
    state.mcViewer.trode(index).channels = channels;
    state.mcViewer.trode(index).spikes = ss_default_params(state.mcViewer.sampleRate * 1000);
    %% tweaking of algorithmic parameters
%     state.mcViewer.trode(index).spikes.params.thresh = 4.5;
%     state.mcViewer.trode(index).spikes.params.window_size = 1.2;
%     state.mcViewer.trode(index).spikes.params.shadow = 0.6;
%     state.mcViewer.trode(index).spikes.params.kmeans_clustersize = 100;
    %%
    
    state.mcViewer.trode(index).spikes = ss_detect(state.mcViewer.tsFilteredData, state.mcViewer.trode(index).spikes, channels);
    state.mcViewer.trode(index).spikes = ss_align(state.mcViewer.trode(index).spikes);
    if MUA % FS MOD 12 07 25 --  shortcut for generating multiunit cluster without kmeans, energy and cluster aggregation
        nSpikes = length(state.mcViewer.trode(index).spikes.spiketimes);
        state.mcViewer.trode(index).spikes.assigns = ones(1, nSpikes); %assign all spikes to cluster "1"
        state.mcViewer.trode(index).spikes.labels = [1 6]; %label all spikes within cluster "1" as type "MUATrode" (type 6) 
        mcUpdateSpikeLines(1);
        return
    end
    state.mcViewer.trode(index).spikes = ss_kmeans(state.mcViewer.trode(index).spikes);
    state.mcViewer.trode(index).spikes = ss_energy(state.mcViewer.trode(index).spikes);
    state.mcViewer.trode(index).spikes = ss_aggregate(state.mcViewer.trode(index).spikes);
    if isempty(state.mcViewer.trode(index).splitMergeToolHandle) || ~ishandle(state.mcViewer.trode(index).splitMergeToolHandle)
        state.mcViewer.trode(index).splitMergeToolHandle = figure;
    end
    splitmerge_tool(state.mcViewer.trode(index).spikes, 'all', state.mcViewer.trode(index).splitMergeToolHandle, index);
    eSeconds = toc;
    disp(['Spike Sorting Took ' num2str(eSeconds/60) ' minutes']);
            