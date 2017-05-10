function [phasedistax refwaveax] = unitFreqDistPlot(freqs, freqdistax, freqwaveax, fvts, colors)
    % * can be called repeatedly on the same axes to append new data
    % * will figure out how many lines have already been drawn and update
    % colors and markers accordingly

    % fixit do not hardcode Fs!
    Fs = 32000;
    if(nargin < 3)
        phasedistax = axes('Position', [0,0,1,3/4]);
        refwaveax = axes('Position', [0,3/4,1,1/4]);
    end
    if(nargin < 4)
        fvts = [];
    end
    if(nargin < 5)
        colors = {'red', 'blue', 'green', 'magenta', 'cyan', 'yellow', 'black'};
    elseif(~iscell(colors))
        colors = {colors};
    end
        
       
    if(size(freqs, 1) == 1)
        freqs = freqs(:);
    end
    numcases = size(freqs, 2);
    
    % in case this function is called on already populated axes to append
    % new data, we must check other data for maximum y value
    allydata = 0;
    numLines = 0;
    axchildren = get(freqdistax, 'Children');
    for(j = 1:length(axchildren))
        if(~strcmp(get(axchildren(j), 'Type'), 'line'))
            continue;
        end
        tempydata = get(axchildren(j), 'YData');
        allydata = [allydata(:); tempydata(:)];
        numLines = numLines + 1;
    end
    
    % frequency histogram
    binedges = 20:5:80;
    bincenters = 22.5:5:77.5;
    counts = histc(freqs, binedges, 1); 
    counts = counts(1:end-1, :);    
    
    for(i = 1:numcases)
        numLines = numLines + 1;
        cidx = mod(numLines, length(colors)) + ~mod(numLines, length(colors))*length(colors);        
        relcount(:, i) = counts(:,i)./sum(counts(:,i));
        line(bincenters, relcount(:, i), 'Parent', freqdistax, 'Color', colors{cidx});         
        
        % mark mean frequency
        meanFreq = nanmean(freqs(:, i));        
        freqMarkerStyle = [{'\downarrow'} {''} {'\uparrow'} {'bottom'} {'top'} {'left'} {'right'} {' '} {''} {' '}];
        styleIdx = mod(numLines, 2) + ~mod(numLines, 2)*2;
        % have to do the arrow and text in separate text() calls so that
        % the arrow can be centered on the relevant data
        text(meanFreq, 0, [freqMarkerStyle{styleIdx}, freqMarkerStyle{styleIdx+1}], 'Parent', freqdistax, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', freqMarkerStyle{styleIdx+3}, 'Color', colors{cidx});
        text(meanFreq, 0, [freqMarkerStyle{styleIdx+7}, num2str(round(meanFreq)), 'hz', ...
            freqMarkerStyle{styleIdx+8}], 'Parent', freqdistax, 'HorizontalAlignment',freqMarkerStyle{styleIdx+5}, ...
            'VerticalAlignment', freqMarkerStyle{styleIdx+3},'Color', colors{cidx});                        
    end
    
    ylimit = max([allydata(:); relcount(:)]);
    set(freqdistax, 'YLim', [0, ylimit*1.15], 'XLim', [20 80], 'XTick', [20 35 50 65 80]);
    xlabel(freqdistax, 'LFP \gamma frequency (hz)');
    ylabel(freqdistax, '# / total spikes');
    
    % frequency vs. time
    if(~isempty(freqwaveax))
        set(freqwaveax, 'XTick', [], 'YTick', [0.5:0.25:1.5], 'YLim', [0.5 1.5], 'Layer', 'bottom');
        if(~isempty(fvts))
            tdata = ((1:size(fvts, 1)) - 1/2*size(fvts, 1))/Fs;
            for(i = 1:numcases)            
                fvts(:, i) = fvts(:, i) / median(fvts(:, i)); % switch to f(t)/f_median
                cidx = mod(i, length(colors)) + ~mod(i, length(colors))*length(colors);
                line(tdata, fvts(:, i), 'Parent', freqwaveax, 'Color', colors{cidx});
            end        
            set(freqwaveax, 'XTick', min(tdata)+(range(tdata)/5 * (1:6 - 1)));
        elseif(strcmp(get(freqwaveax, 'Visible'), 'on'))
            set(freqwaveax, 'Visible', 'off');
            curpos = get(freqdistax, 'Position');
            set(freqdistax, 'Position', [curpos(1:3), 2*curpos(4)]);
        end
    end
    
end

