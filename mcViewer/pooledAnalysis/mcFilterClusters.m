function indices = mcFilterClusters(varargin)
% indices = mcFilterClusters(varargin)
% returns a logical array for indexing into clusters, representing filtered
% clusters
%             'experiment' % string or string cell array of experiment
%             names
%             'label' % numeric label, can be a vector
%             'cluster' % cluster number, can be a vector (not unique)
%             'trodeName' % trodeName string of string cell array of
%             trodeNames
%             'protocol' % protocol string or string cell array of
%             protocol names
%             'nSpikes' % contains as least val spikes
%             'contamination' % contains less than val percent
%             contamination
%             'RPV' % provide as a percentage of nSpikes 'RPV, 1,
%             means that only clusters with less than 1% RPVs are included
%             'undetected' % provide as a percentege- estimated percentage
%             of spikes that go undetected
%             'spikewidth' % [low high], provide as 2 element vector,
%             specifying lowest and highest spike widths permissible

    global clusters
    
    
    %initialize indices
    indices = zeros(1, length(clusters));
    
    % defaults
        experiment = '';
        label = [];
        cluster=[];
        trodeName = '';
        protocol = '';
        nSpikes = 0;
        contamination = 100;
        RPV = 100;
        undetected = 100;
        spikewidth = [];
        LEDEffect = [];
        LEDZValue = [];
        tag = '';
        LEDMod = [];
        
    % parse input parameter pairs
    counter = 1;
    while counter+1 <= length(varargin) 
        prop = varargin{counter};
        val = varargin{counter+1};
        switch prop
            case 'experiment' % string or string cell array of experiment names
                experiment = val;
            case 'label' % numeric label, can be a vector
                label =  val;
            case 'cluster' % numeric cluster, can be a vector
                cluster =  val;                
            case 'trodeName' % trodeName string of string cell array of trodeNames
                trodeName = val;
            case 'protocol' % protocol string or string cell array of protocol names
                protocol = val;
            case 'nSpikes' % contains as least val spikes
                nSpikes = val;
            case 'contamination' % contains less than val percent contamination
                contamination = val;
            case 'RPV' % provide as a percentage of nSpikes 'RPV, 1, means that only clusters with less than 1% RPVs are included
                RPV = val;
            case 'undetected' % provide as a percentege- estimated percentage of spikes that go undetected
                undetected = val;
            case 'spikewidth'
                spikewidth = val;
            case 'LEDEffect'
                LEDEffect = val;
            case 'LEDZValue'
                LEDZValue = val;
            case 'tag'
                tag = val;
            case 'LEDMod'
                LEDMod = val;
            otherwise
        end
        counter=counter+2;
    end
    
    for i = 1:length(clusters)
        bool = 1;
        if ~isempty(experiment) && ~any(strcmpi(experiment, clusters(i).experiment))
            bool = 0;
        end
        
        if ~isempty(label) && ~any(label == clusters(i).label)
            bool = 0;
        end
        
        if ~isempty(cluster) && ~any(cluster == clusters(i).cluster)
            bool = 0;
        end        
        
        if ~isempty(trodeName) && ~any(strcmpi(trodeName, clusters(i).trodeName))
            bool = 0;
        end
        
        if ~isempty(protocol) && ~any(strcmpi(protocol, clusters(1).protocol(:))) % access cell array contents
            bool = 0;
        end
        
        if ~isempty(spikewidth) && (clusters(i).analysis.WaveForm.data.spikeWidth <= spikewidth(1) || clusters(i).analysis.WaveForm.data.spikeWidth > spikewidth(2))
            bool = 0;
        end
        
        if ~isempty(LEDMod) && (clusters(i).analysis.SpikeRate.LEDMod <= LEDMod(1) || clusters(i).analysis.SpikeRate.LEDMod > LEDMod(2))
            bool = 0;
        end        
        
        %% LED effect or zscore are generated within either SpikesByCycleShifted or
        % SpikeRate analysis fields.  Use either field with preference to
        % SpikesByCycleShifted.
        if isfield(clusters(i).analysis, 'SpikesByCycleShifted')  && isfield(clusters(i).analysis.SpikesByCycleShifted, 'LEDEffect')
            LEDfield = 'SpikesByCycleShifted';
        elseif isfield(clusters(i).analysis, 'SpikeRate')  && isfield(clusters(i).analysis.SpikeRate, 'LEDEffect')
            LEDfield = 'SpikeRate';
        else
            LEDfield = '';
        end
        
        if ~isempty(LEDfield)
            if ~isempty(LEDEffect) && ~ismember(clusters(i).analysis.(LEDfield).LEDEffect, LEDEffect) 
                bool = 0;
            end

            if ~isempty(LEDZValue) && ~(abs(clusters(i).analysis.(LEDfield).LEDZScore) > LEDZValue)
                bool = 0;
            end       
        end
        %%
        
        if ~isempty(tag) && ~strcmpi(tag, clusters(i).tag)
            bool = 0;
        end
        
        nSpikesClust = clusters(i).analysis.Quality.data.nSpikes;
        contaminationClust = clusters(i).analysis.Quality.data.contamination;
        RPVClust = clusters(i).analysis.Quality.data.RPV /nSpikesClust *100;
        undetectedClust = clusters(i).analysis.Quality.data.undetected;

        
        if...
                nSpikesClust < nSpikes ||...
                contaminationClust > contamination ||...
                RPVClust > RPV ||...
                undetectedClust > undetected
            bool = 0;
        end
        
        if bool
            indices(i) = 1;
        end
    end
    indices = logical(indices);
    
    
    