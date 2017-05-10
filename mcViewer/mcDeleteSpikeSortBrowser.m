function mcDeleteSpikeSortBrowser

    global state
    
    if ishandle(state.mcViewer.spikeSortBrowser)
        clf(state.mcViewer.spikeSortBrowser);
        delete(state.mcViewer.spikeSortBrowser);
    end
    
% Fields to set to empty arrays    
    ssb_fields = {'ssb_rasterLines', 'ssb_rasterAxes',...
        'ssb_histLines', 'ssb_histAxes', 'ssb_PSTHLines', 'ssb_PSTHAxes'};
    
    for i = 1:length(ssb_fields)
        state.mcViewer.(ssb_fields{1, i}) = [];
    end
% Fields to return to default Values
    ssb_defaultFieldValuePairs = {...
        'ssb_Cluster', 1;...
        'ssb_clusterValue', 0;...
        'ssb_clusterCat', 0;...
        'ssb_trode', 1 ...
        };
    
    for i = 1:size(ssb_defaultFieldValuePairs, 1)
        state.mcViewer.(ssb_defaultFieldValuePairs{i, 1})...
            = ssb_defaultFieldValuePairs{i, 2};
        updateGUIByGlobal(['state.mcViewer.' ssb_defaultFieldValuePairs{i, 1}]);
    end
    
    
    
    