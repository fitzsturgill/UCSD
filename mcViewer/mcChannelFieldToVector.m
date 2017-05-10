function out = mcChannelFieldToVector(f)
    % gathers numeric or logical field values (field = f) into a vector
    global state
    if ~isfield(state.mcViewer.channel, f)
        disp('***Error in mcChannelFieldToVector***');
        return
    end
    if ~(isnumeric(state.mcViewer.channel(1).(f)) || islogical(state.mcViewer.channel(1).(f)))
            disp('***Error in mcChannelFieldToVector***');
            return
    end
    out = cat(2, state.mcViewer.channel(1, :).(f));
    return