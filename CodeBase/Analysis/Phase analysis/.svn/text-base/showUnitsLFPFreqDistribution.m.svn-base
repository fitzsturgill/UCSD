function showUnitsLFPFreqDistribution(unitArray, globalax)        
    
    if(~isfield(unitArray, 'spikefreqs'))
        unitArray = addUnitFields(unitArray, 'spikefreqs');
        unitArray = populateUnitFields(unitArray);
    end    
    
    if(nargin < 2)
        globalax = figure;
        set(globalax,'Visible','off','Position',[0 724 528 322]);    
    end               

    freqdistax = axes('Parent', globalax,'Position', [ 1/6,   1/6,            2/3,     2/3]);

    
    freqPlotterFcn = @(unit)(unitFreqDistPlot(unit.spikefreqs, freqdistax, []));
    arrayfun(freqPlotterFcn, unitArray);        
    
    if(nargin < 2)
        set(globalax, 'Visible', 'on');
    end
end