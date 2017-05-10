function out= mcEmptyAnalysisStruct(nFiles, nChannels)
    global state
    
    if nargin == 0
        nFiles = state.mcViewer.tsNumberOfFiles;
        nChannels = state.mcViewer.nChannels;
    end
    
    out = struct(...
        'spikes', []...
        );
        