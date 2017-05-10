function success = mcLoadSpikes(light)

    global state gh
    if nargin == 0
        light = 0;
    end
    
	success=0;
    try
        cd(state.mcViewer.filePath);
    catch
    end
    [filename, pathname] = uigetfile('*mcSpikes.mat', 'Load mcSpikes Data');
    if isnumeric(filename)
        return
    end
    inputFile=fullfile(pathname, filename);
    state.mcViewer.spikesFilePath=pathname;
    state.mcViewer.spikesFileName=filename;    

	if isempty(find(inputFile=='.'))
		inputFile=[inputFile '.mat'];
	end
	
	tempObject=load(inputFile); 
   

	disp(['Restoring fields from ' inputFile ' ...'])
	for fieldName=state.mcViewer.saveFields
		try
			eval(['state.mcViewer.'	fieldName{1} ' = tempObject.tempObject.' fieldName{1} ';']);
            try
                updateGUIByGlobal(['state.mcViewer.'	fieldName{1}]);
            catch
            end
            
            if strcmp(fieldName{1}, 'ssb_cycleTable')
                oldTable = get(gh.mcViewer.ssb_cycleTable, 'Data');
                newTable = tempObject.tempObject.ssb_cycleTable;
                oldTable(1:size(newTable, 1), 1:size(newTable, 2)) = newTable;
                set(gh.mcViewer.ssb_cycleTable, 'Data', oldTable);
            end
		catch
			disp(['mcLoadSpikes: Error restoring ' fieldName{1}]);
		end
    end
    if ~isempty(state.mcViewer.probeIndex)
        set(gh.mcViewer.probePopUp, 'String', state.mcViewer.probes(:, 1)');
        set(gh.mcViewer.probePopUp, 'Value', state.mcViewer.probeIndex);
    else
        disp('Error in mcLoadSpikes: Probe Order not Retrieved, using current probe order setting');
        val = get(gh.mcViewer.probePopUp, 'Value');
        contents = get(gh.mcViewer.probePopUp, 'String');
        state.mcViewer.channelOrder = state.mcViewer.probes{val, 2};
        state.mcViewer.probeIndex = val;
        state.mcViewer.probeName = contents{val};        
    end
    if light
        disp('Light mode: Daq files not loaded');  % for speed purpposes or to for spike sorting so that matlab doesn't crash
        return
    end
    
    state.mcViewer.respirationChannel=17;
    success = mcLoadDaq(state.mcViewer.tsFileNames, state.mcViewer.filePath, 1);
    mcFilterData(1:state.mcViewer.tsNumberOfFiles);

    %%  delayed activation of respiration plot for speed...
%     reactivateWavePlot;
    %%
	disp('Done')
	clear tempObject