state.mcViewer.sg_TW=19;
updateGUIByGlobal('state.mcViewer.sg_TW');
h=mcAveragePowerSpectrum;
mcAveragePowerSpectrum_exportWaves;
prefix = mcExpPrefix;
pageName = [prefix '_avgPowerSpectrum'];   
filepath  = [state.mcViewer.filePath pageName];
saveas(h, filepath, 'pdf');
saveas(h, filepath, 'eps');    
saveas(h, filepath, 'fig');


