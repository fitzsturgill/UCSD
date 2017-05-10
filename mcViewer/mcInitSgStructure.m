function mcInitSgStructure
    global state
    
        
    out = struct(...
        'SG', [],...
        'TG', [],...
        'FG', [],...
        'needsUpdate', 1,...
        'TW', state.mcViewer.sg_TW, ...
        'p', state.mcViewer.sg_p, ...
        'width', state.mcViewer.sg_width, ...
        'step', state.mcViewer.sg_step, ...
        'channel', state.mcViewer.sg_channel...
        );
    
    state.mcViewer.tsSG = repmat(out, 1, state.mcViewer.tsNumberOfFiles);
        