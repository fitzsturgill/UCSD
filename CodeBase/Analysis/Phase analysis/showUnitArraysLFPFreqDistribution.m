function showUnitArraysLFPFreqDistribution(uaList, globalax)        
    
    if(~iscell(uaList))
        uaList = {uaList};
    end
    
    if(nargin < 2)
        globalax = figure;
        set(globalax,'Visible','off','Position',[0 724 528 322]);    
    end               
    freqdistax = axes('Parent', globalax,'Position', [ 1/6,   1/6,            2/3,     2/3]);   
    
    numUA = length(uaList);
    
    for(uaIdx = 1:numUA)
        if(~isfield(uaList{uaIdx}, 'spikefreqs'))
            uaList{uaIdx} = addUnitFields(uaList{uaIdx}, 'spikefreqs');
            uaList{uaIdx} = populateUnitFields(uaList{uaIdx});
        end    
        unitFreqDistPlot([uaList{uaIdx}.spikefreqs], freqdistax, []);
    end                        
    
    if(nargin < 2)
        set(globalax, 'Visible', 'on');
    end
end