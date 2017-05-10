function mcExportCluster(trode, clusterIndex, expDir)
% mcExportCluster(trode, cluster)
% Exports cluster as structure to a set directory
    global state tempObject
    exportDirectory='';
%     exportDirectory = 'C:\Fitz\Data\Analysis_centrifugal_manuscript\bulb_pooledClusters';
%     exportDirectory = 'C:\Fitz\Data\Analysis_centrifugal_manuscript\bulb_pooledClusters_multipleOdors';
%     exportDirectory = 'C:\Fitz\Data\Analysis_PirC_SOM\ChR2';
%      exportDirectory = 'C:\Fitz\Data\Analysis_PirC_SOM\ChR2\redo_2013';
%     exportDirectory = 'C:\Fitz\Data\Analysis_PirC_SOM\Arch_12odors';
%     exportDirectory = 'C:\Fitz\Data\Analysis_PirC_PV';
%     exportDirectory = 'C:\Fitz\Data\Analysis_PirC_PV\stringent';
%         exportDirectory = 'C:\Fitz\Data\Analysis_PirC_PV\multiIntensity';
%         exportDirectory = 'C:\Shea\clusters';
%     exportDirectory = 'C:\Fitz\Data\Analysis\Analysis_PirC_SOM\Arch_12odors_AAseries_waveForm';
%     exportDirectory = 'C:\Fitz\Data\Analysis\Analysis_PirC_SOM\Arch_AAseries_searchForPVCells';


    if nargin < 1 || isempty(trode)
        trode = state.mcViewer.ssb_trode;
    end
    
    if nargin < 2 || isempty(clusterIndex)
        clusterIndex = state.mcViewer.ssb_cluster;
    end
    
    if nargin < 3
        expDir = 1;
    end
    if ischar(expDir)
        exportDirectory = expDir; % kludge
    elseif expDir && isempty(exportDirectory)
        exportDirectory = state.mcViewer.filePath;
    end
    
    
%     analysisFields = {'Quality', 'SpikeRate', 'SpikesByCycle'};
    analysisFields = {'Quality', 'SpikeRate'};    
    presentFields = isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis, analysisFields);
    if ~all(presentFields)
        disp(['Error in mcExportCluster: Analysis Fields Missing: ' presentFields{abs(presentFields - 1)}]);
        return
    elseif ~isfield(state.mcViewer.trode(trode).cluster(clusterIndex).analysis.SpikeRate, 'baseline')
        disp('Error in mcExportCluster: Redo mcProcessAnalysis_SpikeRate'); % change in this function to provide baseline period
    end
    
    thisCluster = state.mcViewer.trode(trode).cluster(clusterIndex);
    tempObject = struct();
    
    tempObject.experiment = mcExpPrefix;
    tempObject.maxChannel = thisCluster.maxChannel;
    tempObject.analysis = thisCluster.analysis;
    tempObject.probe = state.mcViewer.probeName;
    tempObject.label = thisCluster.label;
    tempObject.cluster=thisCluster.cluster;
    tempObject.trodeName = state.mcViewer.trode(trode).name; % kind of a kludge- I'm labelling MUA trodes as "MUATrode"

    if ~isfield(state.mcViewer, 'protocol') || isempty(state.mcViewer.protocol)
        state.mcViewer.protocol = inputdlg('Provide Protocol Name (V1, V2, V3, etc) ','PROTOCOL');
    end
    tempObject.protocol = state.mcViewer.protocol;
    if strcmpi(state.mcViewer.trode(trode).name, 'MUATrode')
        saveName = fullfile(exportDirectory, [mcExpPrefix 't' num2str(trode) 'c' num2str(thisCluster.cluster) '_MUA']);
    else
        saveName = fullfile(exportDirectory, [mcExpPrefix 't' num2str(trode) 'c' num2str(thisCluster.cluster) '_cluster']);
    end
    save(saveName, 'tempObject');
    disp(['*** mcExportCluster: Saving ' saveName '  ***']);
    clear tempObject