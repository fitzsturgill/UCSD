function out=mcTrialsByCycle(cycle)
    global state
    
    if nargin < 2
        reject = 0;
    end

    trialLookup = 1:state.mcViewer.tsNumberOfFiles;
    cycleLookup = state.mcViewer.tsCyclePos;
     out = trialLookup(ismember(cycleLookup, cycle));    
    if reject
        out = trialLookup(ismember(cycleLookup, cycle) & abs(state.mcViewer.tsRejectAcq - 1));
    else
        out = trialLookup(ismember(cycleLookup, cycle));
    end