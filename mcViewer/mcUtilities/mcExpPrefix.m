function out = mcExpPrefix 
    global state
    
    
    try
        fileMode = state.mcViewer.fileMode;
    catch
        fileMode = 2;
    end
    
    if fileMode == 2
        % generate wave and/or figure prefix (daqcontroller mode)
        firstIndex = strfind(state.mcViewer.tsFileNames{1,1}, '_'); %last underscore
        firstIndex = firstIndex(end);
        lastIndex = strfind(state.mcViewer.tsFileNames{1,1}, '.daq'); %file extension, should only occur once
        firstNum = state.mcViewer.tsFileNames{1,1}(firstIndex + 1 : lastIndex - 1);
        firstIndex = strfind(state.mcViewer.tsFileNames{1,end}, '_'); %last underscore
        firstIndex = firstIndex(end);
        lastIndex = strfind(state.mcViewer.tsFileNames{1,end}, '.daq'); %file extension, should only occur once            
        lastNum = state.mcViewer.tsFileNames{1,end}(firstIndex + 1 : lastIndex - 1);
        out = [state.mcViewer.fileBaseName num2str(firstNum) 'to' num2str(lastNum) '_'];
    elseif fileMode == 1 || fileMode == 3
        % generate wave and/or figure prefix (scanimage mode)
        firstIndex = strfind(state.mcViewer.tsFileNames{1,1}, '_'); %last underscore
        firstIndex = firstIndex(end);
        lastIndex = strfind(state.mcViewer.tsFileNames{1,1}, '.mat'); %file extension, should only occur once
        firstNum = state.mcViewer.tsFileNames{1,1}(firstIndex + 1 : lastIndex - 1);
        firstIndex = strfind(state.mcViewer.tsFileNames{1,end}, '_'); %last underscore
        firstIndex = firstIndex(end);
        lastIndex = strfind(state.mcViewer.tsFileNames{1,end}, '.mat'); %file extension, should only occur once            
        lastNum = state.mcViewer.tsFileNames{1,end}(firstIndex + 1 : lastIndex - 1);
        out = [state.mcViewer.fileBaseName num2str(firstNum) 'to' num2str(lastNum) '_'];        
    end