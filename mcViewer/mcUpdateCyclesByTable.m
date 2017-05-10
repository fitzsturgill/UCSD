function mcUpdateCyclesByTable
    global state
    
    % don't update if fileMode == 1 as cycle positions are already provided
    % as metadata upon loading from scanimage
    if state.mcViewer.fileMode == 1 || 3
        return
    end
%   Generate a lookup vector containing cyclePositions for every file
%     nCyclePos = size(state.mcViewer.ssb_cycleTable, 1) * size(state.mcViewer.ssb_cycleTable, 2);
    nCyclePos = max(max(state.mcViewer.ssb_cycleTable));
    disp('Kludge in mcUpdateCyclesByTable: # of cycles defined by max cycle in cycle table');
    disp('last cycle must therefore be included in cycle table');
    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
%   Update tsCyclePos       
    state.mcViewer.tsCyclePos = mod(trialLookup - 1, nCyclePos) + 1;