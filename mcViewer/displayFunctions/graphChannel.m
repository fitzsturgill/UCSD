function graphChannel(channel)
    global state
    
    name = [state.mcViewer.fileBaseName 'cyc' num2str(state.mcViewer.currentCyclePos) 'acq' num2str(state.mcViewer.fileCounter) '_ch' num2str(channel)];
    fig = figure('Name', name); hold on
    plot(state.mcViewer.displayXData, state.mcViewer.displayData(:,channel));
    