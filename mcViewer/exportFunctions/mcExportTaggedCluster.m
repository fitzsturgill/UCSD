function mcExportTaggedCluster(trode, clusterIndex)
% kludgy export function so that I can group optogenetically tagged
% clusters and compare spike waveforms when LED is off vs on to check for
% spike distortion
    global state
    
    if nargin < 1 || isempty(trode)
        trode = state.mcViewer.ssb_trode;
    end
    
    if nargin < 2 || isempty(clusterIndex)
        clusterIndex = state.mcViewer.ssb_cluster;
    end
    
    expDir = 'C:\Fitz\Data\Analysis\taggedClusters';
    
    
    mcProcessAnalysis_WaveForm(trode, clusterIndex, 'timeRange', [state.mcViewer.x1 state.mcViewer.x2]);
    mcExportCluster(trode, clusterIndex, expDir);
    