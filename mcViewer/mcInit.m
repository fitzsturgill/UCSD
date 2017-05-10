function mcInit

    global state gh

    gh.mcViewer = guihandles(mcViewer);
    gh.sgBrowser = guihandles(sgBrowser);
    gh.mcFeatures = guihandles(mcFeatures);
    openini('mcViewer.ini');
    

    state.mcViewer.tsData={};
    state.mcViewer.tsFilteredData={};
    state.mcViewer.analysis.tsSpikeTimes = {};

    % Default probe == state.mcViewer.probes{1,:}
    state.mcViewer.probes = {...
        'A2X2Tet', [2 7 5 3 1 8 4 6 12 14 15 10 13 11 16 9]; ...
        'A4X4',    [1 3 2 6 7 4 8 5 13 10 12 9 14 16 11 15]; ...
        'A1X16',    [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6]; ...
        'A1X16Poly2',    [14 3 11 6 16 1 15 2 12 5 13 4 10 7 9 8]; ...        
        };
    state.mcViewer.channelOrder = state.mcViewer.probes{1,2}; %default
%     Now that probes are defined update popup menu
    set(gh.mcViewer.probePopUp, 'String', state.mcViewer.probes(:, 1)');
    set(gh.mcViewer.probePopUp, 'Value', 1);
        
    state.mcViewer.validClusterLabels = [ 0 1 1 0 0 0 ]; % cluster labels are numeric within spike structure and correspond to #s 1-6
    state.mcViewer.lineColor={[0 0 0] [1 0 0] [0 1 0] [0 1 1]  [1 0 1] [0 0 1]...
        [0 0 .5] [0 .5 0] [.5 0 0] [1 1 0]};
    
%     state.mcViewer.lineColor={[0 0 0] [1 0 0] [0 0 0] [1 0 0]  [0 0 0] [1 0 0]...
%         [0 0 0] [1 0 0] [0 0 0] [1 0 0]};
%% 
    state.mcViewer.saveFields = {...
        'filePath',...
        'fileBaseName',...
        'fileMode',...
        'nChannels',...
        'channelOrder',...
        'probes',...
        'probeIndex',...
        'probeName',...
        'validClusterLabels',...
        'tsNumberOfFiles',...
        'tsFileNames',...
        'tsFilePaths',...
        'tsCyclePos',...
        'tsFileHeader',...
        'tsTriggerTime',...
        'tsCycleStructure',... % created on fly upon inital loading
        'trode',... % contains all spike sorting data
        'lowPass',...
        'lowCutoff',...
        'highPass',...
        'highCutoff',...
        'sampleRate',...
        'startX',...
        'endX',... %FS MOD 13/6/7
        'deltaX',... %FS MOD 13/6/7
        'blankTrain',...
        'pulse.pulseDelay',...
        'pulse.nPulses',...
        'pulse.pulseISI',...
        'pulse.pulseWidth',...
        'ssb_cycleTable',... % I'll need to update the uitable manually
        'features',...
        'respirationChannel',...
        'respirationDirection',...
        'respirationStringency',...
        'respirationOffset',...
        'alignHist',...
        'alignHistTime',...
        'sg_Clim',...
        'sg_TW',...
        'sg_p',...
        'sg_width',...
        'sg_step',...
        'sg_channel',...
        'tsSG',...
        'bl1',...
        'bl2',...
        'x1',...
        'x2',...
        'protocol',...
        'histBinSize',... % used 50 for manuscript
        'histWindow',...   % used 450 for manuscript- see rules in mcSlidingHistogram
        'tsRejectAcq'...
        };
    
    
    %%
    %Add axes to sgBrowser
    state.mcViewer.sg_figure = gh.sgBrowser.figure1;
    state.mcViewer.sg_axis = axes(...
        'NextPlot', 'add', ...
        'CLim', [0 state.mcViewer.sg_Clim], ...
        'Parent', state.mcViewer.sg_figure, ...
        'Position', [.1 .1 .8 .6]  ...
        );
    
    %% Stuff for respiration figure, implented as a wave plot (Bernardo's
    %% wave class)
    
    respFigurePath = 'C:\Users\User\Documents\MATLAB\mcViewer';
    open (fullfile(respFigurePath, 'respirationPlot.fig'));
    drawnow
    reactivateWavePlot;
    state.mcViewer.respirationFigure=gcf;
    state.mcViewer.respirationAxis=gca;
    set(state.mcViewer.respirationAxis, 'ButtonDownFcn', 'respFigureButtonDownFunction');
    set(state.mcViewer.respirationFigure,...
        'KeyPressFcn', 'respFigureKeyPressFunction',...
        'Pointer', 'crosshair'...
        );
    children=get(gca, 'Children'); % all children should be lines
    for i = 1:length(children)
        set(children(i), 'ButtonDownFcn', 'respFigureButtonDownFunction');
    end
	disp(['*** Loaded Respiration Plot from ' respFigurePath '***']);
    