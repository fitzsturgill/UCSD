function mcUpdateSgFigure
    global state
    
%% check conditions
    if isempty(state.mcViewer.tsData) || ~state.mcViewer.sg_on
        return
    end

%% Generate or Retrieve Spectrogram
    if state.mcViewer.tsSG(state.mcViewer.fileCounter).needsUpdate || isempty(state.mcViewer.tsSG(state.mcViewer.fileCounter).SG)
        TW = state.mcViewer.sg_TW;
        p = state.mcViewer.sg_p;
        params = struct(...
            'tapers', [TW 2*TW - (1 + p)],... % see chronux manual for rationale
            'Fs', state.mcViewer.sampleRate * 1000,...
            'fpass', [0 100]...
            );
        movingwin = [state.mcViewer.sg_width state.mcViewer.sg_step];  
        data = state.mcViewer.tsData{1, state.mcViewer.fileCounter}(:,state.mcViewer.sg_channel)';
        % prewhitening of data below, perform spectorgram on time
        % derivative....
        data = diff(data);% ./ (1/(state.mcViewer.sampleRate * 1000)); % derivative = [f(x+1) - f(x)] / delta T
        [sg, tg, fg] = mtspecgramc(data, movingwin, params);
         sg = sg';
        state.mcViewer.tsSG(state.mcViewer.fileCounter).SG = sg;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).TG = tg;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).FG = fg;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).needsUpdate=0;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).TW = state.mcViewer.sg_TW;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).p = state.mcViewer.sg_p;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).width = state.mcViewer.sg_width;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).step  = state.mcViewer.sg_step;
        state.mcViewer.tsSG(state.mcViewer.fileCounter).channel = state.mcViewer.sg_channel;
        
        increments = [0 .25 .5 .75  1];
        Xticks = increments .* length(tg);
        Yticks = increments .* length(fg);
        set(state.mcViewer.sg_axis, 'XTick', Xticks);
        set(state.mcViewer.sg_axis, 'YTick', Yticks);
        XtickLabels = increments .* (tg(end) - tg(1)) + tg(1);
        YtickLabels = increments .* (fg(end) - fg(1)) + fg(1);
        set(state.mcViewer.sg_axis, 'XTickLabel', XtickLabels);
        set(state.mcViewer.sg_axis, 'YTickLabel', YtickLabels);           
    else
        sg = state.mcViewer.tsSG(state.mcViewer.fileCounter).SG;
    end
%% Plot Spectrogram

    if ishandle(state.mcViewer.sg_image)
        set(state.mcViewer.sg_image,...
            'CData', sg);
    else
		state.mcViewer.sg_image = image(...
			sg, ...
			'CDataMapping', 'Scaled', ...
			'Parent', state.mcViewer.sg_axis ...
			);
    end
 