function clusterInfoBox(clust, ax)
    global clusters
    
    if nargin < 2
        ax = gca;
    end
    cinfo = {['Indx' num2str(clust)]; clusters(clust).experiment; clusters(clust).trodeName; ['C:' num2str(clusters(clust).cluster)]};
    textBox(cinfo, ax);