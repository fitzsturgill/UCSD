function  mcImportClusters(MUA, reload, tag)
    % MUA, bool, only load Multi Unit Activity traces (see mcExportCluster)
    % reload, bool, don't append to existing clusters structure
    global clusters
    evalin('base', 'global clusters');
    
    if nargin < 1
        MUA  = 0;
    end
    
    if nargin < 2
        reload = 0;
    end
    
    if nargin < 3
        tag = ''; % experimental category, e.g. SOM or PV
    end
    
    folderPath = uigetdir('C:\Fitz', 'Select Directory Containing Clusters');
    if isnumeric(folderPath)
        return
    end
    

    cd(folderPath)
    if ~MUA
        contents = dir(fullfile(folderPath, '*cluster.mat'));
    else
        contents = dir(fullfile(folderPath, '*MUA.mat'));        
    end
    disp(['***mcImportClusters: Loading from: ' folderPath ' ***']);
    disp('Clusters:');
    for i = 1:length(contents)
        disp(contents(i).name);
        tempObject=load(fullfile(folderPath, contents(i).name));
        tempObject.tempObject.tag = tag;
        if ~reload && i == 1
            clusters = tempObject.tempObject;
        else
            clusters(end + 1) = tempObject.tempObject;
        end
    end
    clear tempObject
    disp('***mcImportClusters: Finished***');