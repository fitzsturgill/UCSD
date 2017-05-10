function mcLoadFileNumbers(fileNumbers, filePath, fileBaseName)
% fileNumbers are numeric suffixes, can be selected using standard matlab
% vector syntax.  E.G.   1:2:9 is equivalent to [1 3 5 7 9]
% Can also use union(1:3:9, 2:3:10)
% In case of reload where filePath and baseName are defined, pass with only
% first argument (fileNumbers)
% Always reloads!!!!!!!    see- line 22 mcLoadDaq(fileNames, filePath, 1);
    global state
    
    if nargin == 1
        filePath = state.mcViewer.filePath;
        fileBaseName = state.mcViewer.fileBaseName;
    end
    
    fileNames = cell(1, length(fileNumbers));
    
    for i=1:length(fileNumbers)
        num = fileNumbers(i);
        fileNames{1, i} = [fileBaseName num2str(num) '.daq'];    
    end
    
    mcLoadDaq(fileNames, filePath, 1);