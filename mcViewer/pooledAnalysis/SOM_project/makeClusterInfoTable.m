function out = makeClusterInfoTable(indices)
     out = makeTableCellArray(indices);
end


function out = makeTableCellArray(indices)
    global clusters
    
    tca = cell(length(indices), 5);
    for i = 1:length(indices)
        clust = indices(i);
        tca{i, 1} = clusters(clust).experiment;
        tca{i, 2} = clusters(clust).trodeName;
        tca{i, 3} = clusters(clust).cluster;
        tca{i, 4} = clust;        
        try
            tca{i, 5} = clusters(clust).analysis.SpikesByCycleShifted.LEDZScore;        
        catch
            tca{i, 5} = clusters(clust).analysis.SpikeRate.LEDZScore;  
        end
    end
    out=tca;
end
        