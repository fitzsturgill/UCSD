function mcProcessAnalysis(analysisField, varargin)
% wrapper
    global state
    if isempty(state.mcViewer.trode)
        return
    end
    disp(['*** mcProcessAnalysis: ' analysisField ' ***']);
    % iterate over trodes and clusters
    for i = 1:length(state.mcViewer.trode)
        % borrowed from mcUpdateSpikeLines:
        %ensure that trode contains spike structure and cluster structure
        if isempty(state.mcViewer.trode(i).spikes)
            continue
        elseif ~isfield(state.mcViewer.trode(i), 'cluster') || isempty(state.mcViewer.trode(i).cluster) %|| force
            state.mcViewer.trode(i).cluster = ss_makeClusterStructure(state.mcViewer.trode(i).spikes, 'all');
        end

        for j = 1:length(state.mcViewer.trode(i).cluster)
%             disp(['we are working on cluster ' num2str(j)]);
            if ~isfield(state.mcViewer.trode(i).cluster(j), 'analysis')
                state.mcViewer.trode(i).cluster(j).analysis=[];
            end
            f=str2func(['mcProcessAnalysis_' analysisField]); % for every type of trode analysis create this function and store it in the matlab path
            f(i, j, varargin{:,:}); %execute function handle with trode, cluster, and varargin as arguments
        end
    end
    % sometimes loading spikes requires these functions to be declared
    % here... weird...
%     function mcShowAnalysis_WaveForm
%         disp('wtf');
% 
%     function mcShowAnalysis_SpikeRate
%         disp('wtf');
%     function mcShowAnalysis_SpikeLFPCoherence
%         disp('wtf');
%     function mcShowAnalysis_SpikeLFPAverage
%         disp('wtf');        