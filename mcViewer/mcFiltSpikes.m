function indices = mcFiltSpikes(trode, varargin)
    %varargin- parameter/value pairs
    %Parameters
    % 1) trials and 2) assigns-  these are followed by a vector of trials or
    % cluster identities
    % 
    % 3) spiketimes 4) unwrapped_times 5) spiketimes_aligned
    % These are followed by 2 element vectors specifiying the beginning and
    % end of a time window
    global state
    
    
    
    % parse input parameter pairs
    counter = 1;
    filtFields={};
    while counter+1 <= length(varargin) 
        prop = varargin{counter};
        val = varargin{counter+1};
        switch prop
            case 'trials'
                filtFields = [filtFields {'trials'}];
                fields.trials = val;
            case 'spiketimes'
                filtFields = [filtFields {'spiketimes'}];                
                fields.spiketimes = val;
            case 'unwrapped_times'
                filtFields = [filtFields {'unwrapped_times'}];                
                fields.unwrapped_times = val;
            case 'spiketimes_aligned'
                filtFields = [filtFields {'spiketimes_aligned'}];                
                fields.spiketimes_aligned = val;                    
%             case 'labels'
%                 fields.labels = val;
            case 'assigns'
                filtFields = [filtFields {'assigns'}];                
                fields.assigns = val;
            otherwise
        end
        counter=counter+2;
    end
    
    spikes = state.mcViewer.trode(trode).spikes;
    
    
    indices = ones(size(state.mcViewer.trode(trode).spikes.spiketimes));
    for i = 1:length(filtFields)
        field = filtFields{i};
        

        if any(strcmp(field, {'trials','assigns'}))  % if field is either trials or assigns
            indices = indices .* ismember(spikes.(field), fields.(field)); % .* performs an 'and'
        else
            for j = 1:length(fields.(field))
                indices = indices .* (spikes.(field) > fields.(field)(1,1) & spikes.(field) < fields.(field)(1,2));
            end
        end
    end
    indices = logical(indices);
        
        
    
    