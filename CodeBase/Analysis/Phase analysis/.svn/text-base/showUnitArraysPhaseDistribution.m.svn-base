function showUnitArraysPhaseDistribution(uaList, globalax)        
    if(~iscell(uaList))
        uaList = {uaList};
    end    

    if(nargin < 2)
        globalax = figure;
        set(globalax,'Visible','off','Position',[0 724 528 322]);    
    end               

    phasedistax = axes('Parent', globalax,'Position', [ 1/6,   1/6,            2/3,     3/4*(2/3)]);
    refwaveax = axes('Parent', globalax, 'Position', [  1/6,   3/4*(2/3)+1/6,  2/3,     1/4*(2/3)]);

    numUA = length(uaList);
    
    for(uaIdx = 1:numUA)
        if(~isfield(uaList{uaIdx}, 'spikephases'))
            uaList{uaIdx} = addUnitFields(uaList{uaIdx}, 'spikephases');
            uaList{uaIdx} = populateUnitFields(uaList{uaIdx});
        end    
        unitPhaseDistPlot([uaList{uaIdx}.spikephases], phasedistax, refwaveax);
    end       
    
    if(nargin < 2)
        set(globalax, 'Visible', 'on');
    end
end
