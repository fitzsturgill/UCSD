function mcUpdateSgStructure
    global state
    
    fields = {'TW', 'p', 'width', 'step', 'channel'};
    for i = 1:state.mcViewer.tsNumberOfFiles
        bool = 0;
        for field = fields
            field = field{1};
            if state.mcViewer.tsSG(i).(field) ~= state.mcViewer.(['sg_' field])
                % spectrogram creation settings don't match current
                % settings
                bool = 1;
                break
            end
            % spectrogram creation settings match curent settings
        end
        state.mcViewer.tsSG(i).needsUpdate = bool;
    end