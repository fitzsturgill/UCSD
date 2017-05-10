function h=mcExpBasePrintout(cycles, titleTxt)
    global state
    if nargin < 1 || isempty(cycles)
        cycles=state.mcViewer.ssb_cycleTable;
    end
    
    if nargin < 2
        titleTxt = '';
    end
    
    prefix = mcExpPrefix;
    pageName = [prefix 'Exp_P1'];     
    h = figure('Name', pageName, 'NumberTitle', 'off', 'CloseRequestFcn', 'plotWaveDeleteFcn');
    figure(h);
    h=mcLandscapeFigSetup(h);
    
%%   params.matpos defines position of axesmatrix [LEFT TOP WIDTH HEIGHT].
% for different sections of the layout:
    matpos_title=[0 0 1 .1]; 
    matpos_hist=[0 .1 1 .3];
    matpos_sg = [0 .4 1 .3];
    matpos_ps = [0 .7 1 .3];

    %% 0) Figure Title

    %create axes to hold text identifying experiment, trode, cluster, etc.
    fig_title = [prefix(1:end-1) ' Description:' titleTxt];
    title_ax = textAxes(h, fig_title);
    params.matpos = matpos_title;
    setaxesOnaxesmatrix(title_ax, 1, 1, 1, params, h);
    drawnow;
    
    %% 1) Channel Histograms 
    params.matpos = matpos_hist;
    params.cellmargin = [0.02 0.02 0.05 0.075];
    rows=2;
    columns=8;    
    histHandles = mcChannelHistograms([], h, 1);
%     for i =1:length(histHandles);
%         setXAxisTicks(histHandles(i));
%     end
    setaxesOnaxesmatrix(histHandles, rows, columns, 1:length(histHandles), params, h);

    %% 2) Spectrograms
    params.matpos=matpos_sg;
    if size(cycles, 1) > 1
        params.cellmargin = [0 0 0 .05];     % mroe space needed if mmultiple rows...
    else
        params.cellmargin = [.05 .05 0.05 0.05];
    end
    
    [sgHandles sgImages] = mcAverageSpectrogram(state.mcViewer.sg_channel, cycles, h);
    if length(sgHandles) > 2
        for i=2:length(sgHandles)
            set(sgHandles(i),'YTickLabel', {});
            ylabel(sgHandles(i), '')
            set(sgHandles(i),'XTickLabel', {});
            xlabel(sgHandles(i), '')
        end
    end
    rows = 1;
    columns = length(sgHandles);    
    setaxesOnaxesmatrix(sgHandles, rows, columns, 1:length(sgHandles), params, h);    

    %% 2) Power Spectra
    params.matpos=matpos_ps;
    [psHandles] = mcAveragePowerSpectrum('h', h);
    rows = 1;
    columns = length(psHandles);
    setaxesOnaxesmatrix(psHandles, rows, columns, 1:length(psHandles), params, h);
    disp('kludge in mcExpBasePrintout');return
    filepath  = [state.mcViewer.filePath pageName];
    saveas(h, filepath, 'pdf');
    saveas(h, filepath, 'eps');    
    saveas(h, filepath, 'fig');       
    
    
    