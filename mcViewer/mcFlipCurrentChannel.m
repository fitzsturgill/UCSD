function mcFlipCurrentChannel(currentChannel)
    global state
    if currentChannel > state.mcViewer.totalChannels
        currentChannel = state.mcViewer.totalChannels;
    end    
    state.mcViewer.currentChannel = currentChannel;
    updateGUIByGlobal('state.mcViewer.currentChannel');    
    fields = fieldnames(state.mcViewer.channel);
    for i = 1:length(fields)
        field = fields{i};
        state.mcViewer.(['currentChannel' field]) = state.mcViewer.channel(currentChannel).(field);
        updateGUIByGlobal(['state.mcViewer.currentChannel' field]);
    end