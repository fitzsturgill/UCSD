function success = mcLoadDaq(filename, filepath, reload)
    %filename can take form of string or string cell array, in which case
    %multiple files can be specified.
    
    %Programatic mode-   specify filename and filepath 
    %Interactive mode- specify neither, call without arguments
    
    
    % notes: 12-9-7 (dealing with scanimage file format)
    % If I separate loading of .daq and *MC*.mat files then I may lose
    % capability of dealing with both down the road due to maintenance of
    % new loading function and not mcLoadDaq
    
    % Therefore- I'm going to integrate both in mcLoadDaq...
    

    global state
    success = 1;
    try
        cd state.mcViewer.filePath;
    catch
    end
    
    % are we decimating the data?
    if state.mcViewer.decimate > 0
        downData = 1;
        state.mcViewer.sampleRate  = state.mcViewer.sampleRate / state.mcViewer.decimate;
        updateGUIByGlobal('state.mcViewer.sampleRate');
    else
        downData = 0;
    end
    % clear fields for reloading
    if nargin == 0 || reload == 1
        state.mcViewer.tsData = {};
        state.mcViewer.tsFilteredData = {};
        state.mcViewer.analysis.tsSpikeTimes = {};
        state.mcViewer.tsFileNames={};
        state.mcViewer.tsXData = {};
%         state.mcViewer.features.respiration=[];
        state.mcViewer.tsTriggerTime = [];
    end
    
    

    if nargin == 0 || (isempty(filename) && isempty(filepath))
        global fileMode
        fileMode=0;
        % User selection for scanimage or Daqcontroller file format
        h = figure('Name', 'Choose load type',...
            'Position', [500 500 340 50],...
            'MenuBar', 'none',...
            'Toolbar', 'none',...
            'NumberTitle', 'off'...
        );

        uicontrol('Style', 'pushbutton', 'String', 'Scanimage', 'Position', [10 10 100 30], 'Callback', @mode1);
        uicontrol('Style', 'pushbutton', 'String', 'DaqController', 'Position', [120 10 100 30], 'Callback', @mode2);
        uicontrol('Style', 'pushbutton', 'String', 'mcAcq', 'Position', [230 10 100 30], 'Callback', @mode3);        
        uiwait(h); % I think I need the uiwait so that matlab will resume executing mcLoadDaq after executing pushbutton callback
        % execution resumes after h is closed
        
        % Select files for loading
        state.mcViewer.fileMode = fileMode;
        if fileMode == 1 || fileMode == 3
            % scanimage mode or mcAcq mode
            [filename, filepath] = uigetfile('*MC*.mat', 'select MC files to load', 'MultiSelect', 'on');
        elseif fileMode == 2
            % DaqController mode
            [filename, filepath] = uigetfile([state.mcViewer.fileBaseName '*.daq'], 'select .daq files to load', 'MultiSelect', 'on');  
        else
            return % no mode has been selected
        end

        if isnumeric(filepath)
            success = 0;
            return
        end
    end
    
    try
        fileMode = state.mcViewer.fileMode;
    catch
        fileMode = 2; % backwards compatible
    end

    if nargin < 3
        reload = 0;
    end

    disp(['***Loading files from: ' filepath '***']);
    
    if ischar(filename)
        filenames{1, 1} = filename;
    else
        filenames = filename;
    end
    
    %set basename and filepath
    underscores = strfind(filenames{1,1}, '_');
    state.mcViewer.fileBaseName = filenames{1,1}(1:underscores(end));
    updateGUIByGlobal('state.mcViewer.fileBaseName');
    state.mcViewer.filePath = filepath;
    updateGUIByGlobal('state.mcViewer.filePath');
    
    % preallocate cell arrays
    % I don't ever use capability to add to already loaded data... (end +
    % nFiles)
    nFiles = size(filenames, 2);
    oldNFiles = size(state.mcViewer.tsData, 2);
    state.mcViewer.tsData{1, end + nFiles} = [];
    state.mcViewer.tsFilteredData{1, end + nFiles} = [];
    state.mcViewer.tsXData{1, end + nFiles} = [];
    state.mcViewer.analysis.tsSpikeTimes{1, end + nFiles} = [];
    state.mcViewer.tsFileNames{1, end + nFiles} = '';
    if isempty(state.mcViewer.tsRejectAcq)
        state.mcViewer.tsRejectAcq = zeros(size(state.mcViewer.tsData));
    end


    h = waitbar(0, 'Loading Daq Files');
    for i = 1:nFiles
        filename = filenames{1, i};
        
        if fileMode == 2
            if isempty(strfind(filename, '.daq'))
                fullFileName = [filepath filename '.daq'];
            else
                fullFileName = [filepath filename];
            end
        elseif fileMode == 1 || fileMode == 3
            if isempty(strfind(filename, '.mat'))
                fullFileName = [filepath filename '.mat'];
            else
                fullFileName = [filepath filename];
            end
        else
            disp('error in mcLoadDaq');
        end


        try
            if fileMode == 2 % Daqcontroller mode
                [data, time, abstime] = daqread(fullFileName);                
            elseif fileMode == 1 % scanImage mode
                mcData = load(fullFileName);
                data = mcData.mcData.data;
                time = mcData.mcData.time;
                header = mcData.mcData.header;
                try
                    cycle = mcData.mcData.cycle;
                catch
                    cycle = [];
                end
            elseif fileMode == 3 % mcAcq mode
                mcData = load(fullFileName);
                data = mcData.mcData.data;
                time = mcData.mcData.time;
                header = ''; % no header currently
            else
                disp('error in mcLoadDaq');
            end
            % are we decimating?
            if downData
                % don't preallocate newData so I don't have to deal with sample
                % numbers that aren't evenly divisible by decimation factor
                newData = [];
                for j = 1:size(data, 2)
                    newData = [newData decimate(data(:, j), state.mcViewer.decimate)];
                end
                data = newData;
            end
                    
                
        catch
            disp ( ['error in loadDaq, invalid filename: ' filename]);
            success = 0;
            return
        end


        if length(find(isnan(data), 1)) > 0
            disp ('multiple triggers not currently supported in mcLoadDaq');
            success = 0;
            return
        end
        

        % Order Channels 1-16 and append any remaining channels from PCI-6259 board.  All these should be same length/duration/sample freq.
        if fileMode == 2 % only if loading DaqController files
            data = data(:, [state.mcViewer.channelOrder length(state.mcViewer.channelOrder)+1:size(data, 2)]);
        end
        
        if i == 1
            state.mcViewer.nChannels = min(size(data, 2), 16); % nChannels == number of multiChannel channels
            state.mcViewer.totalChannels = size(data, 2); % number of multiChannel channels + auxilliary channels from PCI 6259 board
            updateGUIByGlobal('state.mcViewer.nChannels');
            state.mcViewer.analysis.tsSD = zeros(state.mcViewer.nChannels, nFiles);
            state.mcViewer.analysis.autoThresholds=zeros(state.mcViewer.nChannels, nFiles);
            state.mcViewer.analysis.tsMeans = zeros(state.mcViewer.nChannels, nFiles);

            if fileMode == 2
                begin = abstime;
            elseif fileMode == 1
                begin = headerValue(header, 'state.internal.triggerTimeInSeconds', 1);
            end

            %create channel structure and define channel names
            %for reload: skip unless size of new data is different
            if ~(reload && size(data, 2) == length(state.mcViewer.channel)) 
                state.mcViewer.channel = repmat(mcEmptyChannelStruct, 1, size(data, 2)); % create channel structure to be modified            
                for j = 1:size(data, 2)
                    % use mcChannelNames to provide channel names if possible,
                    % otherwise set default names and define mcChannelNames
                    if isfield(state.mcViewer, 'mcChannelNames') && length(state.mcViewer.mcChannelNames) >= j && length(state.mcViewer.mcChannelNames{1, j}) > 0
                        state.mcViewer.channel(j).Name = state.mcViewer.mcChannelNames{1, j};
                    elseif j<=16
                        state.mcViewer.channel(j).Name = ['mc' num2str(j)];
                        state.mcViewer.mcChannelNames{1, j} = ['mc' num2str(j)];
                        state.mcViewer.channel(j).mcFigureInclude = 1;
                    else
                        if j == state.mcViewer.respirationChannel
                            state.mcViewer.channel(j).mcFigureInclude = 1;
                        end
                        state.mcViewer.channel(j).Name = ['aux' num2str(j)];
                        state.mcViewer.mcChannelNames{1, j} = ['aux' num2str(j)];
                    end
                end
            end
        end

        state.mcViewer.tsFileName{1, oldNFiles + i} = filename;
        state.mcViewer.tsData{1, oldNFiles + i} = data;
        state.mcViewer.analysis.tsThresholds(1:state.mcViewer.nChannels,oldNFiles + i) = NaN; %Threshold plots are not visible until thresholds are determined
        state.mcViewer.tsFileNames{1, oldNFiles + i} = filename;
        state.mcViewer.tsFilePaths{1, oldNFiles + i} = filepath;
        % fix trigger time for scanimage mode later... should come from
        % header string
        if fileMode == 2
            state.mcViewer.tsTriggerTime(1, oldNFiles + i) = etime(abstime, begin);
            state.mcViewer.tsCycleStructure=[];
            state.mcViewer.tsFileHeader=[];
%             state.mcViewer.tsCyclePos = 1; % we no longer update cycle by
%             entry into cycle table, so use stored tsCyclePos
        elseif fileMode == 1
            state.mcViewer.tsTriggerTime(1, oldNFiles + i) = headerValue(header, 'state.internal.triggerTimeInSeconds', 1) - begin;
            try
                state.mcViewer.tsCycleStructure(1, oldNFiles + i) = cycle;            
            catch
                state.mcViewer.tsCycleStructure=[];
            end
            try
                state.mcViewer.tsFileHeader{1, oldNFiles + i} = header;
            catch
                state.mcViewer.tsFileHeader{1, oldNFiles + i} = [];
            end
            try
                state.mcViewer.tsCyclePos(1, oldNFiles + i) = cycle.currentCyclePosition; % cycle selection table doesn't modify tsCyclePos in fileMode == 1
            catch
                state.mcViewer.tsCyclePos(1, oldNFiles + i) = 1;
            end
        elseif fileMode == 3 % mcAcq Mode
            state.mcViewer.tsTriggerTime(1, oldNFiles + i) = 0; % trigger time not currently stored            
            state.mcViewer.tsCycleStructure = [];
            state.mcViewer.tsFileHeader=[];
        end
        
        
        startX = state.mcViewer.startX;
        deltaX = 1/state.mcViewer.sampleRate;
        endX = state.mcViewer.startX + deltaX * (size(state.mcViewer.tsData{1, oldNFiles + i}, 1)-1); %FS MOD
        
        state.mcViewer.deltaX = deltaX;
        state.mcViewer.endX = endX;
        
        state.mcViewer.tsXData{1, oldNFiles + i} = startX:deltaX:endX;

        state.mcViewer.fileName = filename;
        updateGUIByGlobal('state.mcViewer.fileName');
        state.mcViewer.fileCounter = size(state.mcViewer.tsData, 2);
        updateGUIByGlobal('state.mcViewer.fileCounter');
        state.mcViewer.displayData = state.mcViewer.tsData{1, oldNFiles + i};
        state.mcViewer.displayXData = state.mcViewer.tsXData{1, oldNFiles + i};
        state.mcViewer.displayThreshData=zeros(size(state.mcViewer.displayData)); %Threshold not determined
        state.mcViewer.displayThreshData(:,:) = NaN;
        state.mcViewer.tsNumberOfFiles = nFiles + oldNFiles;
        waitbar(i/nFiles);
    end
%     if nargin == 0 || reload == 1
%        mcUpdateCyclesByTable; 
%     end
    mcMakeChannelPlots;
    mcInitSgStructure;
    mcUpdateSgFigure;
    close(h);
    
    %% subfunctions - callbacks for file mode loading selection
    % (hObject, eventdata, handles)
function mode1(hObject, eventdata, handles)
    global state fileMode gh
    fileMode = 1;
    h = get(hObject, 'Parent');
    set(gh.mcViewer.probePopUp, 'BackgroundColor', [0.5 0.5 0.5]);
    clf(h);
    close(h);


function mode2(hObject, eventdata, handles)
    global state fileMode gh
    fileMode = 2;
    h = get(hObject, 'Parent');
    set(gh.mcViewer.probePopUp, 'BackgroundColor', [1 1 1]);    
    clf(h);
    close(h);
    
function mode3(hObject, eventdata, handles)
    global state fileMode gh
    fileMode = 3;
    h = get(hObject, 'Parent');
    set(gh.mcViewer.probePopUp, 'BackgroundColor', [0.5 0.5 0.5]);
    clf(h);
    close(h);    

    
    
    
    
    
%% Copy of old mcLoadDaq Below   (before 12-9-7)
% function success = mcLoadDaq(filename, filepath, reload)
%     %filename can take form of string or string cell array, in which case
%     %multiple files can be specified.
%     
%     %Programatic mode-   specify filename and filepath 
%     %Interactive mode- specify neither, call without arguments
%     
%     
%     % notes: 12-9-7 (dealing with scanimage file format)
%     % If I separate loading of .daq and *MC*.mat files then I may lose
%     % capability of dealing with both down the road due to maintenance of
%     % new loading function and not mcLoadDaq
%     
%     % Therefore- I'm going to integrate both in mcLoadDaq...
%     
% 
%     global state
%     success = 1;
%     try
%         cd state.mcViewer.filePath;
%     catch
%     end
%     
%     % are we decimating the data?
%     if state.mcViewer.decimate > 0
%         downData = 1;
%         state.mcViewer.sampleRate  = state.mcViewer.sampleRate / state.mcViewer.decimate;
%         updateGUIByGlobal('state.mcViewer.sampleRate');
%     else
%         downData = 0;
%     end
%     % clear fields for reloading
%     if nargin == 0 || reload == 1
%         state.mcViewer.tsData = {};
%         state.mcViewer.tsFilteredData = {};
%         state.mcViewer.analysis.tsSpikeTimes = {};
%         state.mcViewer.tsFileNames={};
%         state.mcViewer.tsXData = {};
% %         state.mcViewer.features.respiration=[];
%         state.mcViewer.tsTriggerTime = [];
%     end
%     
%     
% 
%     if nargin == 0 || (isempty(filename) && isempty(filepath))
%         [filename, filepath] = uigetfile([state.mcViewer.fileBaseName '*.daq'], 'select .daq files to load', 'MultiSelect', 'on');
%         if isnumeric(filepath)
%             success = 0;
%             return
%         end
%     end
%     
%     if nargin < 3
%         reload = 0;
%     end
% 
%     disp(['***Loading files from: ' filepath '***']);
%     
%     if ischar(filename)
%         filenames{1, 1} = filename;
%     else
%         filenames = filename;
%     end
%     
%     %set basename and filepath
%     underscores = strfind(filenames{1,1}, '_');
%     state.mcViewer.fileBaseName = filenames{1,1}(1:underscores(end));
%     updateGUIByGlobal('state.mcViewer.fileBaseName');
%     state.mcViewer.filePath = filepath;
%     updateGUIByGlobal('state.mcViewer.filePath');
%     
%     % preallocate cell arrays
%     % I don't ever use capability to add to already loaded data... (end +
%     % nFiles)
%     nFiles = size(filenames, 2);
%     oldNFiles = size(state.mcViewer.tsData, 2);
%     state.mcViewer.tsData{1, end + nFiles} = [];
%     state.mcViewer.tsFilteredData{1, end + nFiles} = [];
%     state.mcViewer.tsXData{1, end + nFiles} = [];
%     state.mcViewer.analysis.tsSpikeTimes{1, end + nFiles} = [];
%     state.mcViewer.tsFileNames{1, end + nFiles} = '';
% 
%     
%     h = waitbar(0, 'Loading Daq Files');
%     for i = 1:nFiles
%         filename = filenames{1, i};
%         if isempty(strfind(filename, '.daq'))
%             fullFileName = [filepath filename '.daq'];
%         else
%             fullFileName = [filepath filename];
%         end
% 
% 
%         try
%             [data, time, abstime] = daqread(fullFileName);
%             % are we decimating?
%             if downData
%                 % don't preallocate newData so I don't have to deal with sample
%                 % numbers that aren't evenly divisible by decimation factor
%                 newData = [];
%                 for j = 1:size(data, 2)
%                     newData = [newData decimate(data(:, j), state.mcViewer.decimate)];
%                 end
%                 data = newData;
%             end
%                     
%                 
%         catch
%             disp ( ['error in loadDaq, invalid filename: ' filename]);
%             success = 0;
%             return
%         end
% 
% 
%         if length(find(isnan(data), 1)) > 0
%             disp ('multiple triggers not currently supported in mcLoadDaq');
%             success = 0;
%             return
%         end
%         
%         % Order Channels 1-16 and append any remaining channels from PCI-6259 board.  All these should be same length/duration/sample freq.
%         data = data(:, [state.mcViewer.channelOrder length(state.mcViewer.channelOrder)+1:size(data, 2)]);             
%         
%         if i == 1
%             state.mcViewer.nChannels = min(size(data, 2), 16); % nChannels == number of multiChannel channels
%             state.mcViewer.totalChannels = size(data, 2); % number of multiChannel channels + auxilliary channels from PCI 6259 board
%             updateGUIByGlobal('state.mcViewer.nChannels');
%             state.mcViewer.analysis.tsSD = zeros(state.mcViewer.nChannels, nFiles);
%             state.mcViewer.analysis.autoThresholds=zeros(state.mcViewer.nChannels, nFiles);
%             state.mcViewer.analysis.tsMeans = zeros(state.mcViewer.nChannels, nFiles);
%             begin = abstime;
% 
%             %create channel structure and define channel names
%             %for reload: skip unless size of new data is different
%             if ~(reload && size(data, 2) == length(state.mcViewer.channel)) 
%                 state.mcViewer.channel = repmat(mcEmptyChannelStruct, 1, size(data, 2)); % create channel structure to be modified            
%                 for j = 1:size(data, 2)
%                     % use mcChannelNames to provide channel names if possible,
%                     % otherwise set default names and define mcChannelNames
%                     if isfield(state.mcViewer, 'mcChannelNames') && length(state.mcViewer.mcChannelNames) >= j && length(state.mcViewer.mcChannelNames{1, j}) > 0
%                         state.mcViewer.channel(j).Name = state.mcViewer.mcChannelNames{1, j};
%                     elseif j<=16
%                         state.mcViewer.channel(j).Name = ['mc' num2str(j)];
%                         state.mcViewer.mcChannelNames{1, j} = ['mc' num2str(j)];
%                         state.mcViewer.channel(j).mcFigureInclude = 1;
%                     else
%                         state.mcViewer.channel(j).Name = ['aux' num2str(j)];
%                         state.mcViewer.mcChannelNames{1, j} = ['aux' num2str(j)];
%                     end
%                 end
%             end
%         end
% 
%         state.mcViewer.tsFileName{1, oldNFiles + i} = filename;
%         state.mcViewer.tsData{1, oldNFiles + i} = data;
%         state.mcViewer.analysis.tsThresholds(1:state.mcViewer.nChannels,oldNFiles + i) = NaN; %Threshold plots are not visible until thresholds are determined
%         state.mcViewer.tsFileNames{1, oldNFiles + i} = filename;
%         state.mcViewer.tsFilePaths{1, oldNFiles + i} = filepath;
%         state.mcViewer.tsTriggerTime(1, oldNFiles + i) = etime(abstime, begin);
%         
%         startX = state.mcViewer.startX;
%         deltaX = 1/state.mcViewer.sampleRate;
%         endX = state.mcViewer.startX + deltaX * (size(state.mcViewer.tsData{1, oldNFiles + i}, 1)-1); %FS MOD
%         
%         state.mcViewer.deltaX = deltaX;
%         state.mcViewer.endX = endX;
%         
%         state.mcViewer.tsXData{1, oldNFiles + i} = startX:deltaX:endX;
% 
%         state.mcViewer.fileName = filename;
%         updateGUIByGlobal('state.mcViewer.fileName');
%         state.mcViewer.fileCounter = size(state.mcViewer.tsData, 2);
%         updateGUIByGlobal('state.mcViewer.fileCounter');
%         state.mcViewer.displayData = state.mcViewer.tsData{1, oldNFiles + i};
%         state.mcViewer.displayXData = state.mcViewer.tsXData{1, oldNFiles + i};
%         state.mcViewer.displayThreshData=zeros(size(state.mcViewer.displayData)); %Threshold not determined
%         state.mcViewer.displayThreshData(:,:) = NaN;
%         state.mcViewer.tsNumberOfFiles = nFiles + oldNFiles;
%         waitbar(i/nFiles);
%     end
% %     if nargin == 0 || reload == 1
% %        mcUpdateCyclesByTable; 
% %     end
%     mcMakeChannelPlots;
%     mcInitSgStructure;
%     mcUpdateSgFigure;
%     close(h);
%     
% 
%     
%     
%     
%     
    
    
    
            
    
    
    
    
    
        