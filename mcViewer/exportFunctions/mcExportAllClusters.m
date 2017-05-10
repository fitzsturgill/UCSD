function mcExportAllClusters
    global state
    
    for i=1:length(state.mcViewer.trode)
        for j=1:length(state.mcViewer.trode(i).cluster)
            
            trode = i;
            cluster = j;
            if state.mcViewer.trode(trode).cluster(cluster).label == 4 || state.mcViewer.trode(trode).cluster(cluster).label == 6 % skip garbage clusters and MUA
                continue
            end
%             clusterValue = state.mcViewer.trode(trode).cluster(cluster).cluster;
%             clusterCat = state.mcViewer.trode(trode).cluster(cluster).label;                
%             state.mcViewer.ssb_cluster = cluster;
%             updateGUIByGlobal('state.mcViewer.ssb_cluster');
%             state.mcViewer.ssb_clusterValue = clusterValue;
%             updateGUIByGlobal('state.mcViewer.ssb_clusterValue');
%             state.mcViewer.ssb_clusterCat = clusterCat;
%             updateGUIByGlobal('state.mcViewer.ssb_clusterCat');    
%             mcUpdateSpikeSortBrowser;
%             drawnow;
            mcExportCluster(trode, cluster);
            
        end
    end
            