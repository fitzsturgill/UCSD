function mcCustomCycleOrder(seed)
   % takes a vector of cycle positions, repeats it and then deposits it as
   % tsCyclePos.  e.g.:   seed = [1 2 4 3], 9 files, tsCyclePos=1 2 4 3 1 2 4 3 1 2
    global state
   
    cycles = repmat(seed, 1, ceil(state.mcViewer.tsNumberOfFiles / length(seed)));
    state.mcViewer.tsCyclePos = cycles(1, 1:state.mcViewer.tsNumberOfFiles);
    
    