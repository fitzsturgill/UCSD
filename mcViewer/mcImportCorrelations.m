function  mcImportCorrelations
    global cellCorr
    evalin('base', 'global cellCorr');
     % takes imput from mcCellCorrelations- a directory of saved structures
     % coresponding to cell-cell correlations from multiiple experiments

    folderPath = uigetdir('C:\Fitz', 'Select Directory Containing Correlations');
    if isnumeric(folderPath)
        return
    end
    

    cd(folderPath)
    
    contents = dir(fullfile(folderPath, '*correlations.mat'));

    disp(['***mcImportCorrelations: Loading from: ' folderPath ' ***']);
    disp('Clusters:');
    for i = 1:length(contents)
        disp(contents(i).name);
        tempObject=load(fullfile(folderPath, contents(i).name));
        if  i == 1
            cellCorr = tempObject.tempObject;
        else
            cellCorr(end + 1) = tempObject.tempObject;
        end
    end
    clear tempObject
    disp('***mcImportCorrelations: Finished***');